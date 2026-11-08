<#if data.textureBucket?has_content>
{
  "parent": "minecraft:item/generated",
  "textures": {
    "layer0": "${data.textureBucket.format("%s:item/%s")}"
  }
}
</#if>
