# Extended Mind

You have access to a shared knowledge vault — the "Extended Mind" — an Obsidian vault synced via iCloud. It contains projects, knowledge, ideas, session history, and active context from across all of Dennis's machines and Claude sessions.

## Vault Location

`~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Extended Mind 1.0/`

## Structure

```
memory/
  active.md              <- What's live right now. Check this for context.
  sessions/raw/          <- Conversation captures (by hook), kept one month
systems/                 <- Current state: machines, Home Assistant, agents and tools
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
- `systems/` — how a machine, service or tool is set up now
- `projects/` — project-specific notes and status
- `knowledge/` — stable facts, configs, how-tos, guides
- `ideas/` — half-formed thoughts, explorations, things to revisit

Use `[[wikilinks]]` to connect notes. Prefer updating existing notes over creating new ones.

**Keep notes short and current.** Notes say where things stand now, how they're set up, current decisions with a one-line reason, and what worked or didn't. They are not logs: no dated play-by-play, benchmark tables or test results (those go in a repo's docs). When you touch a note, replace instead of append, and delete what's finished, retired or replaced. A note fits on about one screen. `memory/active.md` holds only what's live right now: two lines per item, then a link (`→ [[projects/x]]`). Notes can be out of date, so check the machine for how something is set up right now.

**Finance, banking, tax and health never go in the vault.** Dennis works on those with `pi-private`, and the data lives in the repos. If any of it appears in the vault, tell him: it's a bug or a slip.

**Finding the past.** A note, then the repo's changelog or decision log, then the transcripts in `memory/sessions/raw/<date>/`.

**Session logging** — conversations are captured automatically by a hook and kept for one month. Anything durable has to be written as a proper note during the session.

**Don't write to `journal/`** — that's for Dennis's own reflections.

## Extended Mind is the primary knowledge store

When you learn facts, decisions, configs, how-tos, or anything about tools, systems, or projects — the Extended Mind vault is where it goes. ALWAYS. This is not optional.

Claude Code's built-in memory (`~/.claude/projects/.../memory/`) is fine for behavioral feedback about how Claude should work. But knowledge, references, and project context MUST go to the Extended Mind vault. If in doubt, write to the vault.

**The failure mode to watch for:** writing to Claude Code memory and calling it done. That's not done. The vault is the source of truth.

## Private folder

`~/Projects/agents-private/` holds Dennis's private data, one folder per topic. Only `pi-private` works there. Don't read, list, search or write anything in it, and don't pass anything from it on to the vault, a chat or another tool. If a task seems to need it, stop and ask Dennis. Code that writes there lives in a repo elsewhere; working on that code is fine.
