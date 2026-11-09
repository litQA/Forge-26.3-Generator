<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = "${modid}", value = Dist.CLIENT) public class ${name}Procedure {
	@SubscribeEvent public static void onRightClick(PlayerInteractEvent.RightClickEmpty event) {
		if (event.getHand() != InteractionHand.MAIN_HAND) return;
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getPos().getX()",
				"y": "event.getPos().getY()",
				"z": "event.getPos().getZ()",
				"world": "event.getLevel()",
				"entity": "event.getEntity()"
			}/>
		</#assign>
		execute(${dependenciesCode});
	}
}
