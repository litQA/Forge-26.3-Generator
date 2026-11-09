<#assign humanoidTexture = "${modid}:${data.armorTextureFile}_layer_1">
<#assign leggingsTexture = "${modid}:${data.armorTextureFile}_layer_2">
<#if data.bootsModelTexture?has_content && data.bootsModelTexture != "From armor">
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

