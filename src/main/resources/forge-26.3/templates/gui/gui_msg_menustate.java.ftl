<#-- @formatter:off -->
package ${package}.network;
import net.minecraftforge.event.network.CustomPayloadEvent;

public record MenuStateUpdateMessage(int elementType, String name, Object elementState) {

	public static final StreamCodec<RegistryFriendlyByteBuf, MenuStateUpdateMessage> STREAM_CODEC =
		StreamCodec.of(MenuStateUpdateMessage::write, MenuStateUpdateMessage::read);

	public static void write(RegistryFriendlyByteBuf buffer, MenuStateUpdateMessage message) {
		buffer.writeInt(message.elementType);
		buffer.writeUtf(message.name);
		if (message.elementType == 0) {
			buffer.writeUtf((String) message.elementState);
		} else if (message.elementType == 1) {
			buffer.writeBoolean((boolean) message.elementState);
		} else if (message.elementType == 2 && message.elementState instanceof Number n) {
			buffer.writeDouble(n.doubleValue());
		}
	}

	public static MenuStateUpdateMessage read(RegistryFriendlyByteBuf buffer) {
		int elementType = buffer.readInt();
		String name = buffer.readUtf();
		Object elementState = null;
		if (elementType == 0) {
			elementState = buffer.readUtf();
		} else if (elementType == 1) {
			elementState = buffer.readBoolean();
		} else if (elementType == 2) {
			elementState = buffer.readDouble();
		}
		return new MenuStateUpdateMessage(elementType, name, elementState);
	}

	public static void handle(MenuStateUpdateMessage message, CustomPayloadEvent.Context context) {
		if (message.name.length() > 256 || message.elementState instanceof String string && string.length() > 8192)
			return;

		context.enqueueWork(() -> {
			if (context.getSender() != null && context.getSender().containerMenu instanceof ${JavaModName}Menus.MenuAccessor menu)
				menu.getMenuState().put(message.elementType + ":" + message.name, message.elementState);
		});
		context.setPacketHandled(true);
	}

}
<#-- @formatter:on -->
