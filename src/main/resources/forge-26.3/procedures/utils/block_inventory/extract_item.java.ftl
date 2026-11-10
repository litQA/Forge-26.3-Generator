
private static ItemStack extractFromBlockInventory(LevelAccessor world, BlockPos pos, int slotId, int amount, boolean simulate) {
	IItemHandler itemHandler = world instanceof Level level && level.getBlockEntity(pos) instanceof ICapabilityProvider provider ? provider.getCapability(ForgeCapabilities.ITEM_HANDLER, null).orElse(null) : null;
	if (itemHandler != null && slotId >= 0 && slotId < itemHandler.getSlots())
		return itemHandler.extractItem(slotId, amount, simulate);
	return ItemStack.EMPTY;
}