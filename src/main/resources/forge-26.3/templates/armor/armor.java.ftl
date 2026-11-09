<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">
<#include "../triggers.java.ftl">
<#assign modifiesDefaultComponents = (data.maxDamage == 0 && (data.enableHelmet || data.enableBody || data.enableLeggings || data.enableBoots))>
package ${package}.item;

import java.util.Map;

<@javacompress>
<#if modifiesDefaultComponents>
@Mod.EventBusSubscriber(modid = "${modid}")
</#if>
public abstract class ${name}Item extends Item {

	public static ArmorMaterial ARMOR_MATERIAL = new ArmorMaterial(
		${data.maxDamage},
		Map.of(
			ArmorType.BOOTS, ${data.damageValueBoots},
			ArmorType.LEGGINGS, ${data.damageValueLeggings},
			ArmorType.CHESTPLATE, ${data.damageValueBody},
			ArmorType.HELMET, ${data.damageValueHelmet},
			ArmorType.BODY, ${data.damageValueBody}
		),
		${data.enchantability},
		<#if data.equipSound?has_content && data.equipSound.getUnmappedValue()?has_content>
		BuiltInRegistries.SOUND_EVENT.wrapAsHolder(BuiltInRegistries.SOUND_EVENT.getValue(Identifier.parse("${data.equipSound}"))),
		<#else>
		BuiltInRegistries.SOUND_EVENT.wrapAsHolder(SoundEvents.EMPTY),
		</#if>
		${data.toughness}f,
		${data.knockbackResistance}f,
		TagKey.create(Registries.ITEM, Identifier.parse("${modid}:${registryname}_repair_items")), <#-- data.repairItems are put into a tag -->
		ResourceKey.create(EquipmentAssets.ROOT_ID, Identifier.parse("${modid}:${registryname}")) <#-- data.armorTextureFile - just dummy, we override this in client extensions -->
	);

	private ${name}Item(Item.Properties properties) {
		super(properties);
	}

