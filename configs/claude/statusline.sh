#!/bin/sh
# Claude Code status line: run whichever claude-dashboard version Claude has installed.
# settings.json points here instead of at a versioned plugin folder, so plugin updates
# never leave the status line on an old version (the Mini Pro sat on 1.1.0 that way).
dir=$(node -e '
const r = require(require("os").homedir() + "/.claude/plugins/installed_plugins.json");
const e = (r.plugins["claude-dashboard@claude-dashboard"] || [])[0];
if (e) process.stdout.write(e.installPath);
' 2>/dev/null)
[ -n "$dir" ] || { printf 'claude-dashboard not installed'; exit 0; }
exec node "$dir/dist/index.js"
