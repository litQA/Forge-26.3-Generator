<#assign humanoidTexture = "${modid}:${data.armorTextureFile}_layer_1">
<#assign leggingsTexture = "${modid}:${data.armorTextureFile}_layer_2">
<#if data.leggingsModelTexture?has_content && data.leggingsModelTexture != "From armor">
	<#assign leggingsTexture = "${modid}:" + data.leggingsModelTexture?replace(".png", "")>
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

