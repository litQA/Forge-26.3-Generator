package ${package}.biome;

import com.mojang.serialization.MapCodec;

import net.minecraft.core.Holder;
import net.minecraft.world.level.biome.Biome;
import net.minecraft.world.level.biome.BiomeResolver;
import net.minecraft.world.level.biome.BiomeSource;
import net.minecraft.world.level.biome.Climate;

import java.util.List;
import java.util.stream.Stream;

public final class ${JavaModName}OverworldBiomeSource extends BiomeSource {
	private final BiomeSource original;
	private final List<Holder<Biome>> customBiomes;

	public ${JavaModName}OverworldBiomeSource(BiomeSource original, List<Holder<Biome>> customBiomes) {
		this.original = original;
		this.customBiomes = List.copyOf(customBiomes);
	}

	@Override
	protected Stream<Holder<Biome>> collectPossibleBiomes() {
		return Stream.concat(original.possibleBiomes().stream(), customBiomes.stream());
	}

	@Override
	protected MapCodec<? extends BiomeSource> codec() {
		return original.codec();
	}

	@Override
	public BiomeResolver createResolver(Climate.Sampler sampler) {
		BiomeResolver delegate = original.createResolver(sampler);
		return (x, y, z) -> {
			if (!customBiomes.isEmpty() && Math.floorMod(x * 31 + z * 17, 64) == 0) {
				return customBiomes.get(Math.floorMod(x * 7 + z * 13, customBiomes.size()));
			}
			return delegate.getNoiseBiome(x, y, z);
		};
	}
}
