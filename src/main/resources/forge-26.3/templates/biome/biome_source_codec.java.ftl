package ${package}.init;

import net.minecraft.core.registries.Registries;
import net.minecraft.resources.Identifier;

import net.minecraftforge.eventbus.api.listener.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.registries.RegisterEvent;

import ${package}.biome.${JavaModName}OverworldBiomeSource;

@Mod.EventBusSubscriber(modid = "${modid}", bus = Mod.EventBusSubscriber.Bus.MOD)
public final class ${JavaModName}BiomeSources {
	private ${JavaModName}BiomeSources() {
	}

	@SubscribeEvent
	public static void register(RegisterEvent event) {
		if (event.getRegistryKey().equals(Registries.BIOME_SOURCE)) {
			event.register(Registries.BIOME_SOURCE, Identifier.fromNamespaceAndPath("${modid}", "overworld_injected"),
				() -> ${JavaModName}OverworldBiomeSource.CODEC);
		}
	}
}
