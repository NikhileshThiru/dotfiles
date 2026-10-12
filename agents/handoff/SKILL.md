---
name: handoff
description: Write a handoff prompt for a fresh session and copy it to the clipboard
disable-model-invocation: true
argument-hint: "[what to focus on]"
---

Write a handoff prompt so a brand-new session can continue this work. The new session sees none
of this conversation, only the files on disk and the prompt you write. If arguments were given,
they say what the handoff should focus on.

The prompt must stand on its own and cover, in this order:

1. **Goal:** what we're working on and why, in two or three sentences. Name the project folder.
2. **Done:** what's finished and working.
3. **In progress:** what's half-done or broken, with file names.
4. **Decisions:** what we chose and why, plus approaches that failed, so they aren't retried.
5. **Next steps:** in order.
6. **Gotchas:** anything surprising, flaky, or easy to get wrong.
7. **Check first:** before changing anything, the new session runs `git status`, reads the
   files you named, and trusts the files over this prompt where they disagree.

Only state what you saw in this session or checked just now. Keep it under about 60 lines.

Then deliver it:

1. Save it to `~/.cache/handoff/<project folder name>.md`, creating the folder if needed. This is
   the backup.
2. If `$SSH_CONNECTION` is empty, copy that file to the clipboard: `pbcopy < FILE` on macOS,
   `wl-copy < FILE` on Linux. Reply with one line saying it's copied and where the backup is.
   Don't print the prompt.
3. If `$SSH_CONNECTION` is set, I'm on a remote machine and those tools can't reach my
   clipboard. Reply with the prompt and nothing else, so I can run `/copy` to copy it.
