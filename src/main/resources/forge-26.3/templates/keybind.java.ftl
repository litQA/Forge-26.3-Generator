<#-- @formatter:off -->
<#include "procedures.java.ftl">

package ${package}.network;

public record ${name}Message(int eventType, int pressedms) {

	public static final StreamCodec<RegistryFriendlyByteBuf, ${name}Message> STREAM_CODEC = StreamCodec.of(
		(RegistryFriendlyByteBuf buffer, ${name}Message message) -> {
			buffer.writeInt(message.eventType);
			buffer.writeInt(message.pressedms);
		},
		(RegistryFriendlyByteBuf buffer) -> new ${name}Message(buffer.readInt(), buffer.readInt())
	);

	public static void handle(${name}Message message, CustomPayloadEvent.Context context) {
		context.enqueueWork(() -> {
			if (context.getSender() != null)
				pressAction(context.getSender(), message.eventType, message.pressedms);
		});
		context.setPacketHandled(true);
	}

	<#if hasProcedure(data.onKeyPressed) || hasProcedure(data.onKeyReleased)>
	public static void pressAction(Player entity, int type, int pressedms) {
		Level world = entity.level();
		double x = entity.getX();
		double y = entity.getY();
		double z = entity.getZ();

		if (!world.getChunkSource().hasChunk(SectionPos.blockToSectionCoord(x), SectionPos.blockToSectionCoord(z)))
			return;

		<#if hasProcedure(data.onKeyPressed)>
		if (type == 0) {
			<@procedureOBJToCode data.onKeyPressed/>
		}
		</#if>

		<#if hasProcedure(data.onKeyReleased)>
		if (type == 1) {
			<@procedureOBJToCode data.onKeyReleased/>
		}
		</#if>
	}
	</#if>

}
<#-- @formatter:on -->
