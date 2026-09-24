# Extended Mind

You have access to a shared knowledge vault — the "Extended Mind" — an Obsidian vault synced via iCloud. It contains projects, knowledge, ideas, session history, and active context from across all of Dennis's machines and Claude sessions.

## Vault Location

`~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Extended Mind 1.0/`

## Structure

```
memory/
  active.md              <- Current state of the world. Check this for context.
  sessions/              <- Older daily summaries (the nightly curator is retired)
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

**Keep notes current, not cumulative.** `memory/active.md` and the project notes describe the present state; they are not logs. When you update one, rewrite the section you are touching instead of appending another dated paragraph, remove items that are clearly finished, and keep history only where it earns its place (a short "History" list at the bottom of a project note, or the repo's own changelog). `memory/active.md` stays under about 150 lines: one short entry per project that says where it stands and what is next, then links out (`→ [[projects/x]]`). Nothing tidies these files afterwards. There is no nightly curator any more, so what you leave is what the next session reads. Tidying means moving, not deleting: when an item leaves `memory/active.md`, its outcome gets one dated line in the project note's History list, and decisions with their reasons are never dropped from a project note (compress them, keep the why).

**Finding the past.** When you need to know what happened or why: first the project note's History list, then the repo's changelog or decision log, then the raw transcripts in `memory/sessions/raw/<date>/` (one Markdown file per session, kept indefinitely; search them with grep by keyword or date). The transcripts are the unedited record, so prefer them over a summary when the two disagree.

**Don't worry about session logging** — conversations are captured automatically by a hook into `memory/sessions/raw/` and kept as the unedited record. Nothing summarises them, so anything durable has to be written as a proper note during the session.

**Don't write to `journal/`** — that's for Dennis's own reflections.

## Extended Mind is the primary knowledge store

When you learn facts, decisions, configs, how-tos, or anything about tools, systems, or projects — the Extended Mind vault is where it goes. ALWAYS. This is not optional.

Claude Code's built-in memory (`~/.claude/projects/.../memory/`) is fine for behavioral feedback about how Claude should work. But knowledge, references, and project context MUST go to the Extended Mind vault. If in doubt, write to the vault.

**The failure mode to watch for:** writing to Claude Code memory and calling it done. That's not done. The vault is the source of truth.
