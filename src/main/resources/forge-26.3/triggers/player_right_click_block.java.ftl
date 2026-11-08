<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = "${modid}") public class ${name}Procedure {
	@SubscribeEvent public static void onRightClickBlock(PlayerInteractEvent.RightClickBlock event) {
		<#-- The event is fired for both hands; only the main hand is handled here. -->
		if (event.getHand() != InteractionHand.MAIN_HAND) return;
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getPos().getX()",
				"y": "event.getPos().getY()",
				"z": "event.getPos().getZ()",
				"world": "event.getLevel()",
				"entity": "event.getEntity()",
				"direction": "event.getFace()",
				"blockstate": "event.getLevel().getBlockState(event.getPos())",
				"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
