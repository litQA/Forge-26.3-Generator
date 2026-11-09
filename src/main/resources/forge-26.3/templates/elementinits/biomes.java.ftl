package ${package}.init;

import net.minecraft.core.Holder;
import net.minecraft.core.HolderGetter;
import net.minecraft.core.Registry;
import net.minecraft.core.registries.Registries;
import net.minecraft.resources.Identifier;
import net.minecraft.resources.ResourceKey;
import net.minecraft.world.level.biome.Biome;
import net.minecraft.world.level.biome.FeatureSorter;
import net.minecraft.world.level.dimension.BuiltinDimensionTypes;
import net.minecraft.world.level.dimension.LevelStem;
import net.minecraft.world.level.chunk.ChunkGenerator;

import net.minecraftforge.common.util.ClearableLazy;
import net.minecraftforge.unsafe.UnsafeHacks;
import net.minecraftforge.event.server.ServerAboutToStartEvent;
import net.minecraftforge.eventbus.api.listener.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;

import ${package}.biome.${JavaModName}OverworldBiomeSource;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

@Mod.EventBusSubscriber(modid = "${modid}")
public final class ${JavaModName}Biomes {
	private ${JavaModName}Biomes() {
	}

	@SubscribeEvent
	public static void onServerAboutToStart(ServerAboutToStartEvent event) {
		HolderGetter<Biome> biomeLookup = event.getServer().registryAccess().lookupOrThrow(Registries.BIOME);
		Registry<LevelStem> levelStems = event.getServer().registryAccess().lookupOrThrow(Registries.LEVEL_STEM);

		List<Holder<Biome>> customBiomes = new ArrayList<>();
		<#list biomes as biome>
		<#if biome.spawnBiome>
		customBiomes.add(biomeLookup.getOrThrow(ResourceKey.create(Registries.BIOME, Identifier.fromNamespaceAndPath("${modid}", "${biome.getModElement().getRegistryName()}"))));
		</#if>
		</#list>

		if (customBiomes.isEmpty())
			return;

		for (LevelStem stem : levelStems.stream().toList()) {
			if (!stem.type().is(BuiltinDimensionTypes.OVERWORLD))
				continue;
			ChunkGenerator generator = stem.generator();
			if (generator.getBiomeSource() instanceof ${JavaModName}OverworldBiomeSource)
				continue;
			${JavaModName}OverworldBiomeSource wrapper = new ${JavaModName}OverworldBiomeSource(generator.getBiomeSource(), customBiomes);
			setField(generator, "biomeSource", wrapper);
			ClearableLazy<List<FeatureSorter.StepFeatureData>> features = ClearableLazy.concurrentOf(
				() -> FeatureSorter.buildFeaturesPerStep(
					List.copyOf(wrapper.possibleBiomes()),
					biome -> biome.value().getGenerationSettings().features(), true));
			setField(generator, "featuresPerStep", features);
		}
	}

	private static void setField(ChunkGenerator generator, String name, Object value) {
		try {
			Field field = ChunkGenerator.class.getDeclaredField(name);
			UnsafeHacks.setAccessible(field);
			UnsafeHacks.setField(field, generator, value);
		} catch (ReflectiveOperationException e) {
			throw new IllegalStateException("Unable to inject " + name, e);
		}
	}
}
