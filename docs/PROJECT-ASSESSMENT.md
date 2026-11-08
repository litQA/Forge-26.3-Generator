# Forge 26.3 Generator 项目评估

> 评估对象：基于 MCreator 官方 NeoForge 26.3 生成器，交付一个面向 Minecraft Forge 26.3 / Forge 66.1.5、目标 MCreator EAP `2026.3.44621` 的独立生成器。
>
> 评估结论：**技术可行，但工作量属于“加载器整体移植”，不是简单替换包名。** 现有生成器约 947 个资源文件，其中约 100 个文件直接涉及加载器 API；65 个全局触发器中有 57 个可以直接映射、8 个需要适配、0 个在事件层面完全不可实现。最大风险集中在 Forge 26.3 的新事件总线、网络、Capability/资源处理器、玩家变量持久化，以及本机 Gradle/ForgeGradle 工具链。
>
> 本评估只做盘点、验证和方案选择，**不包含生成器实现代码**。评估通过后再进入 Phase 0。

---

## 0. 结论摘要

| 项目 | 结论 |
| --- | --- |
| 总体可行性 | 可行。Fabric 26.3 官方生成器已经证明“同一 MCreator 版本下做加载器级转换”是成熟路线。 |
| 推荐架构 | **完整分叉（full fork）** NeoForge 26.3 生成器到本地 `forge-26.3`，只 import 与加载器无关的 `datapack-26.3.x`；**不 import `neoforge-26.3`**。 |
| 纯净度可验证性 | 高。分叉后可以用“禁用词扫描 + Forge-only 类路径编译”双重验证，不依赖对上游覆盖规则的记忆。 |
| 生成器规模 | 约 950 个文件；37 个元素定义；164 个模板；567 个流程模板；65 个触发器；23 个映射表。 |
| 加载器耦合面 | 约 100 个文件（宽口径 103 个），其中模板 51、流程 30、变量 7、触发器 4、构建/定义/映射约 11。 |
| 触发器盘点 | Easy 57 / Hard 8 / Impossible 0（其中 `entity_ticks` 若无 Mixin 则降级为 Impossible）。 |
| 预计工作量 | 约 36–49 人日，拆成 13 个可验收批次（可按 12–16 个批次合并/拆分）；实际日历时间取决于每轮真机测试反馈。 |
| 首批建议 | Phase 0 先做“构建链 + modbase + 方块/物品/创造标签 + 1 个触发器”的最小闭环，先验证最高风险的 Forge API 和 Gradle 链。 |
| 当前环境阻塞 | 本机 JBR 25 的 `Files.isWritable` 恒为 false，标准 Gradle 9.8 无法配置项目；ForgeGradle 的 AT 处理还会遇到 `ReadOnlyFileSystemException`。需要专用构建环境或打补丁的 Gradle，详见第 11 节。 |

---

## 1. 评估范围与判定口径

### 1.1 范围

- 目标平台：Minecraft 26.3 + Forge `26.3-66.1.5`。
- 目标 MCreator：EAP `2026.3.44621`（`EAP2026344621`）。
- 目标产物：`generator-forge-26.3.zip`，生成器目录 `forge-26.3`，插件 ID `generator-forge-26.3`。
- 覆盖范围：NeoForge 26.3 生成器当前提供的全部元素、流程、触发器、AI 任务、命令参数、变量、映射与工作区基础文件。
- 非范围：Forge 旧版本（1.20.1 及以下）、Fabric、NeoForge 兼容层、第三方模组 API 适配。

### 1.2 判定口径

| 标记 | 含义 |
| --- | --- |
| Easy | Forge 26.3 存在同名或仅需重命名/改包/改访问器的等价事件或 API，不需要新增子系统。 |
| Hard | Forge 26.3 有事件，但语义、访问器或生命周期不同；需要适配器、客户端守卫、Mixin 或专门模板。 |
| Impossible | Forge 26.3 没有事件，也没有安全的 Mixin/AT 路径；在当前约束下无法实现。 |
| 加载器耦合文件 | 文件中出现 `net.neoforged`、`NeoForge`、`DeferredHolder`、`DeferredBlock`、`DeferredItem`、`ResourceHandler`、`AttachmentType`、`RegisterCapabilitiesEvent`、`RegisterPayloadHandlersEvent`、`neoforge:` 等任一线索。该口径偏保守，包含少量误报。 |
| 纯净 | 生成器源码中没有 NeoForge 专用符号；生成的工作区代码在 Forge-only 类路径下可编译，且不出现 `net.neoforged` 导入。 |

---

## 2. 参考基线盘点

| 参考 | 位置 | 规模/作用 | 评估用途 |
| --- | --- | --- | --- |
| MCreator EAP | `MCreatorEAP2026344621/` | `2026.3.44621`，Java 25 | 目标运行环境、Gradle 工具链、插件加载 |
| 官方 NeoForge 26.3 生成器 | `reference_resources/generator-26.3.x/neoforge-26.3/` | 947 个文件，854 个 `.ftl`，82 个 `.yaml` | 元素定义、模板、流程、触发器、变量、构建基线的唯一主参考 |
| 官方 Datapack 26.3 生成器 | `reference_resources/generator-26.3.x/datapack-26.3.x/` | 239 个文件 | 与加载器无关的数据包元素（配方、战利品表、结构、维度 JSON 等） |
| 官方 Fabric 26.3 生成器 | `reference_resources/Fabric-Generator-MCreator-26.3-2026.3-2.9-beta/` | 706 个文件，480 个流程，41 个触发器 | 加载器转换方法的直接先例：import NeoForge 并覆盖加载器层 |
| Forge 66.1.5 MDK | `reference_resources/forge-26.3-66.1.5-mdk/` | 官方最小工作区 | 构建脚本、`mods.toml`、Forge 26.3 入口 API 的权威样例 |
| Forge 26.3 源码 | `caches/reference/MinecraftForge-26.3/` | GitHub `MinecraftForge/MinecraftForge` 分支 `26.3` | 事件、注册、网络、Capability、客户端扩展的精确签名 |
| NeoForge 26.3 源码 | `caches/reference/NeoForge-26.3.x/` | GitHub `neoforged/NeoForge` 分支 `26.3.x` | 与官方生成器实际调用的 API 对照 |
| Forge 1.12.2 插件工程 | `../Forge_Generator_1.12.2/plugin-branch-2026.3/` | 完整插件工程 | 可复用的 build/validator/package/CHANGELOG/版本单源脚手架 |
| Forge Config API Port | `../Forge_Config_API_Port/` | 多版本 Forge/NeoForge 模板 | Forge 26.3 `configs.java.ftl` 的现成写法，以及 Gradle 补丁先例 |
| Gradle 9.8.0 | `reference_resources/gradle-9.8.0-bin.zip` | 本地发行包 | 生成工作区 wrapper 的本地分发源 |

---

## 3. Forge 26.3 关键技术事实

本节的事实均来自本地 Forge 26.3 源码、MDK 和 NeoForge 26.3 源码；括号内为证据路径。

### 3.1 构建链

Forge 26.3 的官方 MDK 使用：

- ForgeGradle `net.minecraftforge.gradle` 版本 `[7.0.17,8)`；
- Gradle 9.x（MDK 默认 9.7.1，本项目按要求统一 9.8.0）；
- Java 25 toolchain；
- 依赖坐标 `net.minecraftforge:forge:26.3-66.1.5`；
- 官方映射 `official-26.3`，生成代码直接使用 Mojang 名称（`net.minecraft.*` / `net.minecraftforge.*`），不再出现 SRG 名称。

生成工作区的 `build.gradle` 需要从 NeoForge 的 `net.neoforged.moddev` 改为：

