package ${package}.item.inventory;

import net.minecraft.core.Direction;
import net.minecraft.nbt.CompoundTag;
import net.minecraft.world.item.ItemStack;
import net.minecraftforge.common.capabilities.Capability;
import net.minecraftforge.common.capabilities.ForgeCapabilities;
import net.minecraftforge.common.capabilities.ICapabilitySerializable;
import net.minecraftforge.common.util.LazyOptional;
import net.minecraftforge.items.ItemStackHandler;

public class ${name}InventoryCapability extends ItemStackHandler implements ICapabilitySerializable<CompoundTag> {
	private final LazyOptional<ItemStackHandler> handler = LazyOptional.of(() -> this);

	public ${name}InventoryCapability() {
		super(${data.inventorySize});
	}

	<#if data.inventoryStackSize != 99>
	@Override
	protected int getStackLimit(int slot, ItemStack stack) {
		return Math.min(${data.inventoryStackSize}, super.getStackLimit(slot, stack));
	}
	</#if>

	@Override
	public boolean isItemValid(int slot, ItemStack stack) {
		return super.isItemValid(slot, stack) && stack.getItem() != ${JavaModName}Items.${REGISTRYNAME}.get();
	}

	@Override
	public <T> LazyOptional<T> getCapability(Capability<T> capability, Direction side) {
		return capability == ForgeCapabilities.ITEM_HANDLER ? handler.cast() : LazyOptional.empty();
	}
}
