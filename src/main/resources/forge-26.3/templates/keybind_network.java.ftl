<#-- @formatter:off -->
package ${package}.network;

public final class ${JavaModName}Network {

	public static final SimpleChannel CHANNEL = ChannelBuilder
		.named(Identifier.fromNamespaceAndPath(${JavaModName}.MODID, "main"))
		.networkProtocolVersion(1)
		.simpleChannel()
			.play()
				.bidirectional()
					<#list keybinds as keybind>
					<#if hasProcedure(keybind.onKeyPressed) || hasProcedure(keybind.onKeyReleased)>
					.addMain(${keybind.getModElement().getName()}Message.class, ${keybind.getModElement().getName()}Message.STREAM_CODEC, ${keybind.getModElement().getName()}Message::handle)
					</#if>
					</#list>
			.build();

	private ${JavaModName}Network() {
	}

	public static void init() {
	}

}
<#-- @formatter:on -->
