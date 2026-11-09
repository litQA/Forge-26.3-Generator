<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = "${modid}") public class ${name}Procedure {
	@SubscribeEvent public static void onWorldTick(TickEvent.LevelTickEvent.Post event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"world": "event.level()",
				"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}