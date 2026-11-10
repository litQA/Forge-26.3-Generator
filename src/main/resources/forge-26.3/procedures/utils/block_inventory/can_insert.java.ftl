import net.minecraft.world.level.Level;
import net.minecraftforge.common.capabilities.ForgeCapabilities;
import net.minecraftforge.common.capabilities.ICapabilityProvider;
import net.minecraftforge.items.IItemHandler;

private static IItemHandler getBlockItemHandler(LevelAccessor world, BlockPos pos) {
	return world instanceof Level level && level.getBlockEntity(pos) instanceof ICapabilityProvider provider
			? provider.getCapability(ForgeCapabilities.ITEM_HANDLER, null).orElse(null)
			: null;
}
public static boolean canInsertInBlockInventory(LevelAccessor world, BlockPos pos, int slotId, int amount, ItemStack itemstack) {
	IItemHandler itemHandler = getBlockItemHandler(world, pos);
	if (itemHandler != null && slotId >= 0 && slotId < itemHandler.getSlots()) {
		ItemStack inserted = itemstack.copy();
		inserted.setCount(amount);
		return itemHandler.insertItem(slotId, inserted, true).isEmpty();
	}
	return false;
}