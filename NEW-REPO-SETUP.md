# Denys-QBSF-Dashboard — Automated Setup

**Model:** one shared repo, collaborators with Write access, **auto-published by GitHub Pages** on every push to `main`. Adding a person and publishing a change are both "edit a file + commit" — the rest is handled by committed GitHub Actions workflows.

**Concrete values:**

| Item | Value |
|---|---|
| Owner | `DenysUkr` |
| Repo | `Denys-QBSF-Dashboard` |
| Visibility | Public |
| Live URL | `https://denysukr.github.io/Denys-QBSF-Dashboard/` |
| People | `marc@q-branch.dev`, `brandon@q-branch.dev`, `denys@q-branch.dev` (owner) |

---

## What's automated vs. manual

| Step | How |
|---|---|
| Publish on every push | ✅ Automatic — `.github/workflows/deploy.yml` (GitHub Pages) |
| Add a collaborator | ✅ Automatic — add username to `collaborators.yml`, commit → `.github/workflows/sync-collaborators.yml` invites them |
| Stand up a brand-new repo | ✅ One command — `scripts/bootstrap.ps1` |
| **Create the COLLAB_PAT secret** | ⚠️ One-time manual (a token must be made by a human) |
| **Collaborator accepts the invite** | ⚠️ Manual — GitHub won't force-add anyone |

That one-time token and the "accept" click are the only manual steps GitHub doesn't let us automate away.

---

## 0. The AI prompt (paste-in for collaborators)

The repo ships with **`CONTRIBUTOR_AGENT_BRIEF.md`** — the pastable prompt each collaborator gives their AI agent. They paste it, describe a change, and the agent returns a complete `index.html`. (Publish step in this model = "commit to `main`".)

---

## 1. One-time: enable collaborator auto-invites

The deploy workflow needs nothing. The collaborator-sync workflow needs a token:

1. Create a PAT: https://github.com/settings/tokens → **classic** token with the **`repo`** scope (or a fine-grained token with **Administration: read/write** on this repo).
2. Repo → **Settings → Secrets and variables → Actions → New repository secret**
   - Name: **`COLLAB_PAT`**
   - Value: the token
3. Done. You never touch this again.

> Skipping this just disables auto-invites — you can still add people in the browser (below). Deploy still works.

---

## 2. Add collaborators

### Automatic (recommended)

Edit **`collaborators.yml`**, add each person's GitHub **username**, commit:

```yaml
collaborators:
  - marc-github-username
  - brandon-github-username
```

On commit, the workflow invites them with Write access. (`denys@q-branch.dev` = `DenysUkr`, the owner — already has access, don't list.)

### Manual fallback (works with emails)

Repo → **Settings → Collaborators → Add people** → paste each email → role **Write**. Use this if you only have emails, not usernames.

---

## 3. Deploy (GitHub Pages) — already automatic

`.github/workflows/deploy.yml` runs on every push to `main`, self-enables Pages on the first run, and publishes the repo root. Live at:

**https://denysukr.github.io/Denys-QBSF-Dashboard/**

No Netlify, no secrets, no browser linking. (If you ever prefer Netlify, swap the workflow for a `netlify deploy` step with `NETLIFY_AUTH_TOKEN` + `NETLIFY_SITE_ID` secrets.)

---

## 4. Stand up the NEXT dashboard in one command

From a folder containing `index.html` + this `.github/` setup, with `gh` authenticated:

```powershell
./scripts/bootstrap.ps1 -Owner <owner> -Repo <Name>-QBSF-Dashboard `
    -Collaborators alice-username,bob-username
```

Creates the repo, pushes, invites collaborators. Pages turns on automatically on the first push.

---

## 5. Test / verify

```powershell
# Repo + files
gh api repos/DenysUkr/Denys-QBSF-Dashboard/contents --jq ".[].name"
# Deploy workflow run
gh run list --repo DenysUkr/Denys-QBSF-Dashboard --workflow deploy.yml -L 1
# Collaborators
gh api repos/DenysUkr/Denys-QBSF-Dashboard/collaborators --jq ".[].login"
# Live URL returns 200 / text/html
curl.exe -sI https://denysukr.github.io/Denys-QBSF-Dashboard/ | Select-String "HTTP|content-type"
```

- [ ] Deploy workflow shows ✅ on the latest commit
- [ ] Live URL returns 200 and renders the dashboard (not raw source)
- [ ] Each collaborator appears (after they accept) under Settings → Collaborators
