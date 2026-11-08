<#-- @formatter:off -->
<#include "../procedures.java.ftl">
package ${package}.init;

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
public class ${JavaModName}Items {

	public static final DeferredRegister<Item> REGISTRY = DeferredRegister.create(ForgeRegistries.ITEMS, ${JavaModName}.MODID);

	<@javacompress>
	<#list items as item>
		<#if item.getModElement().getTypeString() == "block" || item.getModElement().getTypeString() == "plant">
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()} =
				blockItem("${item.getModElement().getRegistryName()}", ${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()});
		<#else>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()} =
				register("${item.getModElement().getRegistryName()}", ${item.getModElement().getName()}Item::new);
		</#if>
	</#list>
	</@javacompress>

	// Start of user code block custom items
	// End of user code block custom items

	private static <I extends Item> RegistryObject<I> register(String name, Function<Item.Properties, ? extends I> supplier) {
		return REGISTRY.register(name, () -> supplier.apply(new Item.Properties().setId(REGISTRY.key(name))));
	}

	private static RegistryObject<Item> blockItem(String name, RegistryObject<Block> block) {
		return REGISTRY.register(name, () -> new BlockItem(block.get(), new Item.Properties().setId(REGISTRY.key(name))));
	}

}
<#-- @formatter:on -->
