# CLAUDE.md

## VCS
Always try `jj` first for version control operations. If `jj` fails, ask the user how to proceed.

`/path/to/repository-root/.wt/` is available as a prefix for jj workspaces or git worktrees.

### Workspace Boundaries
Always stay within the current jj workspace or git worktree directory. Do not navigate to parent directories or outside the project root unless explicitly asked.

## Search Tools
When you need `grep` or `find`,  use `rg` or `fd` instead.