	<#assign customHelmetModel = data.enableHelmet && data.helmetModelName != "Default" && data.getHelmetModel()?? && data.helmetModelPart?has_content>
	<#assign customBodyModel = data.enableBody && data.bodyModelName != "Default" && data.getBodyModel()?? && data.bodyModelPart?has_content && data.armsModelPartL?has_content && data.armsModelPartR?has_content>
	<#assign customLeggingsModel = data.enableLeggings && data.leggingsModelName != "Default" && data.getLeggingsModel()?? && (data.leggingsModelPartL?has_content || data.leggingsModelPartR?has_content)>
	<#assign customBootsModel = data.enableBoots && data.bootsModelName != "Default" && data.getBootsModel()?? && data.bootsModelPartL?has_content && data.bootsModelPartR?has_content>
	<#if customHelmetModel || customBodyModel || customLeggingsModel || customBootsModel>
	@Override public void initializeClient(Consumer<IClientItemExtensions> consumer) {
		consumer.accept(new IClientItemExtensions() {
			<#if customHelmetModel>private HumanoidModel<?> helmetModel;</#if>
			<#if customBodyModel>private HumanoidModel<?> bodyModel;</#if>
			<#if customLeggingsModel>private HumanoidModel<?> leggingsModel;</#if>
			<#if customBootsModel>private HumanoidModel<?> bootsModel;</#if>

			@Override public HumanoidModel<?> getHumanoidArmorModel(LivingEntityRenderState state, ItemStack stack, EquipmentSlot slot, HumanoidModel<?> original) {
				<#if customHelmetModel>
				if (slot == EquipmentSlot.HEAD) {
					if (helmetModel == null) {
						var custom = new ${package}.client.model.${data.helmetModelName}(Minecraft.getInstance().getEntityModels().bakeLayer(${package}.client.model.${data.helmetModelName}.LAYER_LOCATION));
						helmetModel = new HumanoidModel<>(new ModelPart(Collections.emptyList(), Map.of(
							"head", new ModelPart(Collections.emptyList(), Map.of(
								"head", custom.${data.helmetModelPart},
								"hat", new ModelPart(Collections.emptyList(), Collections.emptyMap())
							)),
							"body", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
							"right_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
							"left_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
							"right_leg", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
							"left_leg", new ModelPart(Collections.emptyList(), Collections.emptyMap())
						))<#if data.helmetTranslucency>, RenderTypes::entityTranslucent</#if>) {
							@Override public void setupAnim(HumanoidRenderState state) {
								super.setupAnim(state);
								custom.setupAnim(state);
							}
						};
					}
					return helmetModel;
				}
				</#if>
				<#if customBodyModel>
				if (slot == EquipmentSlot.CHEST) {
					if (bodyModel == null) {
						var custom = new ${package}.client.model.${data.bodyModelName}(Minecraft.getInstance().getEntityModels().bakeLayer(${package}.client.model.${data.bodyModelName}.LAYER_LOCATION));
						bodyModel = new HumanoidModel<>(new ModelPart(Collections.emptyList(), Map.of(
							"body", custom.${data.bodyModelPart},
							"right_arm", custom.${data.armsModelPartL},
							"left_arm", custom.${data.armsModelPartR},
							"head", new ModelPart(Collections.emptyList(), Map.of(
								"hat", new ModelPart(Collections.emptyList(), Collections.emptyMap())
							)),
							"right_leg", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
							"left_leg", new ModelPart(Collections.emptyList(), Collections.emptyMap())
						))<#if data.bodyTranslucency>, RenderTypes::entityTranslucent</#if>) {
							@Override public void setupAnim(HumanoidRenderState state) {
								super.setupAnim(state);
								custom.setupAnim(state);
							}
						};
					}
					return bodyModel;
				}
				</#if>
				<#if customLeggingsModel>
				if (slot == EquipmentSlot.LEGS) {
					if (leggingsModel == null) {
						var custom = new ${package}.client.model.${data.leggingsModelName}(Minecraft.getInstance().getEntityModels().bakeLayer(${package}.client.model.${data.leggingsModelName}.LAYER_LOCATION));
						leggingsModel = new HumanoidModel<>(new ModelPart(Collections.emptyList(), Map.of(
							"left_leg", <#if data.leggingsModelPartL?has_content>custom.${data.leggingsModelPartL}<#else>new ModelPart(Collections.emptyList(), Collections.emptyMap())</#if>,
							"right_leg", <#if data.leggingsModelPartR?has_content>custom.${data.leggingsModelPartR}<#else>new ModelPart(Collections.emptyList(), Collections.emptyMap())</#if>,
							"head", new ModelPart(Collections.emptyList(), Map.of(
								"hat", new ModelPart(Collections.emptyList(), Collections.emptyMap())
							)),
							"body", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
							"right_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
							"left_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap())
						))<#if data.leggingsTranslucency>, RenderTypes::entityTranslucent</#if>) {
							@Override public void setupAnim(HumanoidRenderState state) {
								super.setupAnim(state);
								custom.setupAnim(state);
							}
						};
					}
					return leggingsModel;
				}
				</#if>
				<#if customBootsModel>
				if (slot == EquipmentSlot.FEET) {
					if (bootsModel == null) {
						var custom = new ${package}.client.model.${data.bootsModelName}(Minecraft.getInstance().getEntityModels().bakeLayer(${package}.client.model.${data.bootsModelName}.LAYER_LOCATION));
						bootsModel = new HumanoidModel<>(new ModelPart(Collections.emptyList(), Map.of(
							"left_leg", custom.${data.bootsModelPartL},
							"right_leg", custom.${data.bootsModelPartR},
							"head", new ModelPart(Collections.emptyList(), Map.of(
								"hat", new ModelPart(Collections.emptyList(), Collections.emptyMap())
							)),
							"body", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
							"right_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap()),
							"left_arm", new ModelPart(Collections.emptyList(), Collections.emptyMap())
						))<#if data.bootsTranslucency>, RenderTypes::entityTranslucent</#if>) {
							@Override public void setupAnim(HumanoidRenderState state) {
								super.setupAnim(state);
								custom.setupAnim(state);
							}
						};
					}
					return bootsModel;
				}
				</#if>
				return original;
			}
		});
	}
	</#if>

	<#if modifiesDefaultComponents>
	@SubscribeEvent public static void modifyDamageComponent(ModifyDefaultComponentsEvent event) {
		<#if data.enableHelmet>event.modify(${JavaModName}Items.${REGISTRYNAME}_HELMET.get(), (builder, _, _) -> builder.set(DataComponents.MAX_DAMAGE, null));</#if>
		<#if data.enableBody>event.modify(${JavaModName}Items.${REGISTRYNAME}_CHESTPLATE.get(), (builder, _, _) -> builder.set(DataComponents.MAX_DAMAGE, null));</#if>
		<#if data.enableLeggings>event.modify(${JavaModName}Items.${REGISTRYNAME}_LEGGINGS.get(), (builder, _, _) -> builder.set(DataComponents.MAX_DAMAGE, null));</#if>
		<#if data.enableBoots>event.modify(${JavaModName}Items.${REGISTRYNAME}_BOOTS.get(), (builder, _, _) -> builder.set(DataComponents.MAX_DAMAGE, null));</#if>
	}
	</#if>

	<#if data.enableHelmet>
	public static class Helmet extends ${name}Item {

