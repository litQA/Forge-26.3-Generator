<#-- @formatter:off -->
package ${package}.init;

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
public class ${JavaModName}Blocks {

	public static final DeferredRegister<Block> REGISTRY = DeferredRegister.create(ForgeRegistries.BLOCKS, ${JavaModName}.MODID);

	<@javacompress>
	<#list blocks as block>
		<#if block.getModElement().getTypeString() == "dimension">
			public static final RegistryObject<Block> ${block.getModElement().getRegistryNameUpper()}_PORTAL =
				register("${block.getModElement().getRegistryName()}_portal", ${block.getModElement().getName()}PortalBlock::new);
		<#else>
			public static final RegistryObject<Block> ${block.getModElement().getRegistryNameUpper()} =
				register("${block.getModElement().getRegistryName()}", ${block.getModElement().getName()}Block::new);
			<#if block.getModElement().getTypeString() == "block" && block.isSign()>
			public static final RegistryObject<Block> ${block.getWallRegistryNameUpper()} =
				register("${block.getWallRegistryName()}", ${block.getWallName()}Block::new);
			</#if>
		</#if>
	</#list>
	</@javacompress>

	// Start of user code block custom blocks
	// End of user code block custom blocks

	private static <B extends Block> RegistryObject<B> register(String name, Function<BlockBehaviour.Properties, ? extends B> supplier) {
		return REGISTRY.register(name, () -> supplier.apply(BlockBehaviour.Properties.of().setId(REGISTRY.key(name))));
	}

}
<#-- @formatter:on -->
