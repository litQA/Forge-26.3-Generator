import net.minecraft.world.level.Level;
import net.minecraftforge.common.capabilities.ForgeCapabilities;
import net.minecraftforge.common.capabilities.ICapabilityProvider;
import net.minecraftforge.items.IItemHandler;

private static IItemHandler getBlockItemHandler(LevelAccessor world, BlockPos pos) {
	return world instanceof Level level && level.getBlockEntity(pos) instanceof ICapabilityProvider provider
			? provider.getCapability(ForgeCapabilities.ITEM_HANDLER, null).orElse(null)
			: null;
}
private static ItemStack extractFromBlockInventory(LevelAccessor world, BlockPos pos, int slotId, int amount, boolean simulate) {
	IItemHandler itemHandler = getBlockItemHandler(world, pos);
	if (itemHandler != null && slotId >= 0 && slotId < itemHandler.getSlots())
		return itemHandler.extractItem(slotId, amount, simulate);
	return ItemStack.EMPTY;
}