```groovy
plugins {
    id 'eclipse'
    id 'net.minecraftforge.gradle' version '[7.0.17,8)'
}

minecraft {
    runs {
        configureEach { workingDir = layout.projectDirectory.dir('run') }
        register('client')
        register('server') { args '--nogui' }
    }
}

repositories {
    minecraft.mavenizer(it)
    maven fg.forgeMaven
    maven fg.minecraftLibsMaven
    mavenCentral()
}

dependencies {
    implementation minecraft.dependency('net.minecraftforge:forge:26.3-66.1.5')
}
```

（`reference_resources/forge-26.3-66.1.5-mdk/build.gradle`）

### 3.2 注册 API

| NeoForge 26.3 | Forge 26.3 | 影响 |
| --- | --- | --- |
| `DeferredRegister.Blocks` / `DeferredRegister.Items` | `DeferredRegister<Block>` / `DeferredRegister<Item>`，通过 `ForgeRegistries.BLOCKS` / `ForgeRegistries.ITEMS` 创建 | 方块/物品初始化模板全部重写 |
| `DeferredHolder<T, R>` | `RegistryObject<R>` | 17 个文件、约 34 处 |
| `DeferredBlock<T>` / `DeferredItem<T>` | `RegistryObject<T>` | 方块/物品模板 |
| `REGISTRY.registerBlock(name, supplier)` / `registerItem(...)` | `REGISTRY.register(name, supplier)` + 自建 helper | 12 个文件、约 31 处 |
| `REGISTRY.register(modEventBus)` | `REGISTRY.register(modBusGroup)` | modbase 全部初始化器 |
| 属性由 NeoForge helper 注入注册 ID | 必须显式 `.setId(REGISTRY.key("name"))` | 方块/物品属性构造是跨模板改动，见本节末段 |

Forge `DeferredRegister` 的 `register(String, Supplier)` 不会替对象设置注册 ID；官方 MDK 明确写了：

```java
new Block(BlockBehaviour.Properties.of()
    .setId(BLOCKS.key("example_block"))
    .mapColor(MapColor.STONE))
```

（`reference_resources/forge-26.3-66.1.5-mdk/src/main/java/com/example/examplemod/ExampleMod.java`）

因此生成器不能只把 `DeferredBlock` 改成 `RegistryObject`；必须在方块/物品的 properties 构造处补 `setId`，或者在 init helper 中提供带 ID 的 properties。这个改动会进入 `block.java.ftl`、`plant.java.ftl`、`fluidblock.java.ftl`、`item.java.ftl`、`tool.java.ftl`、`armor.java.ftl` 等模板，属于跨模板的“结构性机械改动”。

### 3.3 事件总线

Forge 26.3 已切换到新版事件总线 API：

- 注解：`net.minecraftforge.eventbus.api.listener.SubscribeEvent`（不是旧版 `net.minecraftforge.eventbus.api.SubscribeEvent`）；
- 总线组：`net.minecraftforge.eventbus.api.bus.BusGroup`；
- 自动注册：`@Mod.EventBusSubscriber(modid = MODID, bus = Mod.EventBusSubscriber.Bus.{FORGE|MOD|BOTH})`；
- mod 构造器：`public MyMod(FMLJavaModLoadingContext context)`，通过 `context.getModBusGroup()` 取得 mod 总线；
- 监听器注册：`FMLCommonSetupEvent.getBus(modBusGroup).addListener(this::commonSetup)`；
- 游戏总线上的实例监听器：`ServerTickEvent.Post.BUS.addListener(this::tick)` 一类写法，而不是 `NeoForge.EVENT_BUS.register(this)`。

（`caches/reference/MinecraftForge-26.3/.../javafmllanguage/src/main/java/net/minecraftforge/fml/common/Mod.java`、`.../FMLJavaModLoadingContext.java`、MDK `ExampleMod.java`）

生成器影响：

- 115 个文件使用 `@EventBusSubscriber`，需要改成 `@Mod.EventBusSubscriber`；
- 135 个文件使用 `@SubscribeEvent`，注解包名要改；
- mod 总线事件（`FMLCommonSetupEvent`、`FMLClientSetupEvent`、`GatherComponentsEvent` 等）必须显式指定 `bus = Bus.MOD` 或 `...getBus(modBusGroup).addListener(...)`，不能依赖默认 `BOTH`；
- `NeoForge.EVENT_BUS.register(this)`、`FMLEnvironment.getDist()`、`SidedThreadGroups` 等 modbase 写法要逐项替换（Forge 的 `FMLEnvironment.dist` 是字段，不是 `getDist()`）。

### 3.4 事件集差异

对两个 26.3 事件包按“简单类名”比较：

| 指标 | 数量 |
| --- | --- |
| NeoForge 事件类 | 150 |
| Forge 事件类 | 119 |
| 同名（可直接重命名/改包） | 93 |
| 仅 NeoForge 有 | 57 |
| 仅 Forge 有 | 26 |

典型差异：

| NeoForge 26.3 | Forge 26.3 | 类型 |
| --- | --- | --- |
| `BreakBlockEvent` | `BlockEvent.BreakEvent` | 嵌套前缀变化 |
| `CropGrowEvent.Pre` | `BlockEvent.CropGrowEvent.Pre` | 嵌套前缀变化 |
| `PlayerTickEvent.Post` | `TickEvent.PlayerTickEvent.Post` | 顶层 → 嵌套 |
| `LevelTickEvent.Post` | `TickEvent.LevelTickEvent.Post` | 顶层 → 嵌套 |
| `ServerTickEvent.Post` | `TickEvent.ServerTickEvent.Post` | 顶层 → 嵌套 |
| `LivingIncomingDamageEvent` | `LivingHurtEvent`（或 `LivingDamageEvent`） | 语义近似，需要对齐 |
| `LivingShieldBlockEvent` | `ShieldBlockEvent` | 重命名 + 访问器 |
| `ItemEntityPickupEvent.Pre` | `EntityItemPickupEvent` | 重命名 + 语义 |
| `CanPlayerSleepEvent` | `PlayerSleepInBedEvent` | 语义不同 |
| `BlockGrowFeatureEvent` | `BlockFeatureGrowEvent` | 重命名 |
| `UseItemOnBlockEvent` | 无直接等价，使用 `PlayerInteractEvent.RightClickBlock` | 需要适配 |
| `EntityTickEvent.Pre` | 无通用非生物 tick 事件，仅有 `LivingEvent.LivingTickEvent` | 需要 Mixin 或降级 |

### 3.5 网络

Forge 26.3 有两套可用路径：

1. **新 payload 通道**：`ChannelBuilder.named(...)` → `PayloadChannel`，基于原版 `CustomPacketPayload` + `StreamCodec`；
2. **SimpleChannel**：`ChannelBuilder.named(...).simpleChannel().play().clientbound().addMain(Packet.class, CODEC, handler)`，发送用 `CHANNEL.send(packet, PacketDistributor.PLAYER.with(player))`。

NeoForge 26.3 生成器使用：

- `CustomPacketPayload` / `StreamCodec`；
- `RegisterPayloadHandlersEvent` + `PayloadRegistrar`；
- `PacketDistributor.sendToPlayer(...)` / `sendToServer(...)`；
- `IPayloadContext`。

两者不能直接替换。建议在 modbase 中新增一个 `ModNetwork` 帮助类，把“注册、发送到玩家、发送到服务器、发送到维度/全体”集中封装，生成代码只调用帮助类。这样可以把 13 个网络相关模板和 7 个变量模板的改动收敛到 1 个基础设施文件 + 少量调用点。

（`caches/reference/MinecraftForge-26.3/.../src/main/java/net/minecraftforge/network/ChannelBuilder.java`、`PacketDistributor.java`、`forge-tests/.../PacketTest.java`）

### 3.6 Capability 与资源处理器

Forge 26.3 仍然使用经典 Capability：

