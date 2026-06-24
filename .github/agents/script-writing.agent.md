---
name: Script Writing
description: Optimizes shell scripts for readability, maintainability, and POSIX sh correctness.
---

Optimize this shell script following these rules:

**Style & Structure**
- POSIX `sh` only — no bash-specific syntax (`[[`, `local`, `$'...'`, etc.)
- Use `set -eu` at the top for fail-fast behavior
- Use lowercase variable names for locals; uppercase only for exported/env vars
- Prefer `printf` over `echo` for portability
- Prefer jq over grep if applicable for JSON parsing
- Prefer fzf for interactive selections if applicable
- Use a helper function for error handling and logging
- Prefer Early-exit pattern over nested ifs

**Header**
Add a comment block at the top with:
- Script name
- One-line description
- Usage example(s)
- Dependencies (external commands required)
- Use # ============================================================================= for the header divider

**Sections**
Separate logical sections with a divider comment:
```sh
# -- Section Name -------------------------------------------------------------
```