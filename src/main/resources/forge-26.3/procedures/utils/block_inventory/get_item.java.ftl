private static ItemStack itemFromBlockInventory(LevelAccessor world, BlockPos pos, int slot) {
	IItemHandler itemHandler = world instanceof Level level && level.getBlockEntity(pos) instanceof ICapabilityProvider provider ? provider.getCapability(ForgeCapabilities.ITEM_HANDLER, null).orElse(null) : null;
	return itemHandler != null ? itemHandler.getStackInSlot(slot) : ItemStack.EMPTY;
}