import net.minecraft.world.level.Level;
import net.minecraftforge.common.capabilities.ForgeCapabilities;
import net.minecraftforge.common.capabilities.ICapabilityProvider;
import net.minecraftforge.items.IItemHandler;

private static IItemHandler getBlockItemHandler(LevelAccessor world, BlockPos pos) {
	return world instanceof Level level && level.getBlockEntity(pos) instanceof ICapabilityProvider provider
			? provider.getCapability(ForgeCapabilities.ITEM_HANDLER, null).orElse(null)
			: null;
}
private static ItemStack itemFromBlockInventory(LevelAccessor world, BlockPos pos, int slot) {
	IItemHandler itemHandler = getBlockItemHandler(world, pos);
	return itemHandler != null ? itemHandler.getStackInSlot(slot) : ItemStack.EMPTY;
}