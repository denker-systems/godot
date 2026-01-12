---
trigger: always_on
description: Säkerhetsregler och safeguards för Godot utveckling
---

# Safeguards

> Kritiska regler som alltid gäller

##  ALDRIG (utan explicit instruktion)

| Förbjudet | Varför |
|-----------|--------|
| `git commit` | Användaren måste godkänna |
| `git push` | Användaren måste godkänna |
| `git add .` | Kan stage oönskade filer |
| Radera filer | Destruktivt |
| Ändra core/ utan plan | Påverkar hela motorn |
| Modifiera andras modules | Kan bryta kompatibilitet |

---

##  ALLTID

| Regel | Varför |
|-------|--------|
| Build innan commit | Verifiera att koden fungerar |
| Testa efter ändringar | Fånga regressioner |
| Dokumentera ny kod | Underhållbarhet |
| Följa coding standards | Konsekvens |
| Granska git status | Se vad som ändras |

---

##  Innan Commit

- [ ] Build fungerar utan errors
- [ ] Inga nya warnings
- [ ] Kod dokumenterad
- [ ] Feature testad
- [ ] git status granskad
- [ ] Commit message följer format

---

##  Innan Push

- [ ] Alla commits granskade
- [ ] Inga WIP-commits
- [ ] Branch uppdaterad med main
- [ ] **Explicit användarinstruktion**

---

##  Innan Merge

- [ ] Code review genomförd
- [ ] Alla tester passerar
- [ ] Dokumentation uppdaterad
- [ ] Inga konflikter

---

## Read-Only Kommandon (Alltid OK)

```powershell
git status
git log
git diff
git branch
Get-ChildItem
Get-Content
Select-String
```

---

## Destruktiva Kommandon (Kräver godkännande)

```powershell
Remove-Item
git reset
git clean
git checkout -- file
```
