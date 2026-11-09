<#assign humanoidTexture = "${modid}:${data.armorTextureFile}_layer_1">
<#assign leggingsTexture = "${modid}:${data.armorTextureFile}_layer_2">
<#if data.helmetModelTexture?has_content && data.helmetModelTexture != "From armor">
	<#assign humanoidTexture = "${modid}:" + data.helmetModelTexture?replace(".png", "")>
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

