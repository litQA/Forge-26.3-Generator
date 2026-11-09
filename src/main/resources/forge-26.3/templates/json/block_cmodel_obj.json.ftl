{
  "loader": "forge:obj",
  "render_type": "${(parent???then(parent, data)).getRenderType()}",
  "model": "${modid}:models/item/${data.customModelName.split(":")[0]}.obj",
  "emissive_ambient": true
}
