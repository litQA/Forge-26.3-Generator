<#-- @formatter:off -->
<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">

/*
 *	MCreator note: This file will be REGENERATED on each build.
 */

package ${package}.init;
import net.minecraftforge.eventbus.api.listener.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;

import net.minecraftforge.event.furnace.FurnaceFuelBurnTimeEvent;
import net.minecraftforge.eventbus.api.listener.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;

@Mod.EventBusSubscriber(modid = "${modid}")
public class ${JavaModName}Fuels {
	@SubscribeEvent
	public static void onFuelBurnTime(FurnaceFuelBurnTimeEvent event) {
		<#list itemextensions?filter(e -> e.enableFuel) as extension>
		if (event.getItemStack().is(${mappedMCItemToItem(extension.item)})) {
			<#if hasProcedure(extension.fuelSuccessCondition)>
			if (!<@procedureOBJToConditionCode object=extension.fuelSuccessCondition/>)
				return;
			</#if>
			event.setBurnTime((int) <#if hasProcedure(extension.fuelPower)><@procedureOBJToNumberCode object=extension.fuelPower/><#else>${extension.fuelPower.getFixedValue()}</#if>);
		}
		</#list>
	}
}
<#-- @formatter:on -->