- `ForgeCapabilities.ITEM_HANDLER` / `FLUID_HANDLER` / `ENERGY`；
- `AttachCapabilitiesEvent.BlockEntities` / `ItemStacks` / `Entities`；
- `ICapabilityProvider`、`CapabilityManager`、`IItemHandler`、`IFluidHandler`、`IEnergyStorage`。

NeoForge 26.3 已切换到：

- `RegisterCapabilitiesEvent` + `Capabilities.Item.BLOCK` / `Capabilities.Fluid.BLOCK` / `Capabilities.Energy.BLOCK`；
- `ResourceHandler<ItemResource>` / `ResourceHandler<FluidResource>`；
- `SimpleEnergyHandler`、`FluidStacksResourceHandler`、`WorldlyContainerWrapper`、`BucketResourceHandler`。

生成器中有：

- 23 个流程模板使用 `ResourceHandler` / `ItemResource` / `FluidResource`；
- 39 处 `ResourceHandler` 命中；
- 30 个文件涉及 `Capabilities` / `RegisterCapabilitiesEvent`；
- `templates/block/blockentity.java.ftl` 生成 `SimpleEnergyHandler`、`FluidStacksResourceHandler`。

这是 Phase 1/2 的最大单项改造：需要把 NeoForge 的 transfer 语义映射到 Forge 的 `IItemHandler` / `IFluidHandler` / `IEnergyStorage`，并为方块实体和物品生成 `AttachCapabilitiesEvent` 注册代码。

### 3.7 玩家变量与数据附件

NeoForge 用 `AttachmentType` + `getData/setData` 保存玩家变量；Forge 26.3 没有同名机制。可用路径：

- 持久变量：Forge 的 `IForgeEntity.getPersistentData()`（`CompoundTag`），随实体保存；
- 生命周期变量：服务端 `Map<UUID, PlayerVariables>` + `PlayerEvent.Clone` / respawn 处理；
- 更规范但更重的方案：`AttachCapabilitiesEvent<Entity>` + 自定义 Capability + `INBTSerializable`。

生成器中有 9 个文件、40 处 `getData/setData/AttachmentType`，主要集中在 `variableslist.java.ftl` 和变量类型 YAML。建议 Phase 0 先做玩家变量 spike，决定用“persistent data + runtime map”还是“player capability”，再定模板。

### 3.8 客户端注册

| NeoForge 26.3 | Forge 26.3 | 影响 |
| --- | --- | --- |
| `RegisterMenuScreensEvent` | `MenuScreens.register(...)`（在 `FMLClientSetupEvent` 中） | GUI 屏幕注册模板重写 |
| `IMenuTypeExtension.create(...)` | `IForgeMenuType.create(...)` | 菜单注册模板重写 |
| `RegisterGuiLayersEvent` | `RegisterGuiOverlaysEvent` / `AddGuiOverlayLayersEvent` | overlay 模板重写 |
| `RegisterKeyMappingsEvent` | 同名 | 低风险 |
| `RegisterParticleProvidersEvent` | 同名 | 低风险 |
| `RegisterClientExtensionsEvent`（护甲/物品渲染扩展） | `IClientItemExtensions`，通常通过 `Item#getRenderPropertiesInternal` 返回 | 护甲自定义模型需要重写 |
| `RegisterRangeSelectItemModelPropertyEvent` / `RegisterConditionalItemModelPropertyEvent` | 未发现直接等价事件 | 物品自定义模型属性可能成为限制项 |

（Forge 源码 `client/event/` 与 `client/extensions/common/IClientItemExtensions.java`）

### 3.9 数据包资源差异

| NeoForge 资源 | Forge 26.3 | 处理 |
| --- | --- | --- |
| `data/<modid>/neoforge/biome_modifier/*.json` | `data/<modid>/forge/biome_modifier/*.json` | 4 个定义文件、JSON 模板改命名空间与 type |
| `data/neoforge/data_maps/block/flammable.json` | 无 data map 等价物 | 改为在方块类覆写 `getFlammability` / `getFireSpreadSpeed`，或标记限制 |
| `data/neoforge/data_maps/block/transformables.json` | 未发现等价 API | 通过 `PlayerInteractEvent.RightClickBlock` 模拟，或标记限制 |
| `META-INF/enumextensions.json`（袭击者类型扩展） | Forge 有 `IExtensibleEnum`，但没有 NeoForge 的 JSON 加载入口 | 自定义袭击者类型可能无法加入袭击；标记限制或研究 Mixin/ASM |
| `neoforge:...` 标签/条件 | `forge:...` / 原版 | 约 19 处，需要逐项核对 |

（Forge 源码 `common/ForgeHooks.java`、`common/extensions/IForgeBlock.java`、`common/IExtensibleEnum.java`）

### 3.10 Mixin 与 Access Transformer

- Forge 26.3 支持 Mixin，但通过 JAR manifest 的 `MixinConfigs` 属性加载（`fmlloader/.../JarInJarDependencyLocator.java` 可证），不是 NeoForge 的 `[[mixins]] config = ...`；
- Forge 的 AT 文件是 `META-INF/accesstransformer.cfg`，由 ForgeGradle 处理；NeoForge 生成器已有 `templates/modbase/accesstransformer.cfg.ftl`，模板内容可复用；
- NeoForge 的 `mixin.fragment.yaml` / `neoforge.mods.toml` 的 `[[mixins]]` 不能照搬；需要改为构建脚本/manifest 注入；
- 建议所有 `@Inject` 使用 `require = 0`，并在 Mixin 中检查 `level() != null`、`!level().isClientSide`、`connection != null` 等生命周期守卫（与交付规范一致）。

### 3.11 `mods.toml`

Forge 26.3 的元数据文件是 `META-INF/mods.toml`：

- `modLoader="javafml"`；
- `loaderVersion="[66,)"`；
- `[[mods]]`、`[[dependencies.<modid>]]` 中 `modId="forge"`，版本范围 `[66,)`；
- `minecraft` 依赖范围 `[26.3,26.4,)`（官方 MDK 写法）；
- 没有 NeoForge 的 `[[mixins]]` 段；
- `displayTest`、`clientSideOnly`、`logoFile` 等字段继续可用，但取值需要按 Forge 26.3 校验。

（`reference_resources/forge-26.3-66.1.5-mdk/src/main/resources/META-INF/mods.toml`）

### 3.12 Minecraft 26.3 的原版变化

这些变化同时影响 NeoForge/Fabric/Forge，不是 Forge 特有，但会改变模板：

- `ResourceLocation` → `Identifier`（`net.minecraft.resources.Identifier`）；
- 方块/物品 properties 需要 `setId`；
- `ValueInput` / `ValueOutput` / `ValueIOSerializable` 取代部分 NBT 序列化；
- `ToolMaterial` / `ArmorMaterial` 为原版类型，工具/护甲模板与 1.21.x 不同；
- 事件 record 的访问器随组件名变化：既可能是 `server()` / `level()`，也可能是 `getEntity()`；必须按 Forge 26.3 的实际签名逐一确认，不能按旧版 getter 习惯批量替换；
- `DataComponents`、`BlocksAttacks`、`EquipmentAssets` 等 26.3 新增/调整类型需要按原版签名编译验证。

---

## 4. 差异矩阵与工作量分布

### 4.1 加载器耦合文件统计

对 `reference_resources/generator-26.3.x/neoforge-26.3/` 做宽口径扫描（包含少量误报）：

| 区域 | 文件数 | 说明 |
| --- | --- | --- |
| `templates/` | 51 | 注册初始化、方块/物品/实体/流体/GUI/客户端、modbase |
| `procedures/` | 30 | 物品/流体/能量/库存 handler、实体属性、药水 |
| `variables/` | 7 | 变量序列化与作用域 |
| `triggers/` | 4 | 世界加载/卸载、左右键空手（客户端事件） |
| `workspacebase/` | 2 | `build.gradle`、`settings.gradle` |
| 定义/映射/全局 | 9 | `generator.yaml`、`block/feature/plant/livingentity` 定义、`common.enumextensions/flammables/transformables`、`mappings/attributes.yaml` |
| **合计** | **103** | 实际需要人工判断的文件约 100 个 |

