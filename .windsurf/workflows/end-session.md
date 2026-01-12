---
description: Avsluta utvecklingssession för Godot Engine
---

# End Session Workflow

> Avsluta session med dokumentation

## 1. Git Status

// turbo
```powershell
Write-Host "=== SESSION END ===" -ForegroundColor Cyan
Write-Host "
Git Status:" -ForegroundColor Yellow
git status --short
```

---

## 2. Uncommitted Changes

// turbo
```powershell
$changes = git status --porcelain
if ($changes) {
    Write-Host "
Uncommitted changes:" -ForegroundColor Red
    Write-Host $changes
    Write-Host "
Consider committing or stashing before leaving!"
} else {
    Write-Host "
No uncommitted changes" -ForegroundColor Green
}
```

---

## 3. Session Summary

// turbo
```powershell
Write-Host "
=== SESSION COMMITS ===" -ForegroundColor Yellow
git log --oneline --since="8 hours ago" --format="%h %s"
```

---

## 4. Build Verification

// turbo
```powershell
Write-Host "
=== BUILD STATUS ===" -ForegroundColor Yellow
if (Test-Path "bin\godot.windows.editor.x86_64.exe") {
    $lastBuild = (Get-Item "bin\godot.windows.editor.x86_64.exe").LastWriteTime
    Write-Host "Last build: $lastBuild" -ForegroundColor Green
} else {
    Write-Host "No build found" -ForegroundColor Red
}
```

---

## 5. Handoff Notes

### Session Summary Template
```markdown
## Session YYYY-MM-DD

### Completed
- [ ] Task 1
- [ ] Task 2

### In Progress
- [ ] Task 3 - Status/blockers

### Next Steps
- Priority 1
- Priority 2

### Notes
- Important findings
- Decisions made
```

---

## 6. Cleanup

```powershell
# Stash uncommitted work (optional)
git stash push -m "WIP: session end"

# Or commit WIP
git add .
git commit -m "wip: session checkpoint"
```

---

## 7. Session End Checklista

- [ ] Alla viktiga ändringar committed
- [ ] Build fungerar
- [ ] Handoff notes skrivna
- [ ] Inga kritiska issues lämnade
