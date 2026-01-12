---
trigger: always_on
description: Git policy for Godot development
---

# Git Policy

> Version control standards

## Critical Rule

**Never auto-commit without explicit user instruction!**

### Forbidden (without permission)
- `git commit`
- `git push`
- `git add`

### Always Allowed (read-only)
- `git status`
- `git log`
- `git diff`
- `git branch`

---

## Branch Strategy

```
main                    # Stable, production-ready
 feature/XXX-desc   # New features
 bugfix/XXX-desc    # Bug fixes  
 module/XXX-name    # New module development
 experiment/XXX     # Research/prototypes
```

---

## Commit Format

```
type(scope): description

[body]

[footer]
```

### Types
| Type | Description |
|------|-------------|
| feat | New feature |
| fix | Bug fix |
| module | Module changes |
| docs | Documentation |
| refactor | Code restructure |
| perf | Performance |
| test | Tests |
| build | Build system |

### Scopes
| Scope | Area |
|-------|------|
| core | core/ |
| scene | scene/ |
| servers | servers/ |
| editor | editor/ |
| modules | modules/ |
| platform | platform/ |
| drivers | drivers/ |

---

## Documentation Sync

| Document | When Updated |
|----------|--------------|
| CHANGELOG.md | At release |
| modules_plan.md | Module progress |
| Session reports | During session |