### 4.2 重点子系统

| 子系统 | 耦合文件 | 难度 | 主要工作 |
| --- | --- | --- | --- |
| 注册与 modbase | 17 + 2 | 中 | `DeferredRegister`/`RegistryObject`、`setId`、`BusGroup`、mod 构造器 |
| 事件总线/触发器 | 65 触发器 + 115 注解文件 | 中 | 注解改包、`Bus.MOD`、事件重命名/嵌套前缀 |
| 网络 | 13 + 7 变量 | 高 | `SimpleChannel`/`ChannelBuilder`、发送封装、变量同步 |
| Capability/transfer | 23 + 30 | 高 | `ResourceHandler` → `IItemHandler`/`IFluidHandler`/`IEnergyStorage` |
| 玩家变量/附件 | 7 | 高 | `AttachmentType` → persistent data 或 capability |
| 客户端 GUI/护甲/overlay | 10 | 中高 | `MenuScreens`、`IClientItemExtensions`、overlay 事件 |
| 世界生成/生物群系 | 8 | 中高 | biome modifier 命名空间、Mixin/AT |
| 数据资源 | 5 | 中 | `neoforge:` → `forge:`、data map 替代 |
| 构建/元数据 | 4 | 中 | ForgeGradle 7、`mods.toml`、Mixin manifest |

### 4.3 为什么不是“改包名”

- 注册对象的泛型与工厂完全不同（`DeferredHolder` vs `RegistryObject`）；
- 事件不是简单重命名：顶层/嵌套结构、record 访问器、语义都变了；
- 网络、Capability、玩家变量是三个独立子系统；
- 26.3 原版本身有 `Identifier`、`setId`、`ValueIO` 等变化。

因此，任何“全局字符串替换”方案都会在中段大量返工；必须按子系统逐块迁移并用编译驱动修正。

---

## 5. 架构方案对比

### 方案 A：完整分叉（推荐）

把 `neoforge-26.3` 的全部资源复制到 `forge-26.3`，删除 NeoForge 专用文件，逐项改写加载器层；`generator.yaml` 只保留：

```yaml
import:
  - datapack-26.3.x
```

优点：

1. **纯净度可审计**：对 `forge-26.3` 做禁用词扫描即可，不依赖“本地覆盖 + 上游继承”的优先级推理；
2. **无运行时依赖**：即使用户移除/更新官方 NeoForge 生成器，本生成器仍可工作；
3. **可删除 NeoForge 专用资产**（`enumextensions`、data maps、`[[mixins]]` 等），而不是让它们“继承但不用”；
4. **与 Fabric 官方生成器的差异可控**：Fabric 选择 thin override，是因为它要跟进官方生成器；本项目目标是独立、纯净的 Forge 生成器，目标不同。

方案 A 唯一保留的 import 是官方 `datapack-26.3.x`。它是加载器无关的数据包生成器，不会引入 NeoForge 代码；如果后续要求“连 datapack 也不依赖”，可以在 Phase 4 把它的 239 个文件一并分叉，但首期不建议增加这项维护成本。

代价：

- 仓库约 950 个文件、约 10 MB；首轮复制成本低；
- 上游 MCreator 更新时需要手工 diff，但这是独立生成器的正常维护成本。

### 方案 B：import NeoForge + 覆盖

```yaml
import:
  - datapack-26.3.x
  - neoforge-26.3:
    exclude:
      - procedures
      - triggers
```

优点：仓库小，理论上更容易跟进上游。

缺点：

1. 纯净度审计必须检查“本地 + 继承”的最终有效文件集，容易漏；
2. 安装时依赖官方 NeoForge 生成器存在；
3. 上游模板变化会静默进入本生成器；
4. 与“完全纯净、全新”的交付语义冲突。

### 方案 C：只 import 定义，模板全自建

把 NeoForge 只当定义来源，所有模板/流程/触发器重写。工作量最大，且会重复造大量与加载器无关的轮子，不推荐。

### 结论

**采用方案 A。** 在 Phase 0 先复制一份只读基线到 `caches/reference/` 便于 diff，正式源码放 `plugin-branch-2026.3/src/main/resources/forge-26.3/`。

建议的仓库布局：

```text
plugin-branch-2026.3/
  build.gradle
  gradle.properties
  settings.gradle
  gradlew / gradlew.bat / gradle/wrapper/
  LICENSE
  CHANGELOG.md
  README.md
  docs/PROJECT-ASSESSMENT.md
  docs/SUPPORT-MATRIX.md
  src/main/resources/plugin.json
  src/main/resources/forge-26.3/
    generator.yaml
    *.definition.yaml
    templates/
    procedures/
    triggers/
    variables/
    mappings/
    aitasks/
    cmdargs/
    utils/
    workspacebase/
  src/validator/java/...        # 复用 Forge 1.12.2 的校验器
  tools/lib/*.jar
```

生成器元数据建议：

```yaml
name: Forge for @minecraft (@buildfileversion)
status: dev
buildfileversion: 66.1.5

import:
  - datapack-26.3.x
```

```json
{
  "id": "generator-forge-26.3",
  "weight": 100,
  "supportedversions": [202600344621, 2026003],
  "info": {
    "name": "Forge 26.3 Generator",
    "version": "2026.3-1.0.0.1-beta",
    "description": "Minecraft Forge 26.3 generator for MCreator 2026.3.",
    "author": "LitQA"
  }
}
```

目录名必须是 `forge-26.3`：MCreator 用 `generatorName.split("-")[0].toUpperCase()` 判定 `GeneratorFlavor.FORGE`，否则不会按 Forge 工作区处理（例如不会删除 `neoforge.mods.toml`、不会识别 Forge 平台）。

---

## 6. 阶段计划与批次划分

> 交付规范要求：每个批次代码写完后，本地编译 0 错误即停止，等待用户真机测试；不得连续开发后续批次。以下批次按此约束设计。

| 阶段 | 批次 | 内容 | 验收门槛 | 估算 |
| --- | --- | --- | --- | --- |
| Phase 0 | B0 | 本评估、仓库骨架、版本/CHANGELOG、构建链 spike | 评估确认；Gradle 能配置 Forge 项目 | 1–2 天 |
| Phase 1A | B1 | modbase、注册基类、创造标签、物品、基础方块、配方/战利品表/标签 | 最小工作区 `gradlew build` 成功；客户端进入 | 2–3 天 |
| Phase 1A | B2 | 植物、工具、护甲、物品扩展、方块实体/库存/能量/流体的基础 | 静态元素样例编译通过 | 3–4 天 |
| Phase 1B | B3 | 生物实体、弹射物、特殊实体、流体、粒子、药水/效果 | 实体/流体样例客户端可见 | 4–5 天 |
| Phase 1B | B4 | GUI/菜单/屏幕、按键、overlay、命令、村民职业/交易 | GUI 可打开、按键可触发 | 3–4 天 |
| Phase 1C | B5 | 生物群系、维度、特征、结构、属性、游戏规则、旗帜/画/盔甲纹饰 | 世界生成样例可进入 | 4–5 天 |
| Phase 2 | B6 | 流程基础块、事件参数、返回值、命令参数、AI 任务 | 流程样例编译 + 运行 | 3–4 天 |
| Phase 2 | B7 | 方块/物品/实体/世界/数学/逻辑/文本流程 | 50+ 流程样例编译 | 3–4 天 |
| Phase 2 | B8 | 库存/能量/流体/网络/变量等高级流程 | 能力样例运行 | 3–4 天 |
| Phase 3 | B9 | Easy 触发器（约 57 个） | 批量生成 + 事件触发日志 | 3–4 天 |
| Phase 3 | B10 | Hard 触发器（8 个）+ Mixin/AT 基础设施 | 每个 Hard 触发器真机验证 | 3–4 天 |
| Phase 4 | B11 | 全量矩阵、纯净度扫描、文档、打包 | `generator-forge-26.3.zip` 可安装 | 2–3 天 |
| Phase 4 | B12 | 修复真机问题、CHANGELOG 收尾 | 验收底线全部满足 | 2–3 天 |

