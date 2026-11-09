<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = "${modid}", value = Dist.CLIENT) public class ${name}Procedure {
	@SubscribeEvent public static void onLeftClick(PlayerInteractEvent.LeftClickEmpty event) {
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
