<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = "${modid}") public class ${name}Procedure {
	@SubscribeEvent public static void onPlayerTick(TickEvent.PlayerTickEvent.Post event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.player().getX()",
				"y": "event.player().getY()",
				"z": "event.player().getZ()",
				"world": "event.player().level()",
				"entity": "event.player()",
				"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}