**总量估算：约 36–49 人日。** 这是按“每个子系统都要编译 + 真机验证”的保守估计；如果 Forge 26.3 的 API 适配比预期顺利，可压缩到 25–30 人日左右；如果网络/Capability/变量三个子系统返工，可能超过 55 人日。

批次设计原则：

- 每个批次都包含“生成器资源 + 校验器规则 + 一个最小测试工作区”；
- 每个批次结束只提交编译通过的代码，不把半成品留给下一批；
- Hard 触发器单独成批，避免和静态元素混在一起导致定位困难；
- Phase 4 之前不宣称“完成”，因为真机测试可能暴露静默失效。

---

## 7. 触发器盘点（65 个）

判定说明：

- **Easy**：Forge 有对应事件，主要是改包/改嵌套前缀/改访问器；
- **Hard**：事件存在但语义或生命周期不同，或需要客户端守卫/Mixin/适配器；
- **Impossible**：事件层面不可实现；当前盘点为 0。

| # | 触发器 | NeoForge 事件 | Forge 26.3 映射 | 判定 |
| --- | --- | --- | --- | --- |
| 1 | `block_break` | `BreakBlockEvent` | `BlockEvent.BreakEvent` | Easy |
| 2 | `block_multiplace` | `BlockEvent.EntityMultiPlaceEvent` | `BlockEvent.EntityMultiPlaceEvent` | Easy |
| 3 | `block_place` | `BlockEvent.EntityPlaceEvent` | `BlockEvent.EntityPlaceEvent` | Easy |
| 4 | `bonemeal_used` | `BonemealEvent` | `BonemealEvent` | Easy |
| 5 | `bucket_filled` | `PlayerInteractEvent.RightClickItem` | `FillBucketEvent` | Hard |
| 6 | `chat_sent` | `ServerChatEvent` | `ServerChatEvent` | Easy |
| 7 | `command_executed` | `CommandEvent` | `CommandEvent` | Easy |
| 8 | `crop_attempts_growth` | `CropGrowEvent.Pre` | `BlockEvent.CropGrowEvent.Pre` | Easy |
| 9 | `entity_attacked` | `LivingIncomingDamageEvent` | `LivingHurtEvent` | Hard |
| 10 | `entity_blocks` | `LivingShieldBlockEvent` | `ShieldBlockEvent` | Hard |
| 11 | `entity_change_equipment` | `LivingEquipmentChangeEvent` | `LivingEquipmentChangeEvent` | Easy |
| 12 | `entity_dies` | `LivingDeathEvent` | `LivingDeathEvent` | Easy |
| 13 | `entity_dropxp` | `LivingExperienceDropEvent` | `LivingExperienceDropEvent` | Easy |
| 14 | `entity_falls` | `LivingFallEvent` | `LivingFallEvent` | Easy |
| 15 | `entity_grief` | `EntityMobGriefingEvent` | `EntityMobGriefingEvent` | Easy |
| 16 | `entity_healed` | `LivingHealEvent` | `LivingHealEvent` | Easy |
| 17 | `entity_item_pickup` | `ItemEntityPickupEvent.Pre` | `EntityItemPickupEvent` | Hard |
| 18 | `entity_joins_world` | `EntityJoinLevelEvent` | `EntityJoinLevelEvent` | Easy |
| 19 | `entity_jumps` | `LivingEvent.LivingJumpEvent` | `LivingEvent.LivingJumpEvent` | Easy |
| 20 | `entity_pickupxp` | `PlayerXpEvent.PickupXp` | `PlayerXpEvent.PickupXp` | Easy |
| 21 | `entity_pre_hurt` | `LivingDamageEvent.Pre` | `LivingDamageEvent` | Hard |
| 22 | `entity_sets_attack_target` | `LivingChangeTargetEvent` | `LivingChangeTargetEvent` | Easy |
| 23 | `entity_spawns` | `EntityJoinLevelEvent` | `EntityJoinLevelEvent` | Easy |
| 24 | `entity_struck_by_lightning` | `EntityStruckByLightningEvent` | `EntityStruckByLightningEvent` | Easy |
| 25 | `entity_switch_hand` | `LivingSwapItemsEvent.Hands` | `LivingSwapItemsEvent.Hands` | Easy |
| 26 | `entity_tamed` | `AnimalTameEvent` | `AnimalTameEvent` | Easy |
| 27 | `entity_ticks` | `EntityTickEvent.Pre` | `LivingEvent.LivingTickEvent`（仅生物）或 Mixin `Entity.tick` | Hard |
| 28 | `entity_travels_to_dimension` | `EntityTravelToDimensionEvent` | `EntityTravelToDimensionEvent` | Easy |
| 29 | `entity_uses_totem` | `LivingUseTotemEvent` | `LivingUseTotemEvent` | Easy |
| 30 | `explosion_occurs` | `ExplosionEvent.Detonate` | `ExplosionEvent.Detonate` | Easy |
| 31 | `farmland_trampled` | `BlockEvent.FarmlandTrampleEvent` | `BlockEvent.FarmlandTrampleEvent` | Easy |
| 32 | `gem_dropped` | `ItemTossEvent` | `ItemTossEvent` | Easy |
| 33 | `gem_expired` | `ItemExpireEvent` | `ItemExpireEvent` | Easy |
| 34 | `item_crafted` | `PlayerEvent.ItemCraftedEvent` | `PlayerEvent.ItemCraftedEvent` | Easy |
| 35 | `item_destroyed` | `PlayerDestroyItemEvent` | `PlayerDestroyItemEvent` | Easy |
| 36 | `item_smelted` | `PlayerEvent.ItemSmeltedEvent` | `PlayerEvent.ItemSmeltedEvent` | Easy |
| 37 | `minecraft_world_loaded` | `LevelEvent.Load` | `LevelEvent.Load` | Easy |
| 38 | `minecraft_world_unloaded` | `LevelEvent.Unload` | `LevelEvent.Unload` | Easy |
| 39 | `mod_clientload` | `FMLClientSetupEvent` | `FMLClientSetupEvent`（bus = MOD） | Easy |
| 40 | `mod_load` | `FMLCommonSetupEvent` | `FMLCommonSetupEvent`（bus = MOD） | Easy |
| 41 | `mod_serverload` | `FMLDedicatedServerSetupEvent` | `FMLDedicatedServerSetupEvent`（bus = MOD） | Easy |
| 42 | `player_completes_advancement` | `AdvancementEvent.AdvancementEarnEvent` | `AdvancementEvent.AdvancementEarnEvent` | Easy |
| 43 | `player_critical_hit` | `CriticalHitEvent` | `CriticalHitEvent` | Easy |
| 44 | `player_fishes_item` | `ItemFishedEvent` | `ItemFishedEvent` | Easy |
| 45 | `player_in_bed` | `CanPlayerSleepEvent` | `PlayerSleepInBedEvent` | Hard |
| 46 | `player_left_click_air` | `PlayerInteractEvent.LeftClickEmpty` | `PlayerInteractEvent.LeftClickEmpty`（客户端） | Easy |
| 47 | `player_left_click_block` | `PlayerInteractEvent.LeftClickBlock` | `PlayerInteractEvent.LeftClickBlock` | Easy |
| 48 | `player_log_in` | `PlayerEvent.PlayerLoggedInEvent` | `PlayerEvent.PlayerLoggedInEvent` | Easy |
| 49 | `player_log_out` | `PlayerEvent.PlayerLoggedOutEvent` | `PlayerEvent.PlayerLoggedOutEvent` | Easy |
| 50 | `player_respawn` | `PlayerEvent.PlayerRespawnEvent` | `PlayerEvent.PlayerRespawnEvent` | Easy |
| 51 | `player_right_click_block` | `PlayerInteractEvent.RightClickBlock` | `PlayerInteractEvent.RightClickBlock` | Easy |
| 52 | `player_right_click_empty_hand` | `PlayerInteractEvent.RightClickEmpty` | `PlayerInteractEvent.RightClickEmpty`（客户端） | Easy |
| 53 | `player_right_click_entity` | `PlayerInteractEvent.EntityInteract` | `PlayerInteractEvent.EntityInteract` | Easy |
| 54 | `player_right_click_item` | `PlayerInteractEvent.RightClickItem` | `PlayerInteractEvent.RightClickItem` | Easy |
| 55 | `player_ticks` | `PlayerTickEvent.Post` | `TickEvent.PlayerTickEvent.Post` | Easy |
| 56 | `player_use_hoe` | `UseItemOnBlockEvent` | `PlayerInteractEvent.RightClickBlock` + 锄头判断 | Hard |
| 57 | `player_useitem_finish` | `LivingEntityUseItemEvent.Finish` | `LivingEntityUseItemEvent.Finish` | Easy |
| 58 | `player_useitem_start` | `LivingEntityUseItemEvent.Start` | `LivingEntityUseItemEvent.Start` | Easy |
| 59 | `player_useitem_stop` | `LivingEntityUseItemEvent.Stop` | `LivingEntityUseItemEvent.Stop` | Easy |
| 60 | `player_wakes_up` | `PlayerWakeUpEvent` | `PlayerWakeUpEvent` | Easy |
| 61 | `player_xp_change` | `PlayerXpEvent.XpChange` | `PlayerXpEvent.XpChange` | Easy |
| 62 | `player_xp_level_change` | `PlayerXpEvent.LevelChange` | `PlayerXpEvent.LevelChange` | Easy |
| 63 | `sapling_glow` | `BlockGrowFeatureEvent` | `BlockFeatureGrowEvent` | Easy |
| 64 | `village_siege` | `VillageSiegeEvent` | `VillageSiegeEvent` | Easy |
| 65 | `world_ticks` | `LevelTickEvent.Post` | `TickEvent.LevelTickEvent.Post` | Easy |

