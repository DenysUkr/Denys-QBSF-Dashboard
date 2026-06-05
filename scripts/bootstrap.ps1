<#
.SYNOPSIS
  Stand up a new QBSF dashboard repo in one command: create it, push the
  current folder, and invite collaborators. Deploy + collaborator-sync are
  handled by the committed GitHub Actions workflows after the first push.

.PREREQS
  - gh CLI installed and authenticated: gh auth login
  - Run from a folder that contains index.html (and the .github/ workflows).

.EXAMPLE
  ./scripts/bootstrap.ps1 -Owner DenysUkr -Repo Denys-QBSF-Dashboard `
      -Collaborators marc-username,brandon-username
#>
param(
  [Parameter(Mandatory)][string]$Owner,
  [Parameter(Mandatory)][string]$Repo,
  [string[]]$Collaborators = @(),
  [ValidateSet('public','private')][string]$Visibility = 'public',
  [string]$Permission = 'push'
)

$ErrorActionPreference = 'Stop'

# 1. Create the repo from the current directory and push.
Write-Host "Creating $Owner/$Repo ($Visibility) and pushing current folder..."
gh repo create "$Owner/$Repo" "--$Visibility" --source=. --remote=origin --push

# 1b. Enable GitHub Pages (Actions source) once. The built-in GITHUB_TOKEN in
#     the deploy workflow cannot create the Pages site itself, so do it here.
Write-Host "Enabling GitHub Pages (Actions source)..."
try { gh api --method POST "repos/$Owner/$Repo/pages" -f build_type=workflow | Out-Null }
catch { Write-Host "  (Pages may already be enabled — continuing.)" }

# 2. Invite collaborators (by GitHub username).
foreach ($u in $Collaborators) {
  if ([string]::IsNullOrWhiteSpace($u)) { continue }
  Write-Host "Inviting $u as '$Permission'..."
  gh api --method PUT "repos/$Owner/$Repo/collaborators/$u" -f permission=$Permission | Out-Null
}

Write-Host ""
Write-Host "Done."
Write-Host "  - The Deploy workflow self-enables GitHub Pages on the first push."
Write-Host "  - Live URL: https://$($Owner.ToLower()).github.io/$Repo/"
Write-Host "  - For ongoing collaborator auto-invites, set the COLLAB_PAT repo secret"
Write-Host "    and edit collaborators.yml instead of re-running this script."
