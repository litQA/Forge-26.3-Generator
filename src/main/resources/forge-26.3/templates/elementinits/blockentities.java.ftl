<#-- @formatter:off -->
package ${package}.init;
import net.minecraftforge.registries.DeferredRegister;
import net.minecraftforge.registries.ForgeRegistries;
import net.minecraftforge.registries.RegistryObject;

/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
public class ${JavaModName}BlockEntities {

	public static final DeferredRegister<BlockEntityType<?>> REGISTRY = DeferredRegister.create(ForgeRegistries.BLOCK_ENTITY_TYPES, ${JavaModName}.MODID);

	<#list blockentities as blockentity>
	public static final RegistryObject<BlockEntityType<${blockentity.getModElement().getName()}BlockEntity>> ${blockentity.getModElement().getRegistryNameUpper()} =
		register("${blockentity.getModElement().getRegistryName()}", ${JavaModName}Blocks.${blockentity.getModElement().getRegistryNameUpper()},
			${blockentity.getModElement().getName()}BlockEntity::new);
	</#list>

	// Start of user code block custom block entities
	// End of user code block custom block entities

	private static <T extends BlockEntity> RegistryObject<BlockEntityType<T>> register(String registryname,
			RegistryObject<Block> block, BlockEntityType.BlockEntitySupplier<T> supplier) {
		return REGISTRY.register(registryname, () -> new BlockEntityType<>(supplier, Set.of(block.get())));
	}

}
<#-- @formatter:on -->
