plugins {
    id 'java'
    id 'eclipse'
    id 'base'
    id 'net.minecraftforge.gradle' version '[7.0.17,8)'
}

version = '1.0'
base.archivesName = "modid"

java.toolchain.languageVersion = JavaLanguageVersion.of(25)

sourceSets.main.resources { srcDir 'src/generated/resources' }

minecraft {
    runs {
        configureEach {
            workingDir = layout.projectDirectory.dir('run')
        }

        register('client')
        register('server') {
            args '--nogui'
        }
    }
}

repositories {
    minecraft.mavenizer(it)
    maven fg.forgeMaven
    maven fg.minecraftLibsMaven
    mavenCentral()
}

dependencies {
    implementation minecraft.dependency('net.minecraftforge:forge:26.3-66.1.5')
}

tasks.withType(JavaCompile).configureEach {
    options.encoding = 'UTF-8'
}

// MCreator stores both armor layers in the humanoid folder. Copy them to the
// leggings folder so the equipment asset can resolve both layer textures.
def resourcesAssetsDir = new File(sourceSets.main.output.resourcesDir, 'assets')

tasks.named('processResources', ProcessResources) {
    outputs.upToDateWhen { false }

    doLast {
        def copyTree = { File sourceDir, File targetDir ->
            if (sourceDir.exists()) {
                targetDir.mkdirs()
                sourceDir.eachFileRecurse { File sourceFile ->
                    if (sourceFile.isFile()) {
                        def relative = sourceDir.toPath().relativize(sourceFile.toPath()).toString()
                        def targetFile = new File(targetDir, relative)
                        targetFile.parentFile.mkdirs()
                        java.nio.file.Files.copy(sourceFile.toPath(), targetFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING)
                    }
                }
            }
        }

        if (resourcesAssetsDir.exists()) {
            resourcesAssetsDir.eachDir { File modDir ->
                def humanoid = new File(modDir, 'textures/entity/equipment/humanoid')
                def leggings = new File(modDir, 'textures/entity/equipment/humanoid_leggings')
                def legacyArmor = new File(modDir, 'textures/models/armor')

                copyTree(legacyArmor, humanoid)
                copyTree(new File(modDir, 'textures/entities'), humanoid)
                copyTree(humanoid, leggings)
                copyTree(new File(modDir, 'textures/entities'), leggings)


                // SignEditScreen resolves GUI sign textures from the minecraft namespace.
                // Copy mod-owned sign editors into assets/minecraft so they are visible.
                ['textures/gui/signs', 'textures/gui/hanging_signs'].each { String signPath ->
                    File signSource = new File(modDir, signPath)
                    File signTarget = new File(resourcesAssetsDir, "minecraft/${signPath}")
                    copyTree(signSource, signTarget)
                }

                // Dynamic fluid container models resolve their still texture from the item atlas.
                modDir.listFiles()?.findAll { it.isFile() && it.name.startsWith('fluid_') && it.name.endsWith('_item_texture.txt') }?.each { File marker ->
                    marker.eachLine { String line ->
                        def textureName = line.trim()
                        if (textureName) {
                            def source = new File(modDir, "textures/block/${textureName}.png")
                            if (source.exists()) {
                                def target = new File(modDir, "textures/item/${textureName}.png")
                                target.parentFile.mkdirs()
                                java.nio.file.Files.copy(source.toPath(), target.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING)

                                def meta = new File(source.path + '.mcmeta')
                                if (meta.exists()) {
                                    def metaTarget = new File(modDir, "textures/item/${textureName}.png.mcmeta")
                                    java.nio.file.Files.copy(meta.toPath(), metaTarget.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

apply from: 'mcreator.gradle'

// Sign editors resolve their GUI textures from the minecraft namespace.
// Copy mod sign textures again after resource processing, using the actual
// ForgeGradle output directory.
def signGuiSourceRoot = file('src/main/resources/assets')
def signGuiTargetRoot = layout.buildDirectory.dir('sourceSets/main/assets').get().asFile

tasks.register('copySignGuiTextures') {
    doLast {
        if (!signGuiSourceRoot.exists())
            return
        signGuiSourceRoot.eachDir { File modDir ->
            if (modDir.name == 'minecraft')
                return
            ['signs', 'hanging_signs'].each { String kind ->
                File sourceDir = new File(modDir, "textures/gui/${kind}")
                if (!sourceDir.exists())
                    return
                List<String> targetKinds = kind == 'hanging_signs' ? ['hanging_signs', 'signs'] : ['signs']
                targetKinds.each { String targetKind ->
                    File targetDir = new File(signGuiTargetRoot, "minecraft/textures/gui/${targetKind}")
                    targetDir.mkdirs()
                    sourceDir.eachFileRecurse { File sourceFile ->
                        if (sourceFile.isFile()) {
                            File targetFile = new File(targetDir, sourceFile.name)
                            java.nio.file.Files.copy(sourceFile.toPath(), targetFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING)
                        }
                    }
                }
            }
        }
    }
}
tasks.named('processResources') { finalizedBy 'copySignGuiTextures' }

// Generate per-piece equipment assets from MCreator armor texture markers.
// Keeping this out of the FTL templates avoids aborting armor Java generation.
def armorSourceRoot = file('src/main/resources/assets')
def armorTargetRoot = layout.buildDirectory.dir('sourceSets/main/assets').get().asFile

tasks.register('copyArmorEquipmentTextures') {
    doLast {
        if (!armorSourceRoot.exists())
            return
        armorSourceRoot.eachDir { File modDir ->
            if (modDir.name == 'minecraft')
                return
            File equipmentSource = new File(modDir, 'equipment')
            File equipmentTarget = new File(new File(armorTargetRoot, modDir.name), 'equipment')
            if (!equipmentSource.exists())
                return
            equipmentSource.listFiles()?.findAll { it.isFile() && it.name.endsWith('_custom_textures.txt') }?.each { File marker ->
                String base = marker.name.substring(0, marker.name.length() - '_custom_textures.txt'.length())
                List<String> lines = java.nio.file.Files.readAllLines(marker.toPath())
                if (lines.isEmpty())
                    return
                String armorFile = lines[0].trim()
                String helmet = lines.size() > 1 ? lines[1].trim() : 'From armor'
                String body = lines.size() > 2 ? lines[2].trim() : 'From armor'
                String leggings = lines.size() > 3 ? lines[3].trim() : 'From armor'
                String boots = lines.size() > 4 ? lines[4].trim() : 'From armor'
                def texture = { String custom, String layer ->
                    if (custom && custom != 'From armor')
                        return "${modDir.name}:" + custom.replace('.png', '')
                    return "${modDir.name}:${armorFile}_${layer}"
                }
                Map<String,String> humanoid = [
                    helmet: texture(helmet, 'layer_1'),
                    chestplate: texture(body, 'layer_1'),
                    leggings: texture(null, 'layer_1'),
                    boots: texture(boots, 'layer_1')
                ]
                Map<String,String> leggingsLayer = [
                    helmet: "${modDir.name}:${armorFile}_layer_2",
                    chestplate: "${modDir.name}:${armorFile}_layer_2",
                    leggings: texture(leggings, 'layer_2'),
                    boots: "${modDir.name}:${armorFile}_layer_2"
                ]
                ['helmet', 'chestplate', 'leggings', 'boots'].each { String part ->
                    String json = String.format('''{
  "layers": {
    "humanoid": [
      {
        "texture": "%s"
      }
    ],
    "humanoid_leggings": [
      {
        "texture": "%s"
      }
    ]
  }
}
''', humanoid[part], leggingsLayer[part])
                    File target = new File(equipmentTarget, "${base}_${part}.json")
                    target.parentFile.mkdirs()
                    java.nio.file.Files.writeString(target.toPath(), json, java.nio.charset.StandardCharsets.UTF_8)
                }
            }
        }
    }
}
tasks.named('processResources') { finalizedBy 'copyArmorEquipmentTextures' }

// MCreator's armor Java template is kept stable for generation, then this task
// upgrades the generated material bindings to per-piece equipment assets.
def armorJavaRoot = file('src/main/java')

tasks.register('patchArmorJava') {
    doLast {
        if (!armorJavaRoot.exists())
            return
        armorJavaRoot.eachFileRecurse { File source ->
            if (!source.isFile() || !source.name.endsWith('.java'))
                return
            String text = source.getText('UTF-8')
            if (!text.contains('ARMOR_MATERIAL'))
                return
            def matcher = text =~ /(?s)public static ArmorMaterial ARMOR_MATERIAL = new ArmorMaterial\((.*?)\);/
            if (!matcher.find())
                return
            String body = matcher.group(1)
            List<String> ids = (body =~ /Identifier\.parse\("([^"]+)"\)/).collect { it[1] }
            if (ids.isEmpty())
                return
            String fullId = ids[ids.size() - 1]
            int colon = fullId.indexOf(':')
            String namespace = colon >= 0 ? fullId.substring(0, colon) : 'test'
            String base = colon >= 0 ? fullId.substring(colon + 1) : fullId
            body = body.replaceAll(/ResourceKey\.create\(EquipmentAssets\.ROOT_ID, Identifier\.parse\("[^"]+"\)\)/, 'ResourceKey.create(EquipmentAssets.ROOT_ID, Identifier.parse(assetPath))')
            String replacement = "public static ArmorMaterial createArmorMaterial(String assetPath) {\n\t\treturn new ArmorMaterial(" + body + ");\n\t}\n\n" +
                "\tpublic static final ArmorMaterial HELMET_MATERIAL = createArmorMaterial(\"${namespace}:${base}_helmet\");\n" +
                "\tpublic static final ArmorMaterial CHESTPLATE_MATERIAL = createArmorMaterial(\"${namespace}:${base}_chestplate\");\n" +
                "\tpublic static final ArmorMaterial LEGGINGS_MATERIAL = createArmorMaterial(\"${namespace}:${base}_leggings\");\n" +
                "\tpublic static final ArmorMaterial BOOTS_MATERIAL = createArmorMaterial(\"${namespace}:${base}_boots\");"
            text = matcher.replaceFirst(java.util.regex.Matcher.quoteReplacement(replacement))
            text = text.replace('properties.humanoidArmor(ARMOR_MATERIAL, ArmorType.HELMET)', 'properties.humanoidArmor(HELMET_MATERIAL, ArmorType.HELMET)')
            text = text.replace('properties.humanoidArmor(ARMOR_MATERIAL, ArmorType.CHESTPLATE)', 'properties.humanoidArmor(CHESTPLATE_MATERIAL, ArmorType.CHESTPLATE)')
            text = text.replace('properties.humanoidArmor(ARMOR_MATERIAL, ArmorType.LEGGINGS)', 'properties.humanoidArmor(LEGGINGS_MATERIAL, ArmorType.LEGGINGS)')
            text = text.replace('properties.humanoidArmor(ARMOR_MATERIAL, ArmorType.BOOTS)', 'properties.humanoidArmor(BOOTS_MATERIAL, ArmorType.BOOTS)')
            source.setText(text, 'UTF-8')
        }
    }
}
tasks.named('compileJava') { dependsOn 'patchArmorJava' }

// MCreator's network template cannot reliably enumerate GUI/keybind collections.
// Populate the generated channel from the message classes that actually exist.
def networkJavaRoot = file('src/main/java')

tasks.register('patchNetworkJava') {
    doLast {
        if (!networkJavaRoot.exists())
            return
        networkJavaRoot.eachFileRecurse { File source ->
            if (!source.isFile() || !source.name.endsWith('Network.java'))
                return
            File dir = source.parentFile
            List<File> messages = dir.listFiles()?.findAll { it.isFile() && it.name.endsWith('Message.java') }?.sort { it.name } ?: []
            if (messages.isEmpty())
                return
            String text = source.getText('UTF-8')
            if (text.contains('.addMain('))
                return
            String additions = messages.collect { File message ->
                String className = message.name.substring(0, message.name.length() - '.java'.length())
                "\t\t\t\t.addMain(${className}.class, ${className}.STREAM_CODEC, ${className}::handle)"
            }.join('\n')
            text = text.replace('.bidirectional().build()', ".bidirectional()\n" + additions + "\n\t\t\t.build()")
            source.setText(text, 'UTF-8')
        }
    }
}
tasks.named('compileJava') { dependsOn 'patchNetworkJava' }

// Custom biome trees inherit vanilla's would_survive(oak_sapling) placement
// predicate, which never matches custom ground blocks. Remove that predicate
// from generated tree placed-features so the tree feature can place.
def treeSourceRoot = file('src/main/resources/data')

tasks.register('patchTreePlacement') {
    doLast {
        if (!treeSourceRoot.exists())
            return
        treeSourceRoot.eachDir { File modData ->
            File sourceDir = new File(modData, 'worldgen/placed_feature')
            if (!sourceDir.exists())
                return
            sourceDir.listFiles()?.findAll { it.isFile() && it.name.endsWith('_tree.json') }?.each { File source ->
                def json = new groovy.json.JsonSlurper().parse(source)
                if (json.placement instanceof List && json.placement.removeAll { it instanceof Map && it.type == 'minecraft:block_predicate_filter' }) {
                    source.setText(groovy.json.JsonOutput.prettyPrint(groovy.json.JsonOutput.toJson(json)), 'UTF-8')
                }
            }
        }
    }
}
tasks.named('processResources') { dependsOn 'patchTreePlacement' }


// Ensure custom tree placed-features are present in the merged resource output
// and do not inherit the vanilla oak-sapling worldgen predicate.
def treeCopySourceRoot = file('src/main/resources/data')
def treeCopyTargetRoots = [
    layout.buildDirectory.dir('sourceSets/main/data').get().asFile,
    layout.buildDirectory.dir('resources/main/data').get().asFile
]
tasks.register('copyTreePlacement') {
    doLast {
        if (!treeCopySourceRoot.exists())
            return
        treeCopySourceRoot.eachDir { File modData ->
            File sourceDir = new File(modData, 'worldgen/placed_feature')
            if (!sourceDir.exists())
                return
            sourceDir.listFiles()?.findAll { it.isFile() && it.name.endsWith('_tree.json') }?.each { File source ->
                def json = new groovy.json.JsonSlurper().parse(source)
                if (json.placement instanceof List)
                    json.placement.removeAll { it instanceof Map && it.type == 'minecraft:block_predicate_filter' }
                String content = groovy.json.JsonOutput.prettyPrint(groovy.json.JsonOutput.toJson(json))
                treeCopyTargetRoots.each { File base ->
                    File target = new File(base, "${modData.name}/worldgen/placed_feature/${source.name}")
                    target.parentFile.mkdirs()
                    target.setText(content, 'UTF-8')
                }
            }
        }
    }
}
tasks.named('processResources') { finalizedBy 'copyTreePlacement' }