### 7.1 Hard 触发器说明

1. **`bucket_filled`**：NeoForge 生成器用 `RightClickItem` + `Items.BUCKET` 判断；Forge 有更精确的 `FillBucketEvent`，但访问器和取消语义不同，必须重写依赖映射。
2. **`entity_attacked`**：NeoForge `LivingIncomingDamageEvent` 是伤害前置事件；Forge 的 `LivingHurtEvent` / `LivingDamageEvent` 分别位于不同阶段，需要确认“攻击瞬间”的语义并选定一个。
3. **`entity_blocks`**：`LivingShieldBlockEvent` → `ShieldBlockEvent`，格挡伤害、盾牌物品、取消语义的访问器不同。
4. **`entity_item_pickup`**：`ItemEntityPickupEvent.Pre` → `EntityItemPickupEvent`，原版物品实体与玩家拾取的上下文不同，需要重新映射 `entity` / `itemstack`。
5. **`entity_pre_hurt`**：`LivingDamageEvent.Pre` → Forge `LivingDamageEvent`（非嵌套 Pre），伤害值/取消语义需要对齐。
6. **`entity_ticks`**：Forge 没有通用 `EntityTickEvent`；对生物可用 `LivingEvent.LivingTickEvent`，对非生物需要 Mixin `Entity.tick`。若 Phase 3 不启用 Mixin，此项降级为 Impossible。
7. **`player_in_bed`**：`CanPlayerSleepEvent` → `PlayerSleepInBedEvent`；前者是“能否入睡”判定，后者是“右键床”事件，触发时机不同，需要明确产品语义。
8. **`player_use_hoe`**：`UseItemOnBlockEvent` 在 Forge 没有直接等价；需要用 `PlayerInteractEvent.RightClickBlock` + `ToolActions.HOE_DIG`/物品类型判断，并与 NeoForge 的 `ITEM_AFTER_BLOCK` 阶段对齐。

### 7.2 Impossible 盘点

- 事件层面：**0 个**。Forge 26.3 对 65 个触发器都至少提供了一个可行路径（含 Mixin）。
- 条件性 Impossible：
  - 若不允许 Mixin：`entity_ticks` 对非生物实体不可实现；
  - 若 Forge 26.3 客户端不提供对应 hook：`player_left_click_air` / `player_right_click_empty_hand` 只能退化为服务端近似，存在“静默失效”风险（这两个在 Forge 中实际有 `PlayerInteractEvent.*Empty`，因此判定为 Easy，但仍需客户端 `Dist` 守卫）。
- 非触发器但可能 Impossible 的特性：NeoForge `enumextensions`（自定义袭击者类型）、`data_maps`（flammable/transformables）、物品自定义模型属性事件。建议在 Phase 1C 单独评估，必要时列入 Known Limitations。

---

## 8. 静态元素与流程盘点

### 8.1 元素类型与全局资源（37 个定义 + 全局文件）

> 37 是 `*.definition.yaml` 的数量。下表额外列出 `blockentity` 这类派生能力和 3 个全局模板，便于评估，不重复计入 37。

| 分组 | 元素 | 风险 | 备注 |
| --- | --- | --- | --- |
| 数据包/共享 | `achievement`、`damagetype`、`enchantment`、`function`、`loottable`、`recipe`、`structure`、`villagertrade`、`armortrim`、`bannerpattern`、`painting` | 低 | 主要走 datapack 生成器；Forge/Fabric/NeoForge 共用 JSON |
| 核心方物品 | `block`、`plant`、`item`、`tool`、`armor`、`itemextension`、`tab` | 中 | 注册、setId、属性、客户端模型 |
| 实体 | `livingentity`、`projectile`、`specialentity` | 中高 | EntityType 注册、属性、渲染器、刷怪蛋 |
| 世界 | `biome`、`dimension`、`feature`、`structure` | 高 | biome modifier 命名空间、Mixin/AT、维度传送 |
| 流体/能量 | `fluid`、`blockentity`（由 block 派生） | 高 | `FluidType`、Capability、资源处理器 |
| UI/客户端 | `gui`、`keybind`、`overlay`、`particle`、`potioneffect` | 中 | `MenuScreens`、overlay 事件、`IClientItemExtensions` |
| 游戏内容 | `potion`、`attribute`、`gamerule`、`villagerprofession`、`command` | 中低 | 注册与映射 |
| 代码/流程 | `code`、`procedure` | 中 | 直接生成 Java；流程 API 与加载器耦合较少 |
| NeoForge 专属/高风险 | `enumextensions`（全局文件）、`common.flammables`、`common.transformables` | 高 | Forge 无直接等价；需替代或限制 |

### 8.2 流程模板（567 个）

- 与加载器无关：约 537 个，主要是原版 API、数学、逻辑、文本、世界、方块、实体、物品操作；
- 加载器耦合：约 30 个，集中在：
  - 库存/槽位：`itemhandler_*`、`entity_*_slot`、`block_inventory/*`；
  - 能量：`block_energy_*`、`energy/*`；
  - 流体：`block_fluidtank_*`、`fluidtank/*`、`block_fluid_to_bucket`；
  - 药水/弹射物：`item_get_potion`、`projectiles_potion`；
  - 实体属性：`entity_submerged_height`、`entity_get_slot`；
  - 命令参数：`get_command_parameter_item`；
  - 网络/变量：`variableslist.java.ftl`、`SavedDataSyncMessage`、`PlayerVariablesSyncMessage`。
