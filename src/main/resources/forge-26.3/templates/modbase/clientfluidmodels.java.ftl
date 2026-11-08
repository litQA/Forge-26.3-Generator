<#-- @formatter:off -->
package ${package}.client;

public final class ${JavaModName}FluidModels {

	private ${JavaModName}FluidModels() {
	}

	public static void register() {
		BakeFluidModels.BUS.addListener(${JavaModName}FluidModels::registerModels);
	}

	private static void registerModels(BakeFluidModels event) {
		<#list types.fluids as fluid>
		var still${fluid?index} = new FluidModel.Unbaked(
			new Material(Identifier.parse("${fluid.textureStill.format("%s:block/%s")}")),
			new Material(Identifier.parse("${fluid.textureFlowing.format("%s:block/%s")}")),
			null,
			null
		);
		var baked${fluid?index} = still${fluid?index}.bake(event.materials(), () -> "${fluid.getModElement().getName()}");
		event.register(${JavaModName}Fluids.${fluid.getModElement().getRegistryNameUpper()}.get(), baked${fluid?index});
		event.register(${JavaModName}Fluids.FLOWING_${fluid.getModElement().getRegistryNameUpper()}.get(), baked${fluid?index});
		</#list>
	}

}
<#-- @formatter:on -->
