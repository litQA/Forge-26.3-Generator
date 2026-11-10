import net.minecraft.world.level.Level;
import net.minecraftforge.common.capabilities.ForgeCapabilities;
import net.minecraftforge.common.capabilities.ICapabilityProvider;
import net.minecraftforge.items.IItemHandler;

private static IItemHandler getBlockItemHandler(LevelAccessor world, BlockPos pos) {
	return world instanceof Level level && level.getBlockEntity(pos) instanceof ICapabilityProvider provider
			? provider.getCapability(ForgeCapabilities.ITEM_HANDLER, null).orElse(null)
			: null;
}
private static int getBlockInventorySlotCount(LevelAccessor world, BlockPos pos) {
	IItemHandler itemHandler = getBlockItemHandler(world, pos);
	return itemHandler != null ? itemHandler.getSlots() : 0;
}