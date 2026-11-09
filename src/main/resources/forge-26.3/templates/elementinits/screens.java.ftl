<#-- @formatter:off -->
package ${package}.init;

@Mod.EventBusSubscriber(modid = "${modid}", bus = Mod.EventBusSubscriber.Bus.MOD, value = Dist.CLIENT)
public class ${JavaModName}Screens {

	@SubscribeEvent public static void clientLoad(FMLClientSetupEvent event) {
		event.enqueueWork(() -> {
			<#list guis as gui>
			MenuScreens.register(${JavaModName}Menus.${gui.getModElement().getRegistryNameUpper()}.get(), ${gui.getModElement().getName()}Screen::new);
			</#list>
		});
	}

	public interface ScreenAccessor {
		void updateMenuState(int elementType, String name, Object elementState);
	}

}
<#-- @formatter:on -->
