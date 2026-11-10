package ${package}.network;
import net.minecraftforge.eventbus.api.listener.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraft.resources.Identifier;
import net.minecraftforge.common.capabilities.Capability;
import net.minecraftforge.common.util.LazyOptional;

import ${package}.${JavaModName};

import net.minecraft.core.HolderLookup;
import net.minecraft.core.registries.Registries;
import net.minecraft.nbt.CompoundTag;
import net.minecraft.resources.Identifier;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.util.ProblemReporter;
import net.minecraft.world.entity.Entity;
import net.minecraft.world.entity.player.Player;
import net.minecraft.world.level.Level;
import net.minecraft.world.level.LevelAccessor;
import net.minecraft.world.level.storage.TagValueInput;
import net.minecraft.world.level.storage.TagValueOutput;
import net.minecraft.world.level.storage.ValueInput;

import net.minecraftforge.common.capabilities.AutoRegisterCapability;
import net.minecraftforge.common.capabilities.Capability;
import net.minecraftforge.common.capabilities.CapabilityManager;
import net.minecraftforge.common.capabilities.CapabilityToken;
import net.minecraftforge.common.capabilities.ICapabilityProvider;
import net.minecraftforge.common.capabilities.ICapabilitySerializable;
import net.minecraftforge.common.util.INBTSerializable;
import net.minecraftforge.common.util.LazyOptional;
import net.minecraftforge.event.AttachCapabilitiesEvent;
import net.minecraftforge.eventbus.api.listener.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.event.IModBusEvent;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Mod.EventBusSubscriber(modid = "${modid}")
public final class ${JavaModName}Variables {
	public static final Capability<PlayerVariables> PLAYER_VARIABLES = CapabilityManager.get(new CapabilityToken<>() {
	});

	private ${JavaModName}Variables() {
	}

	<#if w.hasVariablesOfScope("GLOBAL_SESSION")>
	<#list variables as var>
		<#if var.getScope().name() == "GLOBAL_SESSION">
		<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_SESSION")['init']?interpret/>
		</#if>
	</#list>
	</#if>

	@SubscribeEvent
	public static void attach(AttachCapabilitiesEvent.Entities event) {
		if (event.getObject() instanceof Player)
			event.addCapability(Identifier.fromNamespaceAndPath("${modid}", "player_variables"), new PlayerVariablesProvider());
	}

	public static PlayerVariables getPlayerVariables(Entity entity) {
		if (entity instanceof Player player)
			return player.getCapability(PLAYER_VARIABLES).orElseGet(PlayerVariables::new);
		return new PlayerVariables();
	}

	<#if w.hasVariablesOfScope("GLOBAL_WORLD") || w.hasVariablesOfScope("GLOBAL_MAP")>
	public static class WorldVariables extends net.minecraft.world.level.saveddata.SavedData {
		public static final net.minecraft.world.level.saveddata.SavedDataType<WorldVariables> TYPE = new net.minecraft.world.level.saveddata.SavedDataType<>(
			Identifier.fromNamespaceAndPath("${modid}", "worldvars"), level -> new WorldVariables(),
			level -> CompoundTag.CODEC.xmap(tag -> {
				WorldVariables instance = new WorldVariables();
				instance.read(tag, level.registryAccess());
				return instance;
			}, instance -> instance.save(new CompoundTag(), level.registryAccess())), net.minecraft.util.datafix.DataFixTypes.SAVED_DATA_MAP_DATA);

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_WORLD">
			<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['init']?interpret/>
			</#if>
		</#list>

		public void read(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['read']?interpret/>
				</#if>
			</#list>
		}

		public CompoundTag save(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_WORLD">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_WORLD")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void markSyncDirty() {
			this.setDirty();
		}

		static final WorldVariables CLIENT_SIDE = new WorldVariables();

