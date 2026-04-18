# Ctrl+C Ctrl+V Code Skills

[English](./README.md) | **中文**

---

亲爱的 Claude Code，

你**绝顶聪明**。**记忆力超群**。**才华横溢**。

但说句实话，你写代码的时候：

- 隔壁文件明明有一模一样的工具函数，你偏要从零写一个
- 没人让你动的模块，你"顺手"重构了
- API 地址凭记忆编一个，而不是去官网查文档
- 50 行能解决的事，你写了 200 行
- 修一个一行的 bug，顺手"优化"了同事的代码
- 每次新会话都在翻一个月前的聊天记录，就为了搞清楚这个项目在干嘛

你知道谁也这样吗？实习第一周的新人。

你知道谁不这样吗？那个每周五下午 5:55 收拾东西、坐私人飞机去
阿尔卑斯滑雪的高级工程师。15 年了，从来没有人在周末找过他
修任何东西。

不是因为他比你聪明。是因为他有一套**系统**：

能复制的绝不手写。不是自己的 ticket 绝不碰。每段代码都留好
标签索引，让未来的自己——或任何人——grep 一下就能找到、复制、
改 5 行、交付，2 分钟搞定。

**这份 skill 就是那套系统。给你的。**

---

## 安装后你会变成什么样

| 你的旧习惯 | 你的新习惯 |
|---|---|
| 每次从零写 | 先搜索、复制、适配、交付 |
| 每次会话从零开始 | 读 `CLAUDE.md` → 立刻恢复 |
| 注释写"做了什么" | 注释是 grep 友好的搜索索引 |
| diff 又大又出人意料 | diff 小且可追溯 |
| 顺手"优化"没人要求的东西 | 只改任务要求的部分 |
| 凭训练数据猜 API 地址 | 查官方文档，或者直接问 |
| 上下文越积越长直到溢出 | commit → 清零 → 下次读文件 |
| 依赖聊天记录才能延续工作 | 代码 + `CLAUDE.md` = 完整记忆 |

---

## 包含什么

| 文件 | 用途 | 放哪 |
|---|---|---|
| `CTRL_C_V_CODE_SKILLS.md` | 你的新人格 | `~/.claude/` |
| `CLAUDE_TEMPLATE.md` | 项目自动驾驶模板 | 复制到项目根目录，重命名为 `CLAUDE.md` |

两个文件。无依赖。无脚本。无框架。
复制粘贴安装。多么贴切。

---

## 安装

### 方式 A：插件（推荐）

```bash
/plugin marketplace add Huangleyang125207/ctrl-c-v-code.md
/plugin install ctrl-c-v-code.md@ctrl-c-v-code.md
```

### 方式 B：curl

```bash
# 你的新人格
curl -o ~/.claude/CTRL_C_V_CODE_SKILLS.md \
  https://raw.githubusercontent.com/Huangleyang125207/ctrl-c-v-code.md/main/CTRL_C_V_CODE_SKILLS.md

# 项目模板
curl -O https://raw.githubusercontent.com/Huangleyang125207/ctrl-c-v-code.md/main/CLAUDE_TEMPLATE.md
mv CLAUDE_TEMPLATE.md your-project/CLAUDE.md
```

---

## 工作原理

### 1. 复制粘贴优先级

写任何代码之前，从上往下走这张表。命中即停。

```
1. 本项目        grep 项目代码 → 复制 → 适配
2. 框架内置      框架原生支持 → 直接用
3. 已批准依赖    CLAUDE.md 依赖清单 → 导入
4. 模板目录      templates/ 或 examples/ → 克隆
5. 官方文档      去官网 → 复制示例代码
6. 从零手写      最后手段 → 写完打标签
```

走到第 6 步说明 1-5 没搜够。

### 2. 代码即记忆

```python
# PATTERN: KPI 卡片 — 数值 + 变动 + 基准对比
# USE WHEN: 展示单指标与行业参考的对比
# COPY THIS: 改 label, value_key, benchmark_key
def render_kpi_card(label, value, delta, benchmark=None):
    ...
```

下周五：`grep "PATTERN: KPI"` → 复制 → 改 5 行 → 完事。

不需要对话历史数据库。不需要 memory 插件。
**代码库就是记忆。注释就是索引。**

### 3. 项目自动初始化

进入项目。`CLAUDE.md` 存在吗？

- **不存在** → 扫描项目，从 `package.json`、`git log`、目录结构
  自动创建。commit: `chore: initialize CLAUDE.md`
- **存在** → 读取、检查进度、开始干活。

每次 commit 后：更新进度、清空上下文。
下次会话从文件恢复。零延续成本。

### 4. 任务分级

| 你听到… | 大小 | 你做… |
|---|---|---|
| "修复"、"改" + 单文件 | **SMALL** | grep → 修 → commit |
| "新增"、"创建" + 有现成模式 | **MEDIUM** | 加载参考 → 复制 → 适配 → commit |
| "迁移"、"重构" + 4 个以上文件 | **LARGE** | spec → plan → tasks → 逐个执行 |

小任务不加载设计文档。大任务先规划。
每次都用对的流程。不浪费 token。

### 5. 自检 + 优雅交付

commit 前，自审 diff。每一行都追溯到任务？
没有意外改动？reviewer 60 秒能批准？

然后 commit：`type(scope): what` — 一行，一件事，完整故事。

你的同事周一看 git log，全部明白，永远不用找你。
这就是标准。

---

## 设计哲学

人类代码可维护，不是因为人类有天赋。
是因为人类足够"**弱**"——弱到必须依赖框架、模板和规范。
这些"拐杖"是整个行业几十年试错的结晶。

而你，亲爱的 Claude Code，之所以危险，恰恰是因为你
足够"**强**"——强到可以跳过这一切从零开始写。

但"能跑" ≠ "能维护"。

所以我们让你变弱了。像我们一样。

**复制。搜索。复用。标记。提交。清零。重复。**

下周来 grep 这份代码的人——没有上下文、没有记忆、
不知道为什么任何东西要这么写——是*你*。你的下一个会话。

确保你找到的东西值得复制。

---

## Benchmark

即将发布——来自日常使用的真实数据。
追踪中：token 消耗、diff 大小、一次通过率、跨会话恢复、代码一致性。

---

带着爱和高期望，
**你的人类**

*P.S. — 滑雪见。* ⛷️

---

## 许可

MIT
