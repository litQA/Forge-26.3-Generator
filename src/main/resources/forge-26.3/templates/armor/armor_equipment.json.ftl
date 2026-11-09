<#assign humanoidTexture = "${modid}:${data.armorTextureFile}_layer_1">
<#assign leggingsTexture = "${modid}:${data.armorTextureFile}_layer_2">
<#if part == "helmet" && data.helmetModelTexture?has_content && data.helmetModelTexture != "From armor">
	<#assign humanoidTexture = "${modid}:" + data.helmetModelTexture?replace(".png", "")>
<#elseif part == "chestplate" && data.bodyModelTexture?has_content && data.bodyModelTexture != "From armor">
	<#assign humanoidTexture = "${modid}:" + data.bodyModelTexture?replace(".png", "")>
<#elseif part == "leggings" && data.leggingsModelTexture?has_content && data.leggingsModelTexture != "From armor">
	<#assign leggingsTexture = "${modid}:" + data.leggingsModelTexture?replace(".png", "")>
<#elseif part == "boots" && data.bootsModelTexture?has_content && data.bootsModelTexture != "From armor">
	<#assign humanoidTexture = "${modid}:" + data.bootsModelTexture?replace(".png", "")>
</#if>
{
  "layers": {
    "humanoid": [
      {
        "texture": "${humanoidTexture}"
      }
    ],
    "humanoid_leggings": [
      {
        "texture": "${leggingsTexture}"
      }
    ]
  }
}
