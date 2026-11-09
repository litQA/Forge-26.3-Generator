modLoader="javafml"
loaderVersion="[66,)"
license="${JavaConventions.escapeStringForJava(settings.getLicense())}"

[[mods]]
modId="${settings.getModID()}"
version="${settings.getCleanVersion()}"
displayName="${JavaConventions.escapeStringForJava(settings.getModName())}"
<#if settings.getUpdateURL()?has_content>
updateJSONURL="${JavaConventions.escapeStringForJava(settings.getUpdateURL())}"
</#if>
<#if settings.getWebsiteURL()?has_content>
displayURL="${JavaConventions.escapeStringForJava(settings.getWebsiteURL())}"
</#if>
<#if settings.getCredits()?has_content>
credits="${JavaConventions.escapeStringForJava(settings.getCredits())}"
</#if>
<#if settings.getAuthor()?has_content>
authors="${JavaConventions.escapeStringForJava(settings.getAuthor())}"
</#if>
<#if settings.getDescription()?has_content>
description="${JavaConventions.escapeStringForJava(settings.getDescription())}"
</#if>
<#if settings.isServerSideOnly()>
displayTest="IGNORE_SERVER_VERSION"
</#if>

# Start of user code block mod configuration
# End of user code block mod configuration

<#if fragments.mixin?size != 0>
[[mixins]]
    config = "${settings.getModID()}.mixins.json"
</#if>

[[dependencies.${settings.getModID()}]]
    modId="forge"
    mandatory=true
    versionRange="[66,)"
    ordering="NONE"
    side="BOTH"

[[dependencies.${settings.getModID()}]]
    modId="minecraft"
    mandatory=true
    versionRange="[26.3,26.4,)"
    ordering="NONE"
    side="BOTH"

<#list settings.getRequiredMods() as e>
[[dependencies.${settings.getModID()}]]
    modId="${e}"
    mandatory=true
    versionRange="${settings.getVersionRange(e)}"
    ordering="NONE"
    side="BOTH"
</#list>

<#list settings.getDependencies() as e>
[[dependencies.${settings.getModID()}]]
    modId="${e}"
    mandatory=false
    versionRange="${settings.getVersionRange(e)}"
    ordering="NONE"
    side="BOTH"
</#list>

<#list settings.getDependants() as e>
[[dependencies.${settings.getModID()}]]
    modId="${e}"
    mandatory=false
    versionRange="[0,)"
    ordering="NONE"
    side="BOTH"
</#list>

# Start of user code block dependencies configuration
# End of user code block dependencies configuration
