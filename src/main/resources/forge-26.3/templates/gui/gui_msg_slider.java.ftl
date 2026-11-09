<#-- @formatter:off -->
<#include "../procedures.java.ftl">

package ${package}.network;

public record ${name}SliderMessage(int sliderID, int x, int y, int z, double value) {

	public static final StreamCodec<RegistryFriendlyByteBuf, ${name}SliderMessage> STREAM_CODEC = StreamCodec.of(
		(RegistryFriendlyByteBuf buffer, ${name}SliderMessage message) -> {
			buffer.writeInt(message.sliderID);
			buffer.writeInt(message.x);
			buffer.writeInt(message.y);
			buffer.writeInt(message.z);
			buffer.writeDouble(message.value);
		},
		(RegistryFriendlyByteBuf buffer) -> new ${name}SliderMessage(buffer.readInt(), buffer.readInt(), buffer.readInt(), buffer.readInt(), buffer.readDouble())
	);

	public static void handle(${name}SliderMessage message, CustomPayloadEvent.Context context) {
		Player player = context.getSender();
		if (player != null)
			context.enqueueWork(() -> handleSliderAction(player, message.sliderID, message.x, message.y, message.z, message.value));
		context.setPacketHandled(true);
	}

	public static void handleSliderAction(Player entity, int sliderID, int x, int y, int z, double value) {
		Level world = entity.level();

		if (!world.getChunkSource().hasChunk(SectionPos.blockToSectionCoord(x), SectionPos.blockToSectionCoord(z)))
			return;

		<#assign slid = 0>
		<#list data.getComponentsOfType("Slider") as component>
			<#if hasProcedure(component.whenSliderMoves)>
				if (sliderID == ${slid}) {
					<@procedureOBJToCode component.whenSliderMoves/>
				}
			</#if>
			<#assign slid += 1>
		</#list>
	}

}
<#-- @formatter:on -->
