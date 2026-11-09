<#-- @formatter:off -->
package ${package}.init;

public class ${JavaModName}Menus {

	public static final DeferredRegister<MenuType<?>> REGISTRY = DeferredRegister.create(Registries.MENU, ${JavaModName}.MODID);

	<#list guis as gui>
	public static final RegistryObject<MenuType<${gui.getModElement().getName()}Menu>> ${gui.getModElement().getRegistryNameUpper()} =
		REGISTRY.register("${gui.getModElement().getRegistryName()}", () -> IForgeMenuType.create(${gui.getModElement().getName()}Menu::new));
	</#list>

	public interface MenuAccessor {
		Map<String, Object> getMenuState();

		Map<Integer, Slot> getSlots();

		default void sendMenuStateUpdate(Player player, int elementType, String name, Object elementState, boolean needClientUpdate) {
			getMenuState().put(elementType + ":" + name, elementState);
			if (player instanceof ServerPlayer serverPlayer) {
				${JavaModName}Network.CHANNEL.send(new MenuStateUpdateMessage(elementType, name, elementState),
					net.minecraftforge.network.PacketDistributor.PLAYER.with(serverPlayer));
			} else if (player.level().isClientSide()) {
				${JavaModName}Network.CHANNEL.send(new MenuStateUpdateMessage(elementType, name, elementState),
					net.minecraftforge.network.PacketDistributor.SERVER.noArg());
			}
		}

		default <T> T getMenuState(int elementType, String name, T defaultValue) {
			try {
				return (T) getMenuState().getOrDefault(elementType + ":" + name, defaultValue);
			} catch (ClassCastException e) {
				return defaultValue;
			}
		}
	}

	public interface BoundBlock {
		Class<? extends AbstractContainerMenu> getBoundMenuClass();
	}

}
<#-- @formatter:on -->