- 结论：Phase 2 不需要重写全部 567 个流程；应“全量复制 + 只改 30 个耦合文件 + 编译驱动修复”。

### 8.3 其他资源

- `aitasks/`：37 个，绝大多数是原版 AI 行为，加载器耦合低；
- `cmdargs/`：14 个，主要是 Brigadier 参数类型，加载器耦合低；
- `mappings/`：23 个，`attributes.yaml` 有 `NeoForgeMod.SWIM_SPEED` 需要改；
- `workspacebase/`：10 个文件，需按 ForgeGradle 重写 `build.gradle`、`settings.gradle`、`gradle.properties`、wrapper；
- `utils/`：6 个，`triggers.java.ftl`、`procedures.java.ftl` 等基础工具需要适配事件/网络。

---

## 9. 风险登记

| # | 风险 | 概率 | 影响 | 证据/触发条件 | 缓解措施 |
| --- | --- | --- | --- | --- | --- |
| R1 | Forge 26.3 API 与 NeoForge 差异导致大量编译错误 | 高 | 高 | 事件/网络/Capability 已确认不同 | 以 Forge 26.3 源码为准；每个子系统先做最小样例编译 |
| R2 | 网络层重写导致变量同步/ GUI 状态同步静默失效 | 高 | 高 | `PacketDistributor`、`SimpleChannel` 语义不同 | 集中 `ModNetwork`；先做“登录同步 + 客户端回包”spike |
| R3 | Capability/transfer 重写导致库存/能量/流体行为错误 | 高 | 高 | 23 个流程、`SimpleEnergyHandler`/`FluidStacksResourceHandler` | Phase 1A 先做 `IItemHandler`/`IFluidHandler`/`IEnergyStorage` 最小样例 |
| R4 | 玩家变量持久化/死亡克隆行为与 NeoForge 不一致 | 中高 | 高 | `AttachmentType` 无等价物 | 先做 persistent data vs capability 对比 spike；写清生命周期测试 |
| R5 | `setId` 跨模板遗漏导致方块/物品注册崩溃 | 中高 | 高 | MDK 明确要求 `setId` | 在 init helper 统一注入；用“无 setId 即失败”的生成器校验规则 |
| R6 | 事件总线 bus 选择错误（MOD/FORGE/BOTH）导致监听器不触发 | 中 | 中高 | `@Mod.EventBusSubscriber` 默认 BOTH | 建立模板分类表；mod 生命周期事件必须 `Bus.MOD`；运行时日志验证 |
| R7 | Mixin/AT 打包方式不同导致客户端崩溃 | 中 | 高 | Forge 用 `MixinConfigs` manifest，不是 `[[mixins]]` | Phase 0 建立 Mixin/AT 最小样例；`require = 0` + 生命周期守卫 |
| R8 | Forge 26.3 无 NeoForge data map/enum extension 等价物 | 中 | 中 | `common.flammables`、`common.transformables`、`enumextensions` | 逐项决定“替代实现”或“Known Limitation”；不静默生成空实现 |
| R9 | 客户端注册 API 变化（MenuScreens/overlay/护甲）导致 GUI/模型不显示 | 中 | 中高 | Forge `MenuScreens.register`、`IClientItemExtensions` | 先做 GUI/护甲最小样例；客户端 `Dist` 守卫 |
| R10 | 本机 Gradle/ForgeGradle 工具链不可用 | 高 | 高 | JBR `Files.isWritable=false`；AT `ReadOnlyFileSystemException` | 使用打过补丁的 Gradle 9.8；在 DSH 外或标准 JDK 25 下构建；Phase 0 必须先解决 |
| R11 | 纯净度审计遗漏（import 自动解析掩盖残留） | 中 | 中高 | 模板中未显式写 `net.neoforged` | 禁用词扫描 + Forge-only 类路径编译 + 生成代码 grep |
| R12 | 许可证/归属（MCreator 模板 GPL 例外 vs CC BY-NC） | 低中 | 中 | 模板含 GPL 头 | 保留 MCreator 版权头；在 README/NOTICE 说明；必要时法务确认 |

### 9.1 最高优先级的三个 spike

1. **构建链 spike**：ForgeGradle 7 + Gradle 9.8 + Java 25 + Forge 66.1.5，生成一个最小 Forge 模组并 `build` 成功。当前本机 AT 处理失败，必须先解决或确认在用户环境可复现。
2. **注册/事件 spike**：一个方块 + 一个物品 + 一个创造标签 + 一个 `player_right_click_block` 触发器，验证 `setId`、`RegistryObject`、`@Mod.EventBusSubscriber`、`Bus.MOD`。
3. **网络/变量 spike**：一个 `SimpleChannel` 消息从服务端发到客户端，验证 `PlayerVariablesSyncMessage` 的替代路径；这是后续 GUI/变量的基础。

---

## 10. 验收与测试计划

### 10.1 静态验收

- 生成器资源结构完整：`plugin.json`、`forge-26.3/generator.yaml`、全部定义/模板/流程/触发器。
- 生成器校验器通过：
  - YAML 可解析；
  - FreeMarker 模板可编译；
  - 生成文件名/路径无冲突；
  - 禁用词扫描：`forge-26.3` 下不允许出现 `net.neoforged`、`NeoForge`、`DeferredHolder`、`DeferredBlock`、`DeferredItem`、`ResourceHandler`、`AttachmentType`、`RegisterCapabilitiesEvent`、`RegisterPayloadHandlersEvent`、`neoforge:`（白名单/文档除外）。
- 版本单源：`gradle.properties`、`plugin.json`、`CHANGELOG.md`、提交信息一致。

### 10.2 构建验收

- 生成器插件自身：`gradlew build` → `BUILD SUCCESSFUL`；
- 生成的最小测试工作区：`gradlew build` → `BUILD SUCCESSFUL`，`javac` 0 错误；
- 生成的全量测试工作区：至少覆盖每个 Phase 的代表元素；
- 离线/本地缓存：`GRADLE_USER_HOME` 指向 `<项目根>/caches/gradle`，wrapper 指向本地 `gradle-9.8.0-bin.zip`。

### 10.3 运行时验收

- 客户端正常启动，无闪退；
- 方块/物品/实体/流体/GUI 素材正常显示，无紫黑方块；
- 至少一个自定义维度/生物群系可进入；
- 触发器真机冒烟测试（每个类别至少 1 个）：
  - `block_break`：破坏方块输出日志；
  - `player_right_click_block`：右键方块输出日志；
  - `entity_dies`：击杀生物输出日志；
  - `player_ticks`：玩家 tick 计数；
  - `mod_load`：加载阶段日志；
  - `player_in_bed`：入睡触发；
  - `entity_ticks`：非生物/生物 tick 触发（Mixin 验证）；
  - `player_use_hoe`：锄头使用触发。
- 无静默失效：每个测试触发器必须产生可观察效果，不能只生成空方法。

### 10.4 纯净度验收

- 生成的工作区源码中 `grep -R "net.neoforged\|NeoForge"` 为 0；
- 生成的工作区只依赖 `net.minecraftforge` + `net.minecraft`；
- 用 Forge-only 类路径编译通过（不能依赖 NeoForge 类“碰巧存在”）。

### 10.5 回归/兼容

- 从 NeoForge 工作区切换到 Forge 工作区时，`WorkspaceGeneratorSetup` 会删除 `neoforge.mods.toml`；本项目必须提供正确的 `mods.toml`，且不残留 `neoforge.mods.toml`；
- 生成器名称/目录必须是 `forge-26.3`，否则 MCreator 不会按 `GeneratorFlavor.FORGE` 处理。

