
private static int getBlockInventorySlotStackLimit(LevelAccessor world, BlockPos pos, int slotId) {
	IItemHandler itemHandler = world instanceof Level level && level.getBlockEntity(pos) instanceof ICapabilityProvider provider ? provider.getCapability(ForgeCapabilities.ITEM_HANDLER, null).orElse(null) : null;
	return itemHandler != null && slotId >= 0 && slotId < itemHandler.getSlots() ? itemHandler.getSlotLimit(slotId) : 0;
}