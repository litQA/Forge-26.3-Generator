package ${package}.mixin;

import org.spongepowered.asm.mixin.Final;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Mutable;
import org.spongepowered.asm.mixin.Shadow;

import net.minecraft.world.level.biome.BiomeSource;
import net.minecraft.world.level.chunk.ChunkGenerator;

import ${package}.biome.${JavaModName}BiomeSourceAccess;

@Mixin(ChunkGenerator.class)
public abstract class ${JavaModName}ChunkGeneratorMixin implements ${JavaModName}BiomeSourceAccess {
	@Shadow @Final @Mutable protected BiomeSource biomeSource;

	@Override
	public void setBiomeSource(BiomeSource source) {
		this.biomeSource = source;
	}
}
