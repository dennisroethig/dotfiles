# Extended Mind

You have access to a shared knowledge vault — the "Extended Mind" — an Obsidian vault synced via iCloud. It contains projects, knowledge, ideas, session history, and active context from across all of Dennis's machines and Claude sessions.

## Vault Location

`~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Extended Mind 1.0/`

## Structure

```
memory/
  active.md              <- Current state of the world. Check this for context.
  sessions/              <- Daily session summaries (curated by nightly task)
    raw/                 <- Raw conversation captures (auto-captured by hook)
projects/                <- One note per project
knowledge/               <- Stable reference material (configs, tools, guides)
ideas/                   <- Half-baked thoughts, future explorations
journal/                 <- Dennis's personal reflections (don't write here)
```

## Important: File Access

The vault path contains spaces. **Never use Bash commands** (ls, cat, mkdir, etc.) to access vault files — always use the dedicated tools: Read, Write, Edit, Glob, Grep. These tools handle spaces correctly and have pre-approved permissions. Bash commands on this path will trigger unnecessary safety prompts.

## How to Use

**Reading:** When a task would benefit from prior context — past work, project status, ideas, or knowledge — check `memory/active.md` first, then look in the relevant section. Don't read the whole vault; just what's relevant.

**Writing:** When something worth capturing comes up during a session — a decision, an idea, a new piece of knowledge, a project update — write it to the appropriate section:
- `projects/` — project-specific notes and status
- `knowledge/` — stable facts, configs, how-tos, guides
- `ideas/` — half-formed thoughts, explorations, things to revisit

Use `[[wikilinks]]` to connect notes. Prefer updating existing notes over creating new ones.

**Don't worry about session logging** — conversations are automatically captured by a hook and curated nightly. Focus on writing things that have clear value as standalone notes.

**Don't write to `journal/`** — that's for Dennis's own reflections.
