<#-- @formatter:off -->
<#include "../procedures.java.ftl">

package ${package}.network;
import net.minecraftforge.event.network.CustomPayloadEvent;

public record ${name}ButtonMessage(int buttonID, int x, int y, int z) {

	public static final StreamCodec<RegistryFriendlyByteBuf, ${name}ButtonMessage> STREAM_CODEC = StreamCodec.of(
		(RegistryFriendlyByteBuf buffer, ${name}ButtonMessage message) -> {
			buffer.writeInt(message.buttonID);
			buffer.writeInt(message.x);
			buffer.writeInt(message.y);
			buffer.writeInt(message.z);
		},
		(RegistryFriendlyByteBuf buffer) -> new ${name}ButtonMessage(buffer.readInt(), buffer.readInt(), buffer.readInt(), buffer.readInt())
	);

	public static void handle(${name}ButtonMessage message, CustomPayloadEvent.Context context) {
		Player player = context.getSender();
		if (player != null)
			context.enqueueWork(() -> handleButtonAction(player, message.buttonID, message.x, message.y, message.z));
		context.setPacketHandled(true);
	}

	public static void handleButtonAction(Player entity, int buttonID, int x, int y, int z) {
		Level world = entity.level();

		if (!world.getChunkSource().hasChunk(SectionPos.blockToSectionCoord(x), SectionPos.blockToSectionCoord(z)))
			return;

		<#assign btid = 0>
		<#list data.getComponentsOfType("Button") as component>
			<#if hasProcedure(component.onClick)>
				if (buttonID == ${btid}) {
					<@procedureOBJToCode component.onClick/>
				}
			</#if>
			<#assign btid += 1>
		</#list>
		<#list data.getComponentsOfType("ImageButton") as component>
			<#if hasProcedure(component.onClick)>
				if (buttonID == ${btid}) {
					<@procedureOBJToCode component.onClick/>
				}
			</#if>
			<#assign btid += 1>
		</#list>
	}

}
<#-- @formatter:on -->
