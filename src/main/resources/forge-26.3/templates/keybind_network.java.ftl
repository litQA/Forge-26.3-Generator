<#-- @formatter:off -->
package ${package}.network;

public final class ${JavaModName}Network {

	public static final SimpleChannel CHANNEL = ChannelBuilder
		.named(Identifier.fromNamespaceAndPath(${JavaModName}.MODID, "main"))
		.networkProtocolVersion(1)
		.simpleChannel()
			.play()
				.bidirectional()
					<#list guis![] as gui>
					<#if gui.hasButtonEvents()>
					.addMain(${gui.getModElement().getName()}ButtonMessage.class, ${gui.getModElement().getName()}ButtonMessage.STREAM_CODEC, ${gui.getModElement().getName()}ButtonMessage::handle)
					</#if>
					<#if gui.hasSliderEvents()>
					.addMain(${gui.getModElement().getName()}SliderMessage.class, ${gui.getModElement().getName()}SliderMessage.STREAM_CODEC, ${gui.getModElement().getName()}SliderMessage::handle)
					</#if>
					<#if gui.hasSlotEvents()>
					.addMain(${gui.getModElement().getName()}SlotMessage.class, ${gui.getModElement().getName()}SlotMessage.STREAM_CODEC, ${gui.getModElement().getName()}SlotMessage::handle)
					</#if>
					</#list>
					<#if guis?has_content>
					.addMain(MenuStateUpdateMessage.class, MenuStateUpdateMessage.STREAM_CODEC, MenuStateUpdateMessage::handle)
					</#if>
					<#list keybinds![] as keybind>
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
