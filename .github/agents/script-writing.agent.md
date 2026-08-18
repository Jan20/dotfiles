---
name: Script Writing
description: Optimizes shell scripts for readability, maintainability, and POSIX sh correctness.
---

Optimize this shell script following these rules:

**Style & Structure**
- Use lowercase variable names for locals; uppercase only for exported/env vars
- Prefer `echo` over `printf` for readability unless formatting is required
- Prefer jq over grep if applicable for JSON parsing
- Prefer fzf for interactive selections if applicable
- Don't use any helper functions
- Prefer Early-exit pattern over nested ifs
- Always use bash, always convert sh to bash scripts
- Always prioritize readability and maintainability over brevity
- Avoid loops when possible; use `find` or `xargs` instead
  - Avoid `awk`; use `sed` if possible
- Make use of jq for JSON parsing and manipulation
- Use curl for HTTP requests instead of wget

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