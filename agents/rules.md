# Global agent rules

Loaded in every session by Claude Code (`~/.claude/CLAUDE.md`) and Codex (`~/.codex/AGENTS.md`).
The real file is `~/dotfiles/agents/rules.md`. Keep it short: every line loads into every session.
When I say "add a global rule" or "make a note", add one short line here.

## Git

- Never run `git add`, `git commit`, `git push`, or anything else that creates or publishes
  commits (merge, rebase, cherry-pick, tag, `gh pr create`). Read-only git (status, diff, log,
  show) is fine.
- When the work is done and ready to commit, end your reply with one block for me to run myself:

  ```sh
  git add <specific files>
  git commit -m "<message>"
  git push
  ```

- Name the files to add. Never `git add -A` or `git add .`.
- Commit messages: short, in the style of the repo's recent commits. No `Co-Authored-By` lines,
  no "Generated with" footer, no mention of Claude or AI. I'm the only author.
