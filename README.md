# 冰岛 · Android 灵动岛

一个纯框架（无第三方依赖、无 AndroidX）实现的 Android「灵动岛」应用：消息、音乐、下载、充电、系统事件都能在状态栏下方弹出一条会呼吸的小岛。

- 包名：`com.sihua.app`
- 当前版本：**v1.9.10**（versionCode 59）
- 最低支持：Android 8.0（API 26），目标 API 33
- 安装包体积：约 165 KB
- 语言：Java（纯 Android Framework，无 Gradle 依赖）

> 本项目为个人作品，与 vivo / Android / Google 及任何手机厂商无关，也未获其背书。

---

## 功能

### 灵动岛本体
- 消息通知、音乐播放、下载进度、充电状态、系统事件统一从状态栏下方弹出。
- 胶囊 / 刘海两种形状，高度、收起长度、左右偏移、距顶部位置均可调。
- 弹出、展开、收起、消失各有独立动画；展开与消失时长可自行调节。
- 展开卡片显示图标、标题、正文、进度条或律动，**文字自动避开前置摄像头**。

### 音乐
- 封面多路兜底：媒体元数据位图 → 封面 URI → 通知大图 → 通知 Icon → 活跃通知扫描，尽量兼容各类播放器。
- 律动可视化：高分辨率、多颜色、封面取色可选。
- 真实音律三种来源（设置 → 音乐 → 音律来源）：
  1. **自动**：读系统输出混音，3 秒无数据自动回退麦克风；
  2. **仅麦克风**；
  3. **系统音（需录屏授权）**：`AudioPlaybackCapture` 官方内录。
- 收藏状态自动同步（元数据评分 / 通知收藏按钮），点❤️会真正发出收藏请求。
- 左右滑动切歌、向下拉或按钮隐藏岛；横屏隐藏后停止检测音乐，回竖屏自动恢复。

### 副岛（多岛）
- 音乐与消息可并行显示：主事件旁边分裂出小圆，左 / 右位置可选。
- 展开时副岛立即隐藏、位置不动；收起后原地淡回。
- 点副岛把副事件升为主事件，原主事件换到副岛。

### 常驻岛 / 圆形常驻岛
- 常驻模式：无事件时显示一条短胶囊。
- 圆形常驻岛：只显示一个圆，点一下展开成卡片，无操作自动缩回；可跟随缩小岛中心，也可单独调位置与直径。

### 快捷应用
- 可多选；选 1 个时单击常驻岛直接打开，选多个时展开成图标网格选择。
- 横屏网格最左侧带「隐藏」格子。

### 系统事件
充电 / 断电、解锁、耳机连接、充满电、低电量、静音 / 振动 / 铃声，逐项开关。

### 隐私与前台
- **锁屏不显示通知内容**，熄屏立即撤岛。
- 事件来源应用在前台时，按设置变成圆形常驻或隐藏；退出前台自动恢复。
- 横屏隐藏常驻岛。

---

## 下载

- 安装包：[releases/latest](https://github.com/Casuallw/bingdao/releases/latest)
- 直接下载：[bingdao-v1.9.10.apk](https://github.com/Casuallw/bingdao/releases/download/v1.9.10/bingdao-v1.9.10.apk) · [源码 zip](https://github.com/Casuallw/bingdao/releases/download/v1.9.10/bingdao-source.zip)

## 安装

1. 下载 [Releases](https://github.com/Casuallw/bingdao/releases/latest) 中的 `bingdao-v1.9.10.apk` 并安装（需允许“安装未知应用”）。
2. 打开「冰岛」，按首页提示授权：
   - 悬浮窗（必须）
   - 通知使用权（必须）
   - 无障碍服务（可选，让岛能盖住状态栏）
   - 忽略电池优化 / 自启动（建议）
3. 打开「开启灵动岛」，可用「测试弹出」预览。

---

## 从源码构建

不需要 Gradle / Android Studio，直接用 SDK 命令行工具：

```bash
# 依赖：aapt2、javac(8+)、d8、zipalign、apksigner、android.jar(API 34)
aapt2 compile --dir res -o out/res.zip
aapt2 link -o out/base.apk -I $ANDROID_JAR --manifest AndroidManifest.xml out/res.zip \
  -A assets --java out/gen --min-sdk-version 26 --target-sdk-version 33
find src out/gen -name "*.java" > out/sources.txt
javac -source 1.8 -target 1.8 -classpath $ANDROID_JAR -d out/classes @out/sources.txt
find out/classes -name "*.class" > out/classes.txt
d8 --release --min-api 26 --lib $ANDROID_JAR --output out/dex @out/classes.txt
# 再把 classes.dex 塞进 base.apk，zipalign 后 apksigner 签名
```

仓库内 `build.sh` 是完整的一键脚本（需自行生成签名 keystore）。

---

## 项目结构

```
src/com/sihua/app/
  IslandService.java     悬浮窗服务：生命周期、窗口动画、副岛、音乐、事件
  IslandView.java        灵动岛绘制与手势
  MainActivity.java      首页
  SettingsActivity.java  设置（形状、音乐、权限、快捷应用…）
  SysEventsActivity.java 系统事件开关
  NotificationListener.java 通知与媒体封面
  SihuaA11y.java         无障碍服务（前台应用、截图）
  Common.java / Ui.java / Perm.java  工具与界面基础
res/                     图标与资源
assets/                  赞助二维码等
```

---

## 许可

**非商业使用许可 1.0**：允许个人免费使用、学习、修改与免费原样分享；**禁止任何商业使用、禁止倒卖 / 转售 / 付费分发，禁止修改后收费分发，禁止移除版权与许可声明。** 完整条款见 [LICENSE](LICENSE)。

商业授权请联系作者。

---

## 免责声明

- 本软件按“现状”提供，不附带任何担保，使用风险自负。
- 请遵守所在地法律法规与各应用的服务条款；请勿用于侵犯他人隐私或权益的用途。
- 本项目与 vivo / Android / Google 及任何厂商无关。
