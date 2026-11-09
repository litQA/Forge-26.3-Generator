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
		<#if item.getModElement().getTypeString() == "block" && item.isSign()>
			<#if item.hasSpecialInformation(w)>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()} =
				register("${item.getModElement().getRegistryName()}", ${item.getModElement().getName()}Block.Item::new);
			<#elseif item.blockBase == "HangingSign">
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()} =
				register("${item.getModElement().getRegistryName()}", properties -> new HangingSignItem(${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()}.get(), ${JavaModName}Blocks.${item.getWallRegistryNameUpper()}.get(), properties));
			<#else>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()} =
				register("${item.getModElement().getRegistryName()}", properties -> new StandingAndWallBlockItem(${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()}.get(), ${JavaModName}Blocks.${item.getWallRegistryNameUpper()}.get(), Direction.DOWN, properties));
			</#if>
		<#elseif item.getModElement().getTypeString() == "block" || item.getModElement().getTypeString() == "plant">
			<#if item.hasSpecialInformation(w)>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()} =
				register("${item.getModElement().getRegistryName()}", ${item.getModElement().getName()}Block.Item::new);
			<#else>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()} =
				blockItem("${item.getModElement().getRegistryName()}", ${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()});
			</#if>
		<#elseif item.getModElement().getTypeString() == "armor">
			<#if item.enableHelmet>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()}_HELMET =
				register("${item.getModElement().getRegistryName()}_helmet", ${item.getModElement().getName()}Item.Helmet::new);
			</#if>
			<#if item.enableBody>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()}_CHESTPLATE =
				register("${item.getModElement().getRegistryName()}_chestplate", ${item.getModElement().getName()}Item.Chestplate::new);
			</#if>
			<#if item.enableLeggings>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()}_LEGGINGS =
				register("${item.getModElement().getRegistryName()}_leggings", ${item.getModElement().getName()}Item.Leggings::new);
			</#if>
			<#if item.enableBoots>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()}_BOOTS =
				register("${item.getModElement().getRegistryName()}_boots", ${item.getModElement().getName()}Item.Boots::new);
			</#if>
		<#elseif item.getModElement().getTypeString() == "fluid" && item.generateBucket>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()}_BUCKET =
				register("${item.getModElement().getRegistryName()}_bucket", ${item.getModElement().getName()}Item::new);
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