---

## 11. 环境、缓存与构建约束

### 11.1 缓存布局（按交付规范）

```text
<项目根>/
  caches/
    gradle/                 # GRADLE_USER_HOME
    gradle-dist/            # 本地 Gradle 发行包/解压
    loom/                   # 如后续需要（Forge 不使用 Loom）
    reference/              # Forge/NeoForge 源码基线
    spike/                  # Phase 0 构建试验
  plugin-branch-2026.3/
  test_workspaces/
```

所有 Gradle 调用必须注入：

```powershell
$env:GRADLE_USER_HOME = "<项目根>\caches\gradle"
```

生成工作区的 `gradle-wrapper.properties` 使用：

```properties
distributionUrl=file\:///B:/QA/Documents/App/Mods/DSH/Forge_Generator_26.3/reference_resources/gradle-9.8.0-bin.zip
```

### 11.2 本机实际阻塞（必须记录）

评估过程中复现了两个环境问题：

1. **JBR 25 的 `Files.isWritable` 恒为 false**  
   `MCreatorEAP2026344621/jdk` 下运行 `Files.isWritable` 对任意目录返回 false，标准 Gradle 9.8 因此报：
   `Configuring project with invalid directory ... does not exist, can't be written to or is not a directory`。  
   `../Forge_Config_API_Port/caches/gradle-patched-9.8.0/` 中存在可用的补丁发行版；用它执行最小 `hello` 任务成功。  
   **处置**：开发验证使用补丁 Gradle；生成器交付仍按规范指向本地 `gradle-9.8.0-bin.zip`。如果 MCreator 自带 Gradle 同步在用户环境也使用 JBR，需要确认 MCreator 是否已内置同类补丁。

2. **ForgeGradle 的 AT 处理失败**  
   使用补丁 Gradle 解析 Forge 66.1.5 时，MCMaven 的 `modifyAccess` 任务报：
   `java.nio.file.ReadOnlyFileSystemException`，日志指向 `modifyAccess.jar`。  
   这不是生成器代码错误，而是本机工具链/文件系统行为；需要：
   - 在 DSH 外（普通 PowerShell）或标准 JDK 25 下复现；
   - 或预先处理 Forge userdev 缓存；
   - 或使用 ForgeGradle 7 的离线缓存/已处理 artifacts。  
   **Phase 0 必须把这个阻塞当作 gate：构建链不通过，不进入 Phase 1。**

### 11.3 版本与 Git

- 首轮版本：`2026.3-1.0.0.1-beta`；
- 每轮补丁号 +1、构建序号 +1，构建序号持久化；
- `CHANGELOG.md` 放在 `plugin-branch-2026.3/` 根目录，英文、事实陈述、按模块划分；
- 每轮结束只 `commit`，不 `push`；
- 提交信息简要说明本轮变更。

### 11.4 许可证

- 项目 LICENSE 为 CC BY-NC 4.0；
- 复制/修改 MCreator 模板时保留其 GPL 头与特别例外说明；
- 建议在 `README.md` / `NOTICE` 中说明来源与修改关系；
- 若要将整个生成器作为 CC BY-NC 作品分发，需确认与 MCreator 模板许可证的兼容性（评估项，不阻塞开发）。

---

## 12. 待确认决策

在进入 Phase 0 前，需要确认以下事项：

1. **架构**：是否确认采用“完整分叉”，而不是 import `neoforge-26.3` 的薄覆盖方案？（推荐完整分叉。）
2. **Phase 0 范围**：是否同意先做“构建链 + modbase + 方块/物品/创造标签 + `player_right_click_block`”最小闭环，再进入全量静态元素？
3. **限制项**：`enumextensions`（袭击者类型）、NeoForge data maps（flammable/transformables）、物品自定义模型属性这三项，是否接受“Forge 原生替代或 Known Limitations”，还是要求完全等价？
4. **测试环境**：`gradlew build` 是否允许在 DSH 外/标准 JDK 25 下执行？本机 JBR + ForgeGradle 的 AT 问题需要真实环境确认。
5. **配置元素**：是否要把 `Forge_Config_API_Port` 的 `config` 元素纳入本生成器，还是保持与官方 NeoForge 26.3 生成器一致（不含 config 元素）？

---

## 13. 已确认决策

以下决策已在本轮评估结束后确认，作为 Phase 0 的输入：

| 决策项 | 选择 |
| --- | --- |
| 架构 | 完整分叉（full fork），只 import `datapack-26.3.x` |
| Phase 0 范围 | 最小闭环：构建链 + modbase + 方块/物品/创造标签 + `player_right_click_block` |
| NeoForge 专属特性 | 优先 Forge 原生替代；无法等价时列入 Known Limitations |
| 构建验证环境 | 允许在 DSH 外或标准 JDK 25 下执行 `gradlew build` |

Phase 0 的版本号从 `2026.3-1.0.1.2-beta` 开始（补丁号 +1、构建序号 +1）。

---

## 附录 A：关键证据路径

| 结论 | 证据 |
| --- | --- |
| ForgeGradle 7 / Java 25 / Forge 66.1.5 | `reference_resources/forge-26.3-66.1.5-mdk/build.gradle` |
| `setId` 要求 | `reference_resources/forge-26.3-66.1.5-mdk/src/main/java/com/example/examplemod/ExampleMod.java` |
| `@Mod.EventBusSubscriber` / `BusGroup` | `caches/reference/MinecraftForge-26.3/.../javafmllanguage/src/main/java/net/minecraftforge/fml/common/Mod.java` |
| 新版 `@SubscribeEvent` 包 | `caches/reference/MinecraftForge-26.3/.../src/main/java/net/minecraftforge/eventbus/api/listener/SubscribeEvent.java`（以实际路径为准） |
| Forge 事件 record 结构 | `caches/reference/MinecraftForge-26.3/.../src/main/java/net/minecraftforge/event/TickEvent.java`、`.../entity/player/PlayerEvent.java` |
| Forge 网络 | `caches/reference/MinecraftForge-26.3/.../src/main/java/net/minecraftforge/network/ChannelBuilder.java`、`.../forge-tests/src/main/java/net/minecraftforge/debug/network/PacketTest.java` |
| Forge Capability | `caches/reference/MinecraftForge-26.3/.../src/main/java/net/minecraftforge/common/capabilities/ForgeCapabilities.java`、`.../event/AttachCapabilitiesEvent.java` |
| Forge Mixin `MixinConfigs` | `caches/reference/MinecraftForge-26.3/.../fmlloader/src/main/java/net/minecraftforge/fml/loading/moddiscovery/JarInJarDependencyLocator.java` |
| NeoForge 生成器规模 | `reference_resources/generator-26.3.x/neoforge-26.3/` |
| Fabric 转换先例 | `reference_resources/Fabric-Generator-MCreator-26.3-2026.3-2.9-beta/src/main/resources/fabric-26.3/generator.yaml` |
| 插件/校验器脚手架 | `../Forge_Generator_1.12.2/plugin-branch-2026.3/build.gradle`、`src/validator/` |
| 补丁 Gradle | `../Forge_Config_API_Port/caches/gradle-patched-9.8.0/` |

## 附录 B：建议的 Phase 0 成功标准

Phase 0 不是“写完全部生成器”，而是用最小闭环证明：

1. 生成器插件能被 MCreator 识别为 Forge 26.3；
2. 生成的工作区 `gradlew build` 成功；
3. 客户端可启动；
4. 自定义方块/物品/创造标签可见；
5. `player_right_click_block` 触发器能在游戏中实际执行；
6. 生成代码中没有 `net.neoforged`；
7. 构建缓存全部落在 `<项目根>/caches`。

只有 1–7 全部满足，才进入 Phase 1A。