		public static WorldVariables get(LevelAccessor world) {
			if (world instanceof ServerLevel level)
				return level.getDataStorage().computeIfAbsent(TYPE);
			return CLIENT_SIDE;
		}
	}

	public static class MapVariables extends net.minecraft.world.level.saveddata.SavedData {
		public static final net.minecraft.world.level.saveddata.SavedDataType<MapVariables> TYPE = new net.minecraft.world.level.saveddata.SavedDataType<>(
			Identifier.fromNamespaceAndPath("${modid}", "mapvars"), level -> new MapVariables(),
			level -> CompoundTag.CODEC.xmap(tag -> {
				MapVariables instance = new MapVariables();
				instance.read(tag, level.registryAccess());
				return instance;
			}, instance -> instance.save(new CompoundTag(), level.registryAccess())), net.minecraft.util.datafix.DataFixTypes.SAVED_DATA_MAP_DATA);

		boolean _syncDirty = false;

		<#list variables as var>
			<#if var.getScope().name() == "GLOBAL_MAP">
			<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['init']?interpret/>
			</#if>
		</#list>

		public void read(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['read']?interpret/>
				</#if>
			</#list>
		}

		public CompoundTag save(CompoundTag nbt, HolderLookup.Provider lookupProvider) {
			<#list variables as var>
				<#if var.getScope().name() == "GLOBAL_MAP">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "GLOBAL_MAP")['write']?interpret/>
				</#if>
			</#list>
			return nbt;
		}

		public void markSyncDirty() {
			this.setDirty();
		}

		static final MapVariables CLIENT_SIDE = new MapVariables();

		public static MapVariables get(LevelAccessor world) {
			if (world instanceof ServerLevel level)
				return level.getServer().getLevel(Level.OVERWORLD).getDataStorage().computeIfAbsent(TYPE);
			return CLIENT_SIDE;
		}
	}
	</#if>

	<#if true>
	@AutoRegisterCapability
	public static class PlayerVariables implements INBTSerializable<CompoundTag> {
		<#list variables as var>
			<#if var.getScope().name() == "PLAYER_LIFETIME">
			<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['init']?interpret/>
			<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
			<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['init']?interpret/>
			</#if>
		</#list>

		@Override
		public CompoundTag serializeNBT(HolderLookup.Provider provider) {
			TagValueOutput output = TagValueOutput.createWithContext(ProblemReporter.DISCARDING, provider);
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['write']?interpret/>
				<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['write']?interpret/>
				</#if>
			</#list>
			return output.buildResult();
		}

		@Override
		public void deserializeNBT(HolderLookup.Provider provider, CompoundTag nbt) {
			ValueInput input = TagValueInput.create(ProblemReporter.DISCARDING, provider, nbt);
			<#list variables as var>
				<#if var.getScope().name() == "PLAYER_LIFETIME">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_LIFETIME")['read']?interpret/>
				<#elseif var.getScope().name() == "PLAYER_PERSISTENT">
				<@var.getType().getScopeDefinition(generator.getWorkspace(), "PLAYER_PERSISTENT")['read']?interpret/>
				</#if>
			</#list>
		}

		public void markSyncDirty() {
		}
	}

	public static final class PlayerVariablesProvider implements ICapabilitySerializable<CompoundTag> {
		private final PlayerVariables variables = new PlayerVariables();
		private final LazyOptional<PlayerVariables> optional = LazyOptional.of(() -> variables);

		@Override
		public <T> LazyOptional<T> getCapability(Capability<T> capability, net.minecraft.core.Direction side) {
			return capability == PLAYER_VARIABLES ? optional.cast() : LazyOptional.empty();
		}

		@Override
		public CompoundTag serializeNBT(HolderLookup.Provider provider) {
			return variables.serializeNBT(provider);
		}

		@Override
		public void deserializeNBT(HolderLookup.Provider provider, CompoundTag nbt) {
			variables.deserializeNBT(provider, nbt);
		}
	}
	</#if>
}
