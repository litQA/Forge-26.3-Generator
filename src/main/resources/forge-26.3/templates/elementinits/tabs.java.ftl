<#-- @formatter:off -->
<#include "../mcitems.ftl">

<#assign tabMap = w.getCreativeTabMap()>
<#assign vanillaTabs = tabMap.keySet()?filter(e -> !e?starts_with('CUSTOM:'))>
<#assign customTabs = tabMap.keySet()?filter(e -> e?starts_with('CUSTOM:'))>

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;
import net.minecraftforge.registries.DeferredRegister;
import net.minecraftforge.registries.RegistryObject;

<#if vanillaTabs?has_content>
@Mod.EventBusSubscriber(modid = "${modid}", bus = Mod.EventBusSubscriber.Bus.FORGE)
</#if>
<@javacompress>
public class ${JavaModName}Tabs {

	public static final DeferredRegister<CreativeModeTab> REGISTRY = DeferredRegister.create(Registries.CREATIVE_MODE_TAB, ${JavaModName}.MODID);

	<#list customTabs as customTab>
		<#assign tab = w.getWorkspace().getModElementByName(customTab.replace("CUSTOM:", "")).getGeneratableElement()>
			public static final RegistryObject<CreativeModeTab> ${tab.getModElement().getRegistryNameUpper()} =
				REGISTRY.register("${tab.getModElement().getRegistryName()}", () ->
					CreativeModeTab.builder()
						.title(Component.translatable("item_group.${modid}.${tab.getModElement().getRegistryName()}"))
						.icon(() -> ${mappedMCItemToItemStackCode(tab.icon, 1)})
						.displayItems((parameters, tabData) -> {
							<#list tabMap.get("CUSTOM:" + tab.getModElement().getName()) as tabElement>
							tabData.accept(${mappedMCItemToItem(tabElement)});
							</#list>
						})
						<#if tab.showSearch>.withSearchBar()</#if>
						<#if tab.hideTitle>.hideTitle()</#if>
						<#if prevTab??>.withTabsBefore(${prevTab}.getKey())</#if>
						.build()
				);
		<#assign prevTab = tab.getModElement().getRegistryNameUpper()>
	</#list>

	<#if vanillaTabs?has_content>
	@SubscribeEvent public static void buildTabContentsVanilla(BuildCreativeModeTabContentsEvent tabData) {
		<#list vanillaTabs as tabName>
			<#if !tabName?is_first>else </#if>if (tabData.getTabKey() == ${generator.map(tabName, "tabs")}) {
				<#if tabName == "OP_BLOCKS">if (tabData.hasPermissions()) {</#if>
				<#list tabMap.get(tabName) as tabElement>
				tabData.accept(${mappedMCItemToItem(tabElement)});
				</#list>
				<#if tabName == "OP_BLOCKS">}</#if>
			}
		</#list>
	}
	</#if>

}
</@javacompress>
<#-- @formatter:on -->
