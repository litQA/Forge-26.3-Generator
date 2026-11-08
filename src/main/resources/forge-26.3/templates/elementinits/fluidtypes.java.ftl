<#-- @formatter:off -->
package ${package}.init;

/*
 * MCreator note: This file will be REGENERATED on each build.
 */
public class ${JavaModName}FluidTypes {

	public static final DeferredRegister<FluidType> REGISTRY = DeferredRegister.create(ForgeRegistries.FLUID_TYPES, ${JavaModName}.MODID);

	<#list fluids as fluid>
	public static final RegistryObject<FluidType> ${fluid.getModElement().getRegistryNameUpper()}_TYPE =
		REGISTRY.register("${fluid.getModElement().getRegistryName()}", ${fluid.getModElement().getName()}FluidType::new);
	</#list>
}
<#-- @formatter:on -->
