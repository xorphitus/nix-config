# CLAUDE.md

## CLI Tools Preference
### VCS
Always try `jj` first for version control operations. If `jj` fails, ask the user how to proceed.

`/path/to/repository-root/.wt/` is available as a prefix for jj workspaces or git worktrees.

### Search Tools
When `grep` or `find` is required,  use `rg` or `fd` instead.
