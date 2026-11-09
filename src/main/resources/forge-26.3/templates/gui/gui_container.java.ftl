<#-- @formatter:off -->
package ${package}.world.inventory;

import ${package}.${JavaModName};

public class ${name}Menu extends AbstractContainerMenu implements ${JavaModName}Menus.MenuAccessor {

	public final Level world;
	public final Player entity;
	public int x, y, z;

	private final Map<String, Object> menuState = new HashMap<>();
	private final Map<Integer, Slot> customSlots = new HashMap<>();
	private final IItemHandler internal;

	public ${name}Menu(int id, Inventory inventory, FriendlyByteBuf extraData) {
		super(${JavaModName}Menus.${REGISTRYNAME}.get(), id);

		this.entity = inventory.player;
		this.world = inventory.player.level();
		this.internal = new ItemStackHandler(Math.max(0, ${data.getMaxSlotID() + 1}));

		if (extraData != null) {
			BlockPos pos = extraData.readBlockPos();
			this.x = pos.getX();
			this.y = pos.getY();
			this.z = pos.getZ();
		}

		<#if data.type == 1>
		<#list data.components as component>
		<#if component.getClass().getSimpleName()?ends_with("Slot")>
		this.customSlots.put(${component.id}, this.addSlot(new SlotItemHandler(internal, ${component.id},
			${component.gx(data.width) + 1},
			${component.gy(data.height) + 1}) {
			<#if data.hasSlotEvents()>
			@Override public void setChanged() {
				super.setChanged();
				slotChanged(${component.id}, 0, 0);
			}

			@Override public void onTake(Player player, ItemStack stack) {
				super.onTake(player, stack);
				slotChanged(${component.id}, 1, stack.getCount());
			}

			@Override public void onQuickCraft(ItemStack a, ItemStack b) {
				super.onQuickCraft(a, b);
				slotChanged(${component.id}, 2, b.getCount() - a.getCount());
			}
			</#if>
		}));
		</#if>
		</#list>

		<#assign coffx = data.getInventorySlotsX()>
		<#assign coffy = data.getInventorySlotsY()>

		for (int si = 0; si < 3; ++si)
			for (int sj = 0; sj < 9; ++sj)
				this.addSlot(new Slot(inventory, sj + (si + 1) * 9, ${coffx} + 8 + sj * 18, ${coffy} + 84 + si * 18));

		for (int si = 0; si < 9; ++si)
			this.addSlot(new Slot(inventory, si, ${coffx} + 8 + si * 18, ${coffy} + 142));
		</#if>
	}

	@Override public boolean stillValid(Player player) {
		return true;
	}

	@Override public ItemStack quickMoveStack(Player player, int index) {
		ItemStack result = ItemStack.EMPTY;
		Slot slot = this.slots.get(index);
		if (slot != null && slot.hasItem()) {
			ItemStack stack = slot.getItem();
			result = stack.copy();
			if (index < internal.getSlots()) {
				if (!this.moveItemStackTo(stack, internal.getSlots(), this.slots.size(), true))
					return ItemStack.EMPTY;
			} else if (!this.moveItemStackTo(stack, 0, internal.getSlots(), false)) {
				return ItemStack.EMPTY;
			}
			if (stack.isEmpty())
				slot.setByPlayer(ItemStack.EMPTY);
			else
				slot.setChanged();
		}
		return result;
	}

	@Override public Map<String, Object> getMenuState() {
		return menuState;
	}

	@Override public Map<Integer, Slot> getSlots() {
		return customSlots;
	}

	<#if data.hasSlotEvents()>
	private void slotChanged(int slotid, int ctype, int meta) {
		if (world != null && world.isClientSide()) {
			${JavaModName}Network.CHANNEL.send(new ${name}SlotMessage(slotid, x, y, z, ctype, meta), net.minecraftforge.network.PacketDistributor.SERVER.noArg());
			${name}SlotMessage.handleSlotAction(entity, slotid, ctype, meta, x, y, z);
		}
	}
	</#if>

}
<#-- @formatter:on -->
