package net.litqa.generator.forge263.validator;

import freemarker.template.Configuration;
import freemarker.template.Template;
import org.snakeyaml.engine.v2.api.Load;
import org.snakeyaml.engine.v2.api.LoadSettings;

import java.io.IOException;
import java.io.StringReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Static validator for the Forge 26.3 MCreator generator plugin.
 *
 * <p>The validator does not start MCreator. It parses every YAML resource, parses every
 * FreeMarker template and verifies that every template referenced by a generator
 * definition exists. This catches the most common generator regressions before the
 * plugin is handed to a real MCreator instance.</p>
 */
public final class GeneratorValidator {

    private static final Pattern INCLUDE_PATTERN =
            Pattern.compile("<#include\\s+(?:\"([^\"]+)\"|'([^']+)')");
    private static final Pattern NEOFORGE_PATTERN =
            Pattern.compile("net\\.neoforged|neoforge:|NeoForgeMod|CommonHooks");

    private final Path resourcesRoot;
    private final List<String> errors = new ArrayList<>();
    private final Set<String> parsedYamlFiles = new LinkedHashSet<>();
    private final Set<String> parsedTemplates = new LinkedHashSet<>();
    private final Set<String> checkedTemplateReferences = new LinkedHashSet<>();

    private final Map<String, Path> generatorDirectories = new LinkedHashMap<>();
    private final Map<String, List<String>> generatorImports = new LinkedHashMap<>();

    private GeneratorValidator(Path resourcesRoot) {
        this.resourcesRoot = resourcesRoot;
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 1) {
            System.err.println("usage: GeneratorValidator <plugin-resources-directory>");
            System.exit(2);
        }

        GeneratorValidator validator = new GeneratorValidator(Path.of(args[0]).toAbsolutePath().normalize());
        boolean success = validator.run();

        System.out.println();
        System.out.println("Validated resources: " + validator.resourcesRoot);
        System.out.println("  generators:        " + validator.generatorDirectories.size());
        System.out.println("  YAML documents:    " + validator.parsedYamlFiles.size());
        System.out.println("  FTL templates:     " + validator.parsedTemplates.size());
        System.out.println("  template refs:     " + validator.checkedTemplateReferences.size());

        if (!success) {
            System.out.println();
            System.out.println("Validation failed with " + validator.errors.size() + " error(s):");
            validator.errors.forEach(error -> System.out.println("  - " + error));
            System.exit(1);
        }

