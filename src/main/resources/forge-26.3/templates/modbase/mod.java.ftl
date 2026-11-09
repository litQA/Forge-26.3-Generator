<#-- @formatter:off -->
package ${package};

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

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
		<#if w.hasItemsInTabs()>${JavaModName}Tabs.REGISTRY.register(modBusGroup);</#if>
		<#if types.fluids?has_content>
			${JavaModName}Fluids.REGISTRY.register(modBusGroup);
			${JavaModName}FluidTypes.REGISTRY.register(modBusGroup);
			if (FMLEnvironment.dist == Dist.CLIENT)
				${JavaModName}FluidModels.register();
		</#if>
		</@javacompress>

		// Start of user code block mod init
		// End of user code block mod init
	}

	// Start of user code block mod methods
	// End of user code block mod methods

}
<#-- @formatter:on -->
