{
  "parent": "forge:item/bucket",
  "loader": "forge:fluid_container",
  "fluid": "${modid}:${registryname}",
  "textures": {
    "particle": "${data.textureStill.format("%s:block/%s")}"
    <#if data.textureBucket?has_content>,
    "base": "${data.textureBucket.format("%s:item/%s")}"
    </#if>
  }
}