        System.out.println();
        System.out.println("VALIDATION PASSED");
    }

    private boolean run() throws IOException {
        validatePluginMetadata();
        discoverGenerators();

        if (generatorDirectories.isEmpty()) {
            error("no generator directory with a generator.yaml was found");
            return false;
        }

        generatorDirectories.forEach(this::validateGeneratorConfiguration);
        validateYamlDocuments();
        validateTemplates();
        validateForgeOnlyResources();
        validateMappings();

        return errors.isEmpty();
    }

    private void validatePluginMetadata() {
        Path pluginJson = resourcesRoot.resolve("plugin.json");
        if (!Files.isRegularFile(pluginJson)) {
            error("missing plugin.json at the plugin root");
            return;
        }

        Map<?, ?> metadata = loadYaml(pluginJson);
        if (metadata == null) {
            return;
        }

        Object id = metadata.get("id");
        if (!(id instanceof String) || !((String) id).startsWith("generator-")) {
            error("plugin.json: id must be a generator id starting with 'generator-'");
        }

        Object weight = metadata.get("weight");
        if (weight != null && !(weight instanceof Number)) {
            error("plugin.json: weight must be a number");
        }

        Object supportedVersions = metadata.get("supportedversions");
        if (supportedVersions != null) {
            if (!(supportedVersions instanceof List)) {
                error("plugin.json: supportedversions must be a list");
            } else {
                for (Object version : (List<?>) supportedVersions) {
                    if (!(version instanceof Number)) {
                        error("plugin.json: supportedversions entries must be numbers, found " + version);
                    }
                }
            }
        }

        Map<?, ?> info = asMap(metadata.get("info"));
        if (info == null) {
            error("plugin.json: info section is missing");
        } else {
            requireText(info, "name", "plugin.json info");
            requireText(info, "version", "plugin.json info");
            requireText(info, "author", "plugin.json info");
        }
    }

    private void discoverGenerators() throws IOException {
        try (Stream<Path> children = Files.list(resourcesRoot)) {
            children.filter(Files::isDirectory)
                    .filter(directory -> Files.isRegularFile(directory.resolve("generator.yaml")))
                    .sorted()
                    .forEach(directory -> generatorDirectories.put(directory.getFileName().toString(), directory));
        }
    }

    private void validateGeneratorConfiguration(String name, Path directory) {
        Path file = directory.resolve("generator.yaml");
        Map<?, ?> configuration = loadYaml(file);
        if (configuration == null) {
            return;
        }

        String context = "generator.yaml (" + name + ")";
        requireText(configuration, "name", context);
        requireText(configuration, "buildfileversion", context);
        requireText(configuration, "source_root", context);
        requireText(configuration, "res_root", context);
        requireText(configuration, "mod_assets_root", context);

        String status = asText(configuration.get("status"));
        if (status != null && !Set.of("stable", "dev", "deprecated").contains(status)) {
            error(context + ": status must be one of stable, dev, deprecated");
        }

        Map<?, ?> gradle = asMap(configuration.get("gradle"));
        if (gradle == null) {
            error(context + ": gradle section is missing");
        } else {
            requireText(gradle, "run_client", context + " gradle");
            requireText(gradle, "export_file", context + " gradle");
        }

        Map<?, ?> languageFile = asMap(configuration.get("language_file"));
        if (languageFile == null) {
            error(context + ": language_file section is missing");
        } else {
            requireText(languageFile, "format", context + " language_file");
            requireText(languageFile, "root_folder", context + " language_file");
            requireText(languageFile, "langfile_name", context + " language_file");
        }

        List<String> imports = new ArrayList<>();
        Object rawImports = configuration.get("import");
        if (rawImports instanceof List) {
            for (Object entry : (List<?>) rawImports) {
                if (entry != null) {
                    imports.add(entry.toString());
                }
            }
        }
        generatorImports.put(name, imports);

        validateTemplateList(configuration.get("base_templates"), name, directory, context + " base_templates");
        validateTemplateList(configuration.get("sources_setup_tasks"), name, directory, context + " sources_setup_tasks");

        Map<?, ?> tags = asMap(configuration.get("tags"));
        if (tags != null && tags.get("template") != null) {
            checkTemplateReference(name, directory, tags.get("template").toString(), context + " tags");
        }
    }

    private void validateYamlDocuments() throws IOException {
        try (Stream<Path> files = Files.walk(resourcesRoot)) {
            files.filter(Files::isRegularFile)
                    .filter(file -> {
                        String fileName = file.getFileName().toString().toLowerCase();
                        return fileName.endsWith(".yaml") || fileName.endsWith(".yml");
                    })
                    .sorted()
                    .forEach(this::loadYaml);
        }
    }

    private void validateTemplates() throws IOException {
        List<Path> templates;
        try (Stream<Path> files = Files.walk(resourcesRoot)) {
            templates = files.filter(Files::isRegularFile)
                    .filter(file -> file.getFileName().toString().endsWith(".ftl"))
                    .sorted()
                    .collect(Collectors.toList());
        }

        Configuration configuration = createFreemarkerConfiguration();

        for (Path templateFile : templates) {
            String relative = resourcesRoot.relativize(templateFile).toString().replace('\\', '/');
            parsedTemplates.add(relative);

            String source;
            try {
                source = Files.readString(templateFile, StandardCharsets.UTF_8);
            } catch (IOException exception) {
                error(relative + ": could not be read: " + exception.getMessage());
                continue;
            }

            try {
                new Template(relative, new StringReader(source), configuration, "UTF-8");
            } catch (Exception exception) {
                error(relative + ": FreeMarker syntax error: " + firstLine(exception.getMessage()));
            }

            validateTemplateIncludes(relative, templateFile, source);
        }

        validateDefinitionTemplateReferences();
    }

    private void validateDefinitionTemplateReferences() throws IOException {
        List<Path> definitions;
        try (Stream<Path> files = Files.walk(resourcesRoot)) {
            definitions = files.filter(Files::isRegularFile)
                    .filter(file -> file.getFileName().toString().endsWith(".definition.yaml")
                            || file.getFileName().toString().endsWith(".fragment.yaml"))
                    .sorted()
                    .collect(Collectors.toList());
        }

        for (Path definition : definitions) {
            Map<?, ?> document = loadYaml(definition);
            if (document == null) {
                continue;
            }

            String relative = resourcesRoot.relativize(definition).toString().replace('\\', '/');
            Path generatorDirectory = findGeneratorDirectory(definition);
            if (generatorDirectory == null) {
                error(relative + ": is not located inside a generator directory");
                continue;
            }

            collectTemplateReferences(document, generatorDirectory.getFileName().toString(), generatorDirectory, relative);
        }
    }

    private void collectTemplateReferences(Object node, String generatorName, Path generatorDirectory, String context) {
        if (node instanceof Map) {
            Map<?, ?> map = (Map<?, ?>) node;
            for (Map.Entry<?, ?> entry : map.entrySet()) {
                String key = String.valueOf(entry.getKey());
                Object value = entry.getValue();
                if ("template".equals(key) && value != null) {
                    checkTemplateReference(generatorName, generatorDirectory, value.toString(), context);
                } else {
                    collectTemplateReferences(value, generatorName, generatorDirectory, context);
                }
            }
        } else if (node instanceof Collection) {
            for (Object child : (Collection<?>) node) {
                collectTemplateReferences(child, generatorName, generatorDirectory, context);
            }
        }
    }

    private void validateTemplateList(Object rawList, String generatorName, Path generatorDirectory, String context) {
        if (rawList == null) {
            return;
        }
        if (!(rawList instanceof List)) {
            error(context + ": must be a list");
            return;
        }

        for (Object entry : (List<?>) rawList) {
            Map<?, ?> templateDefinition = asMap(entry);
            if (templateDefinition == null) {
                error(context + ": entries must be maps");
                continue;
            }

            Object template = templateDefinition.get("template");
            if (template == null) {
                error(context + ": an entry is missing the template key");
                continue;
            }

            checkTemplateReference(generatorName, generatorDirectory, template.toString(), context);
        }
    }

    private void checkTemplateReference(String generatorName, Path generatorDirectory, String reference,
                                        String context) {
        String normalized = reference.replace('\\', '/');
        checkedTemplateReferences.add(generatorName + "/templates/" + normalized);

        if (!templateExists(generatorName, generatorDirectory, normalized)) {
            error(context + ": template '" + normalized + "' does not exist in generator '" + generatorName + "'");
        }
    }

    private boolean templateExists(String generatorName, Path generatorDirectory, String reference) {
        if (Files.isRegularFile(generatorDirectory.resolve("templates").resolve(reference))) {
            return true;
        }

        for (String imported : generatorImports.getOrDefault(generatorName, List.of())) {
            Path importedDirectory = generatorDirectories.get(imported);
            if (importedDirectory != null
                    && Files.isRegularFile(importedDirectory.resolve("templates").resolve(reference))) {
                return true;
            }
        }

        return false;
    }

    private void validateTemplateIncludes(String relative, Path templateFile, String source) {
        Matcher matcher = INCLUDE_PATTERN.matcher(source);
        while (matcher.find()) {
            String include = matcher.group(1) != null ? matcher.group(1) : matcher.group(2);
            if (include == null || include.contains("${")) {
                continue;
            }

            Path generatorDirectory = findGeneratorDirectory(templateFile);
            boolean found;

            if (include.startsWith("/")) {
                // Absolute include names are resolved by the generator template and utils roots.
                String rooted = include.substring(1);
                found = generatorDirectory != null
                        && (Files.isRegularFile(generatorDirectory.resolve("templates").resolve(rooted))
                        || Files.isRegularFile(generatorDirectory.resolve("utils").resolve(rooted)));
            } else {
                found = Files.isRegularFile(templateFile.getParent().resolve(include).normalize());
                if (!found && generatorDirectory != null) {
                    // MCreator resolves relative includes from both the templates and utils roots.
                    String normalized = include.replace('\\', '/');
                    while (normalized.startsWith("../")) {
                        normalized = normalized.substring(3);
                    }
                    found = Files.isRegularFile(generatorDirectory.resolve("templates").resolve(normalized))
                            || Files.isRegularFile(generatorDirectory.resolve("utils").resolve(normalized));
                }
            }

            if (!found) {
                error(relative + ": included template '" + include + "' could not be resolved");
            }
        }
    }

    private void validateForgeOnlyResources() throws IOException {
        List<Path> resources;
        try (Stream<Path> files = Files.walk(resourcesRoot)) {
            resources = files.filter(Files::isRegularFile)
                    .filter(file -> {
                        String name = file.getFileName().toString();
                        return name.endsWith(".ftl") || name.endsWith(".yaml");
                    })
                    .sorted()
                    .toList();
        }

        for (Path resource : resources) {
            List<String> lines = Files.readAllLines(resource, StandardCharsets.UTF_8);
            for (int i = 0; i < lines.size(); i++) {
                Matcher matcher = NEOFORGE_PATTERN.matcher(lines.get(i));
                if (matcher.find()) {
                    error(resourcesRoot.relativize(resource) + ":" + (i + 1)
                            + ": forbidden NeoForge reference '" + matcher.group() + "'");
                }
            }
        }
    }

    private void validateMappings() {
        for (Map.Entry<String, Path> generator : generatorDirectories.entrySet()) {
            Path mappingsDirectory = generator.getValue().resolve("mappings");
            if (!Files.isDirectory(mappingsDirectory)) {
                continue;
            }

            Path blocksItems = mappingsDirectory.resolve("blocksitems.yaml");
            if (Files.isRegularFile(blocksItems)) {
                validateBlocksItemsMapping(generator.getKey(), blocksItems);
            }

            try (Stream<Path> mappings = Files.list(mappingsDirectory)) {
                mappings.filter(Files::isRegularFile)
                        .filter(file -> file.getFileName().toString().endsWith(".yaml"))
                        .forEach(file -> {
                            Map<?, ?> mapping = loadYaml(file);
                            if (mapping != null && mapping.isEmpty()) {
                                error(generator.getKey() + "/mappings/" + file.getFileName() + ": mapping is empty");
                            }
                        });
            } catch (IOException exception) {
                error(generator.getKey() + "/mappings: could not be listed: " + exception.getMessage());
            }
        }
    }

    private void validateBlocksItemsMapping(String generatorName, Path blocksItems) {
        Map<?, ?> mapping = loadYaml(blocksItems);
        if (mapping == null) {
            return;
        }

        Object fallback = mapping.get("_default");
        if (!(fallback instanceof List) || ((List<?>) fallback).size() < 2) {
            error(generatorName + "/mappings/blocksitems.yaml: _default must be a two-column list");
        }

        int checked = 0;
        for (Map.Entry<?, ?> entry : mapping.entrySet()) {
            String key = String.valueOf(entry.getKey());
            if (key.startsWith("_")) {
                continue;
            }
            Object value = entry.getValue();
            if (value instanceof List) {
                List<?> columns = (List<?>) value;
                if (columns.size() < 2) {
                    error(generatorName + "/mappings/blocksitems.yaml: '" + key
                            + "' must contain a Java expression and a registry name");
                } else if (!(columns.get(0) instanceof String) || !(columns.get(1) instanceof String)) {
                    error(generatorName + "/mappings/blocksitems.yaml: '" + key
                            + "' columns must be strings");
                }
                checked++;
            } else {
                error(generatorName + "/mappings/blocksitems.yaml: '" + key
                        + "' must use the two-column list form");
            }
        }

        if (checked < 100) {
            error(generatorName + "/mappings/blocksitems.yaml: suspiciously few entries (" + checked + ")");
        }
    }

    private Configuration createFreemarkerConfiguration() {
        Configuration configuration = new Configuration(Configuration.VERSION_2_3_35);
        configuration.setDefaultEncoding("UTF-8");
        configuration.setLogTemplateExceptions(false);
        configuration.setTemplateExceptionHandler(freemarker.template.TemplateExceptionHandler.RETHROW_HANDLER);
        return configuration;
    }

    private Path findGeneratorDirectory(Path file) {
        Path current = Files.isDirectory(file) ? file : file.getParent();
        while (current != null && current.startsWith(resourcesRoot)) {
            if (Files.isRegularFile(current.resolve("generator.yaml"))) {
                return current;
            }
            current = current.getParent();
        }
        return null;
    }

    private Map<?, ?> loadYaml(Path file) {
        String relative = resourcesRoot.relativize(file).toString().replace('\\', '/');
        parsedYamlFiles.add(relative);

        try {
            String content = Files.readString(file, StandardCharsets.UTF_8);
            if (content.isBlank()) {
                error(relative + ": file is empty");
                return null;
            }

            LoadSettings settings = LoadSettings.builder().setLabel(relative).build();
            Object loaded = new Load(settings).loadFromString(content);
            if (!(loaded instanceof Map)) {
                error(relative + ": root document must be a mapping");
                return null;
            }
            return (Map<?, ?>) loaded;
        } catch (Exception exception) {
            error(relative + ": YAML error: " + firstLine(exception.getMessage()));
            return null;
        }
    }

    private void requireText(Map<?, ?> map, String key, String context) {
        Object value = map.get(key);
        if (value == null || value.toString().isBlank()) {
            error(context + ": missing required key '" + key + "'");
        }
    }

    private static Map<?, ?> asMap(Object value) {
        return value instanceof Map ? (Map<?, ?>) value : null;
    }

    private static String asText(Object value) {
        return value == null ? null : value.toString();
    }

    private static String firstLine(String message) {
        if (message == null) {
            return "(no details)";
        }
        int newline = message.indexOf('\n');
        return newline < 0 ? message : message.substring(0, newline);
    }

    private void error(String message) {
        errors.add(message);
    }
}
