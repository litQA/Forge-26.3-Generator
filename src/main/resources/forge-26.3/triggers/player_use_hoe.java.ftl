<#include "procedures.java.ftl">
@Mod.EventBusSubscriber(modid = "${modid}") public class ${name}Procedure {
	@SubscribeEvent public static void onUseHoe(PlayerInteractEvent.RightClickBlock event) {
		if (event.getHand() != InteractionHand.MAIN_HAND) return;
		var transformer = event.getItemStack().get(DataComponents.BLOCK_TRANSFORMER);
		if (transformer == null || !transformer.is(BlockTransformers.HOE)) return;
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getPos().getX()",
				"y": "event.getPos().getY()",
				"z": "event.getPos().getZ()",
				"world": "event.getLevel()",
				"entity": "event.getEntity()",
				"blockstate": "event.getLevel().getBlockState(event.getPos())",
				"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
}
