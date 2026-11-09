<#-- @formatter:off -->
<#include "../procedures.java.ftl">

package ${package}.network;
import net.minecraftforge.event.network.CustomPayloadEvent;

public record ${name}SlotMessage(int slotID, int x, int y, int z, int changeType, int meta) {

	public static final StreamCodec<RegistryFriendlyByteBuf, ${name}SlotMessage> STREAM_CODEC = StreamCodec.of(
		(RegistryFriendlyByteBuf buffer, ${name}SlotMessage message) -> {
			buffer.writeInt(message.slotID);
			buffer.writeInt(message.x);
			buffer.writeInt(message.y);
			buffer.writeInt(message.z);
			buffer.writeInt(message.changeType);
			buffer.writeInt(message.meta);
		},
		(RegistryFriendlyByteBuf buffer) -> new ${name}SlotMessage(buffer.readInt(), buffer.readInt(), buffer.readInt(), buffer.readInt(), buffer.readInt(), buffer.readInt())
	);

	public static void handle(${name}SlotMessage message, CustomPayloadEvent.Context context) {
		Player player = context.getSender();
		if (player != null)
			context.enqueueWork(() -> handleSlotAction(player, message.slotID, message.changeType, message.meta, message.x, message.y, message.z));
		context.setPacketHandled(true);
	}

	public static void handleSlotAction(Player entity, int slot, int changeType, int meta, int x, int y, int z) {
		Level world = entity.level();

		if (!world.getChunkSource().hasChunk(SectionPos.blockToSectionCoord(x), SectionPos.blockToSectionCoord(z)))
			return;

		<#list data.components as component>
			<#if component.getClass().getSimpleName()?ends_with("Slot")>
				<#if hasProcedure(component.onSlotChanged)>
					if (slot == ${component.id} && changeType == 0) {
						<@procedureOBJToCode component.onSlotChanged/>
					}
				</#if>
				<#if hasProcedure(component.onTakenFromSlot)>
					if (slot == ${component.id} && changeType == 1) {
						int amount = meta;
						<@procedureOBJToCode component.onTakenFromSlot/>
					}
				</#if>
				<#if hasProcedure(component.onStackTransfer)>
					if (slot == ${component.id} && changeType == 2) {
						int amount = meta;
						<@procedureOBJToCode component.onStackTransfer/>
					}
				</#if>
			</#if>
		</#list>
	}

}
<#-- @formatter:on -->
