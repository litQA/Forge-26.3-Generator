<#-- @formatter:off -->
package ${package}.init;

public class ${JavaModName}SignBlockEntities {

	public static final DeferredRegister<BlockEntityType<?>> REGISTRY = DeferredRegister.create(ForgeRegistries.BLOCK_ENTITY_TYPES, ${JavaModName}.MODID);

	<@javacompress>
	<#assign signs = types.blocks?filter(e -> e.isSign())>
	<#assign signEntries = []>
	<#assign hangingSignEntries = []>
	<#list signs as block>
		<#if block.blockBase == "HangingSign">
			<#assign hangingSignEntries += ['${JavaModName}Blocks.${block.getModElement().getRegistryNameUpper()}.get()', '${JavaModName}Blocks.${block.getWallRegistryNameUpper()}.get()']>
		<#else>
			<#assign signEntries += ['${JavaModName}Blocks.${block.getModElement().getRegistryNameUpper()}.get()', '${JavaModName}Blocks.${block.getWallRegistryNameUpper()}.get()']>
		</#if>
	</#list>
	<#if signEntries?size != 0>
	public static final RegistryObject<BlockEntityType<SignBlockEntity>> SIGN = REGISTRY.register("sign", ${JavaModName}SignBlockEntities::createSignType);

	private static BlockEntityType<SignBlockEntity> createSignType() {
		return new BlockEntityType<>(
			(pos, state) -> new SignBlockEntity(SIGN.get(), pos, state),
			Set.of(${signEntries?join(", ")})
		);
	}
	</#if>
	<#if hangingSignEntries?size != 0>
	public static final RegistryObject<BlockEntityType<SignBlockEntity>> HANGING_SIGN = REGISTRY.register("hanging_sign", ${JavaModName}SignBlockEntities::createHangingSignType);

	private static BlockEntityType<SignBlockEntity> createHangingSignType() {
		return new BlockEntityType<>(
			(pos, state) -> new SignBlockEntity(HANGING_SIGN.get(), pos, state),
			Set.of(${hangingSignEntries?join(", ")})
		);
	}
	</#if>
	</@javacompress>

}
<#-- @formatter:on -->
