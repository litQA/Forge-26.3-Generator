
public static boolean canInsertInBlockInventory(LevelAccessor world, BlockPos pos, int slotId, int amount, ItemStack itemstack) {
	IItemHandler itemHandler = world instanceof Level level && level.getBlockEntity(pos) instanceof ICapabilityProvider provider ? provider.getCapability(ForgeCapabilities.ITEM_HANDLER, null).orElse(null) : null;
	if (itemHandler != null && slotId >= 0 && slotId < itemHandler.getSlots()) {
		ItemStack inserted = itemstack.copy();
		inserted.setCount(amount);
		return itemHandler.insertItem(slotId, inserted, true).isEmpty();
	}
	return false;
}