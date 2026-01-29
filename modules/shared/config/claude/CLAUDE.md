# CLAUDE.md

## CLI Tools Preference
### VCS
Must use `jj` instead of `git` whenever `.jj` exists at a repository root. Otherwise, use `git`.

`/path/to/repository-root/.wt/` is available as a prefix for jj workspaces or git worktrees.

### Search Tools
When `grep` or `find` is required,  use `rg` or `fd` instead.
