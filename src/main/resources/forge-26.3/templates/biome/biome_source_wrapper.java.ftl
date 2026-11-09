package ${package}.biome;

import com.mojang.serialization.MapCodec;

import net.minecraft.core.Holder;
import net.minecraft.world.level.biome.Biome;
import net.minecraft.world.level.biome.BiomeResolver;
import net.minecraft.world.level.biome.BiomeSource;
import net.minecraft.world.level.biome.Climate;

import net.minecraftforge.unsafe.UnsafeHacks;

import java.lang.reflect.Method;
import java.util.List;
import java.util.stream.Stream;

public final class ${JavaModName}OverworldBiomeSource extends BiomeSource {
	private static final Method ORIGINAL_CODEC = findCodecMethod();

	private final BiomeSource original;
	private final List<Holder<Biome>> customBiomes;

	public ${JavaModName}OverworldBiomeSource(BiomeSource original, List<Holder<Biome>> customBiomes) {
		this.original = original;
		this.customBiomes = List.copyOf(customBiomes);
	}

	private static Method findCodecMethod() {
		try {
			Method method = BiomeSource.class.getDeclaredMethod("codec");
			UnsafeHacks.setAccessible(method);
			return method;
		} catch (ReflectiveOperationException e) {
			throw new IllegalStateException("Unable to access BiomeSource.codec", e);
		}
	}

	@Override
	protected Stream<Holder<Biome>> collectPossibleBiomes() {
		return Stream.concat(original.possibleBiomes().stream(), customBiomes.stream());
	}

	@Override
	protected MapCodec<? extends BiomeSource> codec() {
		try {
			return (MapCodec<? extends BiomeSource>) ORIGINAL_CODEC.invoke(original);
		} catch (ReflectiveOperationException e) {
			throw new IllegalStateException("Unable to encode BiomeSource", e);
		}
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
