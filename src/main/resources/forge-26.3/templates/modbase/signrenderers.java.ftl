<#-- @formatter:off -->
package ${package}.client;
import net.minecraftforge.api.distmarker.Dist;

<#assign signs = types.blocks?filter(e -> e.isSign())>
<#assign regularSigns = signs?filter(e -> e.blockBase != "HangingSign")>
<#assign hangingSigns = signs?filter(e -> e.blockBase == "HangingSign")>

@Mod.EventBusSubscriber(modid = "${modid}", bus = Mod.EventBusSubscriber.Bus.FORGE, value = Dist.CLIENT)
public class ${JavaModName}SignRenderers {

	@SubscribeEvent public static void registerRenderers(EntityRenderersEvent.RegisterRenderers event) {
		<#if regularSigns?size != 0>
		event.registerBlockEntityRenderer(${JavaModName}SignBlockEntities.SIGN.get(), StandingSignRenderer::new);
		</#if>
		<#if hangingSigns?size != 0>
		event.registerBlockEntityRenderer(${JavaModName}SignBlockEntities.HANGING_SIGN.get(), HangingSignRenderer::new);
		</#if>
	}

}
<#-- @formatter:on -->
