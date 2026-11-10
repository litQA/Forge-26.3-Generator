
private static int getBlockInventorySlotCount(LevelAccessor world, BlockPos pos) {
	IItemHandler itemHandler = world instanceof Level level && level.getBlockEntity(pos) instanceof ICapabilityProvider provider ? provider.getCapability(ForgeCapabilities.ITEM_HANDLER, null).orElse(null) : null;
	return itemHandler != null ? itemHandler.getSlots() : 0;
}