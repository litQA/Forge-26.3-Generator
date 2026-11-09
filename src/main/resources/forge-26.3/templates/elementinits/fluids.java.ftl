<#-- @formatter:off -->
package ${package}.init;
import net.minecraftforge.registries.DeferredRegister;
import net.minecraftforge.registries.ForgeRegistries;
import net.minecraftforge.registries.RegistryObject;

/*
 * MCreator note: This file will be REGENERATED on each build.
 */
public class ${JavaModName}Fluids {

	public static final DeferredRegister<Fluid> REGISTRY = DeferredRegister.create(ForgeRegistries.FLUIDS, ${JavaModName}.MODID);

	<#list fluids as fluid>
	public static final RegistryObject<FlowingFluid> ${fluid.getModElement().getRegistryNameUpper()} =
		REGISTRY.register("${fluid.getModElement().getRegistryName()}", ${fluid.getModElement().getName()}Fluid.Source::new);
	public static final RegistryObject<FlowingFluid> FLOWING_${fluid.getModElement().getRegistryNameUpper()} =
		REGISTRY.register("flowing_${fluid.getModElement().getRegistryName()}", ${fluid.getModElement().getName()}Fluid.Flowing::new);
	</#list>

}
<#-- @formatter:on -->
