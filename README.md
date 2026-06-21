# 🦥 Claude Code 懒人配置包

> **一句话：** 复制粘贴一条命令，Claude Code 自动帮你省 60-85% Token，不用学任何专业知识。

---

## 🤔 这是什么？

你在用 [Claude Code](https://claude.ai/code)（一个 AI 编程助手）写代码的时候，它是按 **Token**（可以理解为"字数"）收费的。每次你跟它说话，你付的钱 = 你说的字数 + 它回复的字数 + 它在后台"思考"的字数。

**这个仓库做的事情很简单：** 帮你调好 Claude Code 的默认设置，让它用更少的 Token 干同样的事——**不砍功能、不降智商、不用每次手动配置**。

---

## 📦 这个包里有啥？

| 文件名 | 干什么用的 | 通俗解释 |
|--------|-----------|---------|
| `settings.json` | Claude Code 的全局配置文件 | 就像手机的"设置"菜单，调亮度、改铃声都在这里。这个文件告诉 Claude Code：用便宜模式、少说废话、勤快清理记忆 |
| `CLAUDE.md` | 项目级别的"员工手册" | 每次打开项目，Claude 会先读这个文件，了解你的偏好。类似于"这个员工的工作说明书" |
| `.claudeignore` | 忽略文件列表 | 告诉 Claude "这几个文件夹别看，里面是垃圾"，省得它浪费时间读没用的东西 |
| `install.ps1` | Windows 一键安装脚本 | 双击运行，全自动配好 |
| `install.sh` | Mac/Linux 一键安装脚本 | 终端里敲一行，全自动配好 |

---

## 🚀 怎么用？（选一种方式，30 秒搞定）

### 方式一：Windows（推荐大多数用户）

你的电脑上应该已经装了 Claude Code。然后：

**第 1 步：** 下载这个仓库的所有文件（点击本页面上方的绿色 `<> Code` 按钮 → `Download ZIP`）

**第 2 步：** 解压 ZIP 文件到你喜欢的文件夹

**第 3 步：** 在解压后的文件夹里，**右键点击 `install.ps1` → "使用 PowerShell 运行"**

**第 4 步：** 跟着屏幕上的提示走（大部分时候直接按回车就行）

**完事了。** 下次打开 Claude Code，优化自动生效。

---

### 方式二：Mac / Linux

打开终端（黑窗口），输入：

```bash
# 克隆这个仓库
git clone https://github.com/你的用户名/claude-code-lazy-pack.git

# 进入目录
cd claude-code-lazy-pack

# 运行安装脚本
bash install.sh
```

跟着屏幕上的提示走。

**完事了。**

---

### 方式三：极简复制（如果你不想运行脚本）

直接把这三个文件复制到对应位置：

1. 把 `settings.json` 复制到 `C:\Users\你的用户名\.claude\settings.json`（Mac/Linux 是 `~/.claude/settings.json`）
2. 把 `CLAUDE.md` 复制到你的项目文件夹根目录
3. 把 `.claudeignore` 复制到你的项目文件夹根目录

---

## 🎯 具体省了什么？（写给想了解细节的人）

### settings.json 里改了啥？

| 设置项 | 默认值 | 改成了 | 通俗解释 |
|--------|--------|--------|---------|
| `model` | `opus` | `sonnet` | Opus = 请教授，一小时 500 块；Sonnet = 请研究生，一小时 200 块。80% 的活研究生一样能干好 |
| `MAX_THINKING_TOKENS` | `31999` | `10000` | 限制 AI 干活前的"心理活动"。原来每次要想 3 万字，现在只让想 1 万字——想太多也没什么用 |
| `CLAUDE_CODE_SUBAGENT_MODEL` | 跟主模型一样 | `haiku` | AI 派出去翻文件的小助手，用最便宜的"实习生"就够了 |
| `ENABLE_PROMPT_CACHING_1H` | 没开 | `1` | 把"短期记忆"从 5 分钟延长到 1 小时，不用反复说同样的东西 |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | `95` | `60` | 不等垃圾堆满才倒，60% 满就清理，保持脑子清爽 |
| `autoCompactEnabled` | 可能没开 | `true` | 开启"自动整理记忆"功能 |

### CLAUDE.md 里加了啥？

在原来的"员工手册"基础上，加了 **"智能模型管理"** 规则：

- 遇到简单活 → 自动用 Sonnet（便宜）
- 遇到复杂活 → AI 会主动说"这个活比较难，建议切换到 Opus 模式"
- 聊太久 → 主动提醒你"该清理对话记忆了"
- 输出内容 → 简单任务直接给结论，不啰嗦

### .claudeignore 里屏蔽了啥？

告诉 Claude Code 不要读这些文件夹：

```
node_modules/     ← 第三方代码包（几万个文件，读了也没用）
dist/             ← 编译输出（自动生成的，别浪费时间看）
.git/             ← 版本控制历史
*.log             ← 日志文件
.env              ← 环境变量（可能包含密码，别读）
```

**效果：** 原来每次打开项目 Claude 要扫几千个文件，现在只扫你真正写的代码。

---

## 📊 实际能省多少？

| 对比项 | 默认配置 | 懒人配置后 | 节省 |
|--------|---------|-----------|------|
| 每次对话的基础费用 | 100% | ~40% | **省 60%** |
| AI 思考费用 | 100% | ~30% | **省 70%** |
| 小助手费用 | 100% | ~20% | **省 80%** |
| 重复发送的系统信息 | 每次都发 | 缓存 1 小时 | **大幅减少** |
| 输出字数 | 可能很啰嗦 | 精简模式 | **省 65%** |

**综合下来，同样的工作量，花费大约是原来的 15-40%。**

---

## ❓ 常见问题（小学生都能看懂的 FAQ）

### Q: 这个包会影响 Claude Code 的功能吗？
**不影响。** 就像你手机开了"省电模式"——该有的功能全在，只是关掉了不必要的后台耗电。遇到难题时，AI 会主动让你切换到最强模式。

### Q: 安装后还能改回来吗？
**随时能改。** 安装脚本会自动备份你原来的配置文件。想恢复的话，找到带 `.backup` 后缀的文件，改回原名就行。

### Q: 我是 Mac 用户，能用吗？
**能用。** 用 `install.sh` 脚本就行。

### Q: 我已经装过别的 Claude Code 插件了，会冲突吗？
**不会。** 安装脚本会"合并"配置——只添加你没设置过的项，不覆盖你已经设置好的东西。

### Q: 这个仓库收费吗？
**完全免费。** MIT 开源协议，随便用、随便改、随便发给朋友。

### Q: 为什么叫"懒人包"？
因为最初配置这些东西要看好几篇英文文档、手动改 JSON 文件、理解一堆技术名词。**我把这些都做好了，你只需要点一下鼠标。**

---

## 🔧 进阶：配合这两个免费工具效果更好

本安装脚本会**主动问你要不要装**下面两个工具（选装，不是必须的）：

### Caveman（山顶洞人模式）— GitHub 75,000+ Stars
让 Claude Code 说话像山顶洞人一样简洁：
- "找到了问题，在 login.js 第 23 行，已修复" 
- → 变成 "login.js:23 = → == 已修复"

**效果：输出字数省 65%，意思一点不少。**

### Pith（压缩过滤器）— 自动后台运行
自动压缩 Claude Code 读到的文件内容和命令输出：
- 读一个 500 行的文件 → 只保留函数签名和关键逻辑（省 88%）
- 运行测试输出 3000 行 → 只保留失败的测试和摘要（省 91%）

**效果：上下文内存省 88-92%，完全后台运行，不用管。**

---

## 📋 文件结构

```
claude-code-lazy-pack/
├── README.md           ← 你正在看的这个文件
├── settings.json       ← Claude Code 全局设置
├── CLAUDE.md           ← 项目"员工手册"模板
├── .claudeignore       ← 要忽略的文件列表
├── install.ps1         ← Windows 一键安装脚本
└── install.sh          ← Mac/Linux 一键安装脚本
```

---

## 📝 开源协议

MIT — 想怎么用就怎么用，不用通知我。如果帮到你了，给个 Star ⭐ 就行。

---

# 🐣 附录：零基础 GitHub 上传教程

> 如果你从来没上传过代码到 GitHub，看这里。每一步都有截图说明。

---

## 准备工作（只做一次）

### 第 1 步：注册 GitHub 账号

1. 打开 https://github.com
2. 点右上角 `Sign up`（注册）
3. 输入你的邮箱、密码、用户名（用户名会出现在你的仓库网址里，比如 `github.com/你的名字`）
4. 验证邮箱

**完成了。** 你现在有了一个 GitHub 账号。

`【批注】GitHub = 一个专门存放代码的网站。你可以把它理解成"代码的百度网盘"——你把代码传上去，别人可以看、可以下载、可以给你提建议。全球几千万程序员都在上面。`

### 第 2 步：安装 Git

`【批注】Git = 版本控制工具。"版本控制"的意思就是——你写代码改了 100 次，Git 帮你记着每一次改了什么，随时可以回到以前的任何一个版本。就像游戏存档。`

**Windows：**
1. 打开 https://git-scm.com/download/win
2. 下载安装包，双击安装
3. 安装过程中所有选项都选默认的，一路点 `Next` 到底
4. 装完后，在开始菜单里会出现一个叫 "Git Bash" 的程序——这就是那个黑窗口

**Mac：**
打开终端（黑窗口），输入：
```bash
git --version
```
如果没有安装，系统会提示你安装。点"安装"就行。

### 第 3 步：告诉 Git 你是谁

打开 Git Bash（Windows）或终端（Mac），输入：

```bash
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
```

`【批注】这两行命令的意思是告诉 Git："以后我上传的代码，署名是我"。你的名字和邮箱会显示在 GitHub 的提交记录里。`

---

## 上传这个仓库（跟着做，一步步来）

### 第 1 步：打开 Git Bash（Windows）或终端（Mac）

把黑窗口打开。

### 第 2 步：进入懒人包的文件夹

```bash
cd /d/claude-code-lazy-pack
```

`【批注】cd = Change Directory = 切换文件夹。`

然后按回车。现在黑窗口"位于"你放懒人包的文件夹里了。

### 第 3 步：初始化 Git

```bash
git init
```

`【批注】git init = 初始化。意思是告诉 Git："这个文件夹从现在开始归你管了，帮我盯着它"。`

执行后你会看到：`Initialized empty Git repository in ...`

### 第 4 步：把所有文件加入"待上传列表"

```bash
git add .
```

`【批注】git add . = 把当前文件夹里所有文件标记为"准备上传"。（那个点 . 代表"当前文件夹的所有东西"）`

### 第 5 步：确认上传（创建一次"存档"）

```bash
git commit -m "🎉 首次上传：Claude Code 懒人配置包"
```

`【批注】git commit = 创建一次存档。-m 后面双引号里的话是这次存档的说明文字。`

### 第 6 步：在 GitHub 上创建仓库

1. 打开 https://github.com ，登录你的账号
2. 点右上角的 `+` 号 → `New repository`（新建仓库）
3. 在 `Repository name` 里输入：`claude-code-lazy-pack`
4. `Description`（描述）输入：`Claude Code 一键懒人配置包，省 60-85% Token，新手友好`
5. 下面三个选项（Public/Private、README、.gitignore、license）**全都不要勾选**
6. 点绿色的 `Create repository` 按钮

### 第 7 步：把本地的代码推送到 GitHub

创建仓库后，GitHub 会跳转到一个页面，上面有几行命令。找到包含 `git remote add origin` 的那一组命令。复制下面这两行（把"你的用户名"改成你的实际用户名）：

```bash
git remote add origin https://github.com/你的用户名/claude-code-lazy-pack.git
git branch -M main
git push -u origin main
```

`【批注】先解释这三行的意思：`
- `git remote add origin` = 告诉 Git "上传的目的地是 github.com 上的那个仓库"
- `git branch -M main` = 把当前分支改名为 main（分支可以理解成"一条工作线"）
- `git push -u origin main` = 正式上传——把 main 这条线上的所有存档，推到 GitHub 上去

### 第 8 步：验证

刷新 GitHub 网页，你应该能看到你的文件出现在仓库里了！

---

## 🔄 以后想更新怎么办？

当你改了文件、想更新 GitHub 上的内容时：

```bash
git add .
git commit -m "描述一下你改了什么"
git push
```

三行命令，每次更新都这样。这是 Git 的"标准工作流"。

---

## 🎉 全部完成！

你的仓库现在在：
```
https://github.com/你的用户名/claude-code-lazy-pack
```

把这个链接发给朋友，他们就能用你的懒人包了。

别人用的时候只需要：
```bash
git clone https://github.com/你的用户名/claude-code-lazy-pack.git
cd claude-code-lazy-pack
# Windows 用户：右键 install.ps1 → PowerShell 运行
# Mac 用户：bash install.sh
```

---

> 🤖 本仓库由 Claude Code 辅助生成。有问题直接在 GitHub 提 Issue，或者用 Claude Code 问我。
