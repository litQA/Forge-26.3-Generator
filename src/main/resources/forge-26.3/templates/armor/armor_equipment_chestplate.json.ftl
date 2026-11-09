<#assign humanoidTexture = "${modid}:${data.armorTextureFile}_layer_1">
<#assign leggingsTexture = "${modid}:${data.armorTextureFile}_layer_2">
<#if data.bodyModelTexture?has_content && data.bodyModelTexture != "From armor">
	<#assign humanoidTexture = "${modid}:" + data.bodyModelTexture?replace(".png", "")>
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

