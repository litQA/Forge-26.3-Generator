<#assign spawnBiomes = w.filterBrokenReferences(data.restrictionBiomes)>
{
  "type": "forge:add_spawns",
  <#if spawnBiomes?size == 1>
  "biomes": "${spawnBiomes?first}",
  <#elseif spawnBiomes?size gt 1>
  "biomes": [
    <#list spawnBiomes as spawnBiome>"${spawnBiome}"<#sep>,</#list>
  ],
  <#else>
  "biomes": "#minecraft:is_overworld",
  </#if>
  "spawners": [
    {
      "type": "${modid}:${registryname}",
      <#if data.minNumberOfMobsPerGroup == data.maxNumberOfMobsPerGroup>
      "count": ${data.minNumberOfMobsPerGroup},
      <#else>
      "count": {
        "type": "minecraft:uniform",
        "min_inclusive": ${data.minNumberOfMobsPerGroup},
        "max_inclusive": ${data.maxNumberOfMobsPerGroup}
      },
      </#if>
      "weight": ${data.spawningProbability}
    }
  ]
}
