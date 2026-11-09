<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = "${modid}") public class ${name}Procedure {
	@SubscribeEvent public static void onWorldLoad(net.minecraftforge.event.level.LevelEvent.Load event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"world": "event.getLevel()",
				"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}