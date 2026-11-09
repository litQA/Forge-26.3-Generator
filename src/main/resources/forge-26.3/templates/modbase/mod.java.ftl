<#-- @formatter:off -->
package ${package};

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;
import net.minecraftforge.api.distmarker.Dist;
import net.minecraftforge.fml.loading.FMLEnvironment;

@Mod("${modid}") public class ${JavaModName} {

	public static final Logger LOGGER = LogManager.getLogger(${JavaModName}.class);

	public static final String MODID = "${modid}";

	public ${JavaModName}(FMLJavaModLoadingContext context) {
		// Start of user code block mod constructor
		// End of user code block mod constructor

		var modBusGroup = context.getModBusGroup();

		<@javacompress>
		<#if types.base_blocks?has_content>${JavaModName}Blocks.REGISTRY.register(modBusGroup);</#if>
		<#if types.base_blockentities?has_content>${JavaModName}BlockEntities.REGISTRY.register(modBusGroup);</#if>
		<#if types.base_entities?has_content>${JavaModName}Entities.REGISTRY.register(modBusGroup);</#if>
		<#if types.blocks?filter(e -> e.isSign())?size != 0>${JavaModName}SignBlockEntities.REGISTRY.register(modBusGroup);</#if>
		<#if types.base_items?has_content>${JavaModName}Items.REGISTRY.register(modBusGroup);</#if>
		<#if types.guis?has_content>${JavaModName}Menus.REGISTRY.register(modBusGroup);</#if>
		<#if keybinds?has_content || types.guis?has_content>${JavaModName}Network.init();</#if>
		<#if w.hasItemsInTabs()>${JavaModName}Tabs.REGISTRY.register(modBusGroup);</#if>
		<#if types.fluids?has_content>
			${JavaModName}Fluids.REGISTRY.register(modBusGroup);
			${JavaModName}FluidTypes.REGISTRY.register(modBusGroup);
			if (FMLEnvironment.dist == Dist.CLIENT)
				${JavaModName}FluidModels.register();
		</#if>
		<#if types.attributes?has_content>${JavaModName}Attributes.REGISTRY.register(modBusGroup);</#if>
		<#if types.gamerules?has_content>${JavaModName}GameRules.REGISTRY.register(modBusGroup);</#if>
		<#if types.potions?has_content>${JavaModName}Potions.REGISTRY.register(modBusGroup);</#if>
		<#if types.potioneffects?has_content>${JavaModName}MobEffects.REGISTRY.register(modBusGroup);</#if>
		<#if types.particles?has_content>${JavaModName}ParticleTypes.REGISTRY.register(modBusGroup);</#if>
		<#if types.base_features?has_content>${JavaModName}FeatureTypes.REGISTRY.register(modBusGroup);</#if>
		</@javacompress>

		// Start of user code block mod init
		// End of user code block mod init
	}

	// Start of user code block mod methods
	// End of user code block mod methods

	private static Object minecraft;
	private static java.lang.invoke.MethodHandle playerHandle;

	@Nullable public static net.minecraft.world.entity.player.Player clientPlayer() {
		if (FMLEnvironment.dist.isClient()) {
			try {
				if (minecraft == null || playerHandle == null) {
					Class<?> minecraftClass = Class.forName("net.minecraft.client.Minecraft");
					minecraft = java.lang.invoke.MethodHandles.publicLookup().findStatic(minecraftClass, "getInstance",
							java.lang.invoke.MethodType.methodType(minecraftClass)).invoke();
					playerHandle = java.lang.invoke.MethodHandles.publicLookup().findGetter(minecraftClass, "player",
							Class.forName("net.minecraft.client.player.LocalPlayer"));
				}
				return (net.minecraft.world.entity.player.Player) playerHandle.invoke(minecraft);
			} catch (Throwable e) {
				LOGGER.error("Failed to get client player", e);
				return null;
			}
		}
		return null;
	}

}
<#-- @formatter:on -->
