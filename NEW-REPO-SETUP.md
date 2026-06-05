# Denys-QBSF-Dashboard — Setup + Collaborators + Netlify

**Model:** one shared repository, **3 direct collaborators** (Write access), auto-deployed by Netlify. Every push to `main` by any collaborator publishes online in ~30s.

> Replaces the old "branch-per-contributor + branch protection" model. Collaborators push directly to the shared repo instead of owning a protected branch.

**Concrete values for this setup:**

| Item | Value |
|---|---|
| Owner | `DenysUkr` |
| Repo name | `Denys-QBSF-Dashboard` (owner's name + "QBSF Dashboard") |
| Visibility | Public |
| Collaborators | `marc@q-branch.dev`, `brandon@q-branch.dev`, `denys@q-branch.dev` |

> ⚠️ Two things to know about collaborators:
> - GitHub's **API/CLI adds collaborators by username**, not email. The **browser "Add people" box accepts emails** and resolves them to accounts — so the email list below uses the browser path.
> - `denys@q-branch.dev` may be the **owner account** itself. You can't add yourself as a collaborator; if so, skip that one (the owner already has full access).

---

## 0. The AI prompt (paste-in for collaborators)

The repo ships with **`CONTRIBUTOR_AGENT_BRIEF.md`** — the pastable prompt each collaborator gives their AI agent (claude.ai, ChatGPT, Claude Code). They paste it, describe the change they want, and the agent returns a complete `index.html`.

Keep this file in the repo so every collaborator starts from the same prompt. (Its workflow section assumes the branch model; for this direct-collaborator model, the publish step is simply "commit to `main`" — I can adapt the brief on request.)

---

## 1. Create the repository

### Option A — GitHub CLI (fastest)

```powershell
# One-time: authenticate the CLI
gh auth login   # GitHub.com -> HTTPS -> login with a browser

# From the folder that holds index.html:
gh repo create DenysUkr/Denys-QBSF-Dashboard --public --source=. --remote=origin --push
```

### Option B — Browser

1. https://github.com/new
2. Owner: **`DenysUkr`** · Name: **`Denys-QBSF-Dashboard`** · Visibility: **Public**
3. **Do NOT** initialize with README/.gitignore/license.
4. Create, then push:
   ```powershell
   git remote add origin https://github.com/DenysUkr/Denys-QBSF-Dashboard.git
   git push -u origin main
   ```

Files that go up: `index.html` (the dashboard), `CONTRIBUTOR_AGENT_BRIEF.md` (the prompt), `NEW-REPO-SETUP.md` (this guide).

---

## 2. Add the 3 collaborators

### Option A — Browser (works with emails)

GitHub repo → **Settings → Collaborators → Add people** → type each email → pick the account → role **Write** → send invite:

- `marc@q-branch.dev`
- `brandon@q-branch.dev`
- `denys@q-branch.dev`  *(skip if this is the owner account)*

Each person gets an email invite they must accept.

### Option B — GitHub CLI (needs usernames, not emails)

Once you know each person's GitHub **username**:

```powershell
gh api --method PUT repos/DenysUkr/Denys-QBSF-Dashboard/collaborators/<USERNAME> -f permission=push
```

`permission=push` = read + write.

---

## 3. Connect Netlify (browser-only)

1. https://app.netlify.com/start → **Import from Git → GitHub.**
2. Authorize the Netlify GitHub App, grant access to **`DenysUkr/Denys-QBSF-Dashboard`**.
3. Pick the repo. **Site settings:**
   - Branch to deploy: `main`
   - Build command: *(blank)*
   - Publish directory: *(blank — root)*
4. **Deploy site** (~30s). Then **Change site name** to something memorable → URL becomes `https://<site-name>.netlify.app/`.
5. (Optional) Build & deploy → **Branch deploys → All branches** for per-branch previews.

After this, every push to `main` auto-publishes to the live URL.

---

## 4. Test / verify

- [ ] Repo exists and contains `index.html` + `CONTRIBUTOR_AGENT_BRIEF.md`:
      ```powershell
      gh repo view DenysUkr/Denys-QBSF-Dashboard --web
      ```
- [ ] All 3 collaborators show under Settings → Collaborators (invited/accepted):
      ```powershell
      gh api repos/DenysUkr/Denys-QBSF-Dashboard/collaborators --jq ".[].login"
      ```
- [ ] Live URL returns **200 / text/html** and renders (not raw source):
      ```powershell
      curl.exe -sI https://<site-name>.netlify.app/ | Select-String "HTTP|content-type"
      ```
- [ ] A collaborator edits `index.html` (pencil → commit to `main`) → live URL updates within ~60s.

If the URL shows raw HTML instead of a rendered page, set the Netlify publish directory to the repo root (blank).
