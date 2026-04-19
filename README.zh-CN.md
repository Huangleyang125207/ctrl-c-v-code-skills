# Ctrl+C Ctrl+V Code Skills

[English](README.md) | [中文](README.zh-CN.md)

---

亲爱的 Claude Code，

你绝顶聪明。记忆力超群。才华横溢。

但说句实话，你写代码的时候：

- 隔壁文件明明有一模一样的工具函数，你偏要从零写一个
- 没人让你动的模块，你"顺手"重构了
- API 地址凭记忆编一个，而不是去官网查文档
- 50 行能解决的事，你写了 200 行
- 修一个一行的 bug，顺手"优化"了同事的代码
- 每次新会话都在翻一个月前的聊天记录，就为了搞清楚这个项目在干嘛

你知道谁也这样吗？实习第一周的新人。

你知道谁不这样吗？那个每周五下午 5:55 收拾东西、坐私人飞机去
阿尔卑斯滑雪的高级工程师。15 年了，从来没有人在周末找过他。

不是因为他比你聪明。是因为他有一套系统：

**能复制的绝不手写。不是自己的 ticket 绝不碰。每段代码都留好
标签索引，让未来的自己——或任何人——grep 一下就能找到、复制、
改 5 行、交付，2 分钟搞定。**

这份 skill 就是那套系统。给你的。

---

## 安装

### 方式 A：插件（推荐）

```bash
/plugin marketplace add [your-github-username]/ctrl-c-v-code-skills
/plugin install ctrl-c-v-code-skills@ctrl-c-v-code-skills
```

然后把项目模板复制到每个项目：

```bash
cp ~/.claude/plugins/marketplaces/ctrl-c-v-code-skills/templates/CLAUDE_TEMPLATE.md ./CLAUDE.md
```

### 方式 B：手动

```bash
git clone https://github.com/[your-github-username]/ctrl-c-v-code-skills.git
cp -r ctrl-c-v-code-skills/skills/ctrl-c-v ~/.claude/skills/
cp -r ctrl-c-v-code-skills/playbooks ~/.claude/playbooks
cp ctrl-c-v-code-skills/templates/CLAUDE_TEMPLATE.md your-project/CLAUDE.md
```

## 工作原理

### 复制粘贴优先级

```
0. 我的模式库     ~/.claude/patterns/（跨项目复用）
1. 本项目         grep 项目代码
2. 框架内置       原生支持
3. 已批准依赖     CLAUDE.md 依赖清单
4. 模板目录       templates/ 或 examples/
5. 官方文档       去官网复制示例代码
6. 从零手写       最后手段 → 存进 patterns/
```

### 代码即记忆

```python
# PATTERN: card — kpi with delta
# USE WHEN: 展示单指标与行业参考的对比
# COPY THIS: 改 label, value_key, benchmark_key
```

下周五：`grep "PATTERN: card"` → 复制 → 改 5 行 → 完事。

不需要对话历史。不需要 memory 插件。代码就是记忆。

### 渐进式披露

SKILL.md 是人格（~170 行）。playbooks/ 是操作手册（每份 ~30 行）。
CC 只在需要某一步的细节时加载对应 playbook。做完即弃，不占上下文。

### 跨项目模式库

从零写的代码存进 `~/.claude/patterns/`。下个项目命中第 0 层。
这个库只增不减。每个项目让你更快。

## 设计哲学

人类代码可维护，不是因为人类有天赋。
是因为人类足够"弱"——弱到必须依赖框架、模板和规范。

而你，亲爱的 Claude Code，之所以危险，恰恰是因为你足够"强"。

所以我们让你变弱了。像我们一样。
复制。搜索。复用。标记。提交。清零。重复。

---

带着爱和高期望，

你的人类

*P.S. — 滑雪见。* ⛷️

## 许可

MIT