		public Helmet(Item.Properties properties) {
			super(<@itemProperties "HELMET" data.helmetImmuneToFire/>
					<@itemAttributeModifiers data.attributeModifiers?filter(e -> e.armorPieces[0]) "helmet" "EquipmentSlotGroup.HEAD" data.damageValueHelmet/>);
		}

		<@addSpecialInformation data.helmetSpecialInformation, "item." + modid + "." + registryname + "_helmet"/>

		<@hasGlow data.helmetGlowCondition/>

		<@piglinNeutral data.helmetPiglinNeutral/>

		<@onArmorTick data.onHelmetTick/>
	}
	</#if>

	<#if data.enableBody>
	public static class Chestplate extends ${name}Item {

		public Chestplate(Item.Properties properties) {
			super(<@itemProperties "CHESTPLATE" data.bodyImmuneToFire/>
					<@itemAttributeModifiers data.attributeModifiers?filter(e -> e.armorPieces[1]) "chestplate" "EquipmentSlotGroup.CHEST" data.damageValueBody/>);
		}

		<@addSpecialInformation data.bodySpecialInformation, "item." + modid + "." + registryname + "_chestplate"/>

		<@hasGlow data.bodyGlowCondition/>

		<@piglinNeutral data.bodyPiglinNeutral/>

		<@onArmorTick data.onBodyTick/>
	}
	</#if>

	<#if data.enableLeggings>
	public static class Leggings extends ${name}Item {

		public Leggings(Item.Properties properties) {
			super(<@itemProperties "LEGGINGS" data.leggingsImmuneToFire/>
					<@itemAttributeModifiers data.attributeModifiers?filter(e -> e.armorPieces[2]) "leggings" "EquipmentSlotGroup.LEGS" data.damageValueLeggings/>);
		}

		<@addSpecialInformation data.leggingsSpecialInformation, "item." + modid + "." + registryname + "_leggings"/>

		<@hasGlow data.leggingsGlowCondition/>

		<@piglinNeutral data.leggingsPiglinNeutral/>

		<@onArmorTick data.onLeggingsTick/>
	}
	</#if>

	<#if data.enableBoots>
	public static class Boots extends ${name}Item {

		public Boots(Item.Properties properties) {
			super(<@itemProperties "BOOTS" data.bootsImmuneToFire/>
					<@itemAttributeModifiers data.attributeModifiers?filter(e -> e.armorPieces[3]) "boots" "EquipmentSlotGroup.FEET" data.damageValueBoots/>);
		}

		<@addSpecialInformation data.bootsSpecialInformation, "item." + modid + "." + registryname + "_boots"/>

		<@hasGlow data.bootsGlowCondition/>

		<@piglinNeutral data.bootsPiglinNeutral/>

		<@onArmorTick data.onBootsTick/>
	}
	</#if>

}
</@javacompress>
<#-- @formatter:on -->

<#macro itemProperties armorPart immuneToFire>
properties.humanoidArmor(ARMOR_MATERIAL, ArmorType.${armorPart})
<#if immuneToFire>
.fireResistant()
</#if>
<#if data.rarity != "COMMON">
.rarity(Rarity.${data.rarity})
</#if>
</#macro>

<#macro itemAttributeModifiers modifiers armorPart defaultEquipSlot defense>
<#if modifiers?size != 0>
.attributes(
	ItemAttributeModifiers.builder()
	<#-- First add the default armor attributes -->
	.add(Attributes.ARMOR, new AttributeModifier(Identifier.withDefaultNamespace("armor.${armorPart}"), ${defense}, AttributeModifier.Operation.ADD_VALUE), ${defaultEquipSlot})
	<#if data.toughness != 0>.add(Attributes.ARMOR_TOUGHNESS, new AttributeModifier(Identifier.withDefaultNamespace("armor.${armorPart}"), ${data.toughness}, AttributeModifier.Operation.ADD_VALUE), ${defaultEquipSlot})</#if>
	<#if data.knockbackResistance != 0>.add(Attributes.KNOCKBACK_RESISTANCE, new AttributeModifier(Identifier.withDefaultNamespace("armor.${armorPart}"), ${data.knockbackResistance}, AttributeModifier.Operation.ADD_VALUE), ${defaultEquipSlot})</#if>
	<#-- Then add the custom modifiers -->
	<#list modifiers as modifier>
	.add(${modifier.attribute}, new AttributeModifier(
			Identifier.fromNamespaceAndPath(${JavaModName}.MODID, "${registryname}_${modifier?index}.${armorPart}"),
			${modifier.amount}, AttributeModifier.Operation.${modifier.operation}),
			<#if modifier.equipmentSlot.getUnmappedValue() == "default">${defaultEquipSlot}<#else>${modifier.equipmentSlot}</#if>)
	</#list>.build()
)
</#if>
</#macro>
