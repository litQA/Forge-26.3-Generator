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
      "data": {
        "type": "${modid}:${registryname}",
        "minCount": ${data.minNumberOfMobsPerGroup},
        "maxCount": ${data.maxNumberOfMobsPerGroup}
      },
      "weight": ${data.spawningProbability}
    }
  ]
}
