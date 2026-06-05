# The Q-Branch Dashboard — Simple Guide

This is your company's one-page website (we call it the "dashboard").
This guide explains **everything** in plain words. You do **not** need to know anything about computers. 💛

---

## 🌐 Where is the website?

👉 **https://denysukr.github.io/Denys-QBSF-Dashboard/**

It is always on. Anyone with the link can look at it.
When someone makes a change, the website fixes itself about **1 minute** later. You don't have to do anything.

---

## ✏️ How do I change the way it looks?

You don't type any computer code. You **ask a robot helper** (a free AI like ChatGPT or Claude) to do it for you.

1. Open the file named **CONTRIBUTOR_AGENT_BRIEF.md**
   👉 https://github.com/DenysUkr/Denys-QBSF-Dashboard/blob/main/CONTRIBUTOR_AGENT_BRIEF.md
   Copy **all** of the words in it.
2. Go to ChatGPT or Claude. Paste those words in as your **first message**.
3. Now tell the robot what you want, in normal words.
   *Example:* "Make the title bigger and the background light blue."
4. The robot replies with **one big block of text**. That block *is* the new website. Copy **all** of it.
5. Put it on the website:
   - Open the edit page 👉 https://github.com/DenysUkr/Denys-QBSF-Dashboard/edit/main/index.html
   - Press **Ctrl+A** (selects everything), then **Delete**.
   - **Paste** the block the robot gave you.
   - Scroll to the bottom and click the green **Commit changes** button.
6. Wait **1 minute**, then refresh the website. Your change is live! 🎉

> 😌 Don't worry — you can't break anything for good. If it looks wrong, just ask the robot again and paste the new version on top.

---

## 👥 Who is allowed to change the website?

- **Denys** — the owner
- **Marc** — `Q-Branch-007`
- **Brandon** — `QBrandon`
- **Denys (second account)** — `denys-QB`

---

## ➕ How do I add another helper?

1. Ask them for their **GitHub username** (the name they sign in to github.com with).
2. Open this file 👉 https://github.com/DenysUkr/Denys-QBSF-Dashboard/edit/main/collaborators.yml
3. Add one new line with their username, so it looks like this:
   ```yaml
   collaborators:
     - Q-Branch-007
     - QBrandon
     - denys-QB
     - their-new-username     # <-- your new line
   ```
4. Click the green **Commit changes** button.
5. GitHub sends them an **email**. They click **Accept** in that email. Done — now they can edit too.

---

## 🔧 One-time setup (the owner does this just once)

This makes "add another helper" happen all by itself. You only ever do it one time.

1. Make a key 👉 https://github.com/settings/tokens
   → *Generate new token (classic)* → tick the box that says **repo** → *Generate* → **copy** the key.
2. Save the key here 👉 https://github.com/DenysUkr/Denys-QBSF-Dashboard/settings/secrets/actions
   → *New repository secret* → Name it exactly **`COLLAB_PAT`** → paste the key → *Add secret*.

That's it, forever. *(If you skip this, the owner can still add people by hand — it just won't be automatic.)*

---

## ❓ If the website looks broken

- **Did you wait a full minute and refresh?** Changes take about 1 minute to appear.
- **Did you paste the WHOLE thing** the robot gave you — from the very first line to the very last? Half a file breaks the page. Just ask the robot for the full file again and paste it once more.

---

## 🤖 For the techy folks (you can ignore this)

- Every change auto-publishes via **GitHub Pages** — `.github/workflows/deploy.yml`.
- Adding a username to `collaborators.yml` auto-invites them — `.github/workflows/sync-collaborators.yml` (needs the `COLLAB_PAT` secret above).
- `scripts/bootstrap.ps1` builds a brand-new dashboard repo (create + enable Pages + invite people) in one command.
- The dashboard is a single self-contained `index.html` (inline CSS/JS, no build step).
