private static int getFluidTankLevel(LevelAccessor level, BlockPos pos, int tank, Direction direction) {
	var blockEntity = level.getBlockEntity(pos);
	if (blockEntity != null) {
		var fluidHandler = blockEntity.getCapability(net.minecraftforge.common.capabilities.ForgeCapabilities.FLUID_HANDLER, direction);
		if (fluidHandler.isPresent())
			return fluidHandler.orElse(null).getFluidInTank(tank).getAmount();
	}
	return 0;
}
