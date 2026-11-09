<#-- @formatter:off -->
package ${package}.world.inventory;

import ${package}.${JavaModName};

public class ${name}Menu extends AbstractContainerMenu implements ${JavaModName}Menus.MenuAccessor {

	public final Level world;
	public final Player entity;
	public int x, y, z;

	private final Map<String, Object> menuState = new HashMap<>();
	private final Map<Integer, Slot> customSlots = new HashMap<>();

	public ${name}Menu(int id, Inventory inventory, FriendlyByteBuf extraData) {
		super(${JavaModName}Menus.${REGISTRYNAME}.get(), id);

		this.entity = inventory.player;
		this.world = inventory.player.level();

		if (extraData != null) {
			BlockPos pos = extraData.readBlockPos();
			this.x = pos.getX();
			this.y = pos.getY();
			this.z = pos.getZ();
		}
	}

	@Override public boolean stillValid(Player player) {
		return true;
	}

	@Override public ItemStack quickMoveStack(Player player, int index) {
		return ItemStack.EMPTY;
	}

	@Override public Map<String, Object> getMenuState() {
		return menuState;
	}

	@Override public Map<Integer, Slot> getSlots() {
		return customSlots;
	}

}
<#-- @formatter:on -->
