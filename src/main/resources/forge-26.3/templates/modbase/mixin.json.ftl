{
  "required": true,
  "package": "${package}.mixin",
  "refmap": "${modid}.refmap.json",
  "compatibilityLevel": "JAVA_25",
  "mixins": [
	<#list fragments.mixin as mixin>"${mixin}"<#sep>,</#list>
  ],
  "client": [
  ],
  "injectors": {
    "defaultRequire": 1
  },
  "minVersion": "0.8.4"
}