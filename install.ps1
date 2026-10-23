# claude-token-saver installer (Windows PowerShell)
# Usage: irm https://raw.githubusercontent.com/yaldizemre/claude-token-saver/main/install.ps1 | iex
param([switch]$Force, [string]$Dir = (Get-Location).Path)
$ErrorActionPreference = "Stop"
$Repo = if ($env:CT_REPO) { $env:CT_REPO } else { "yaldizemre/claude-token-saver" }
$Branch = if ($env:CT_BRANCH) { $env:CT_BRANCH } else { "main" }

$tmp = Join-Path ([IO.Path]::GetTempPath()) ("ct-" + [guid]::NewGuid())
New-Item -ItemType Directory -Path $tmp | Out-Null
try {
  $zip = Join-Path $tmp "repo.zip"
  Invoke-WebRequest "https://codeload.github.com/$Repo/zip/refs/heads/$Branch" -OutFile $zip
  Expand-Archive $zip -DestinationPath $tmp
  $src = (Get-ChildItem $tmp -Recurse -Directory -Filter template | Select-Object -First 1).FullName
  if (-not $src) { throw "template/ not found in $Repo@$Branch" }
  Get-ChildItem $src -Recurse -File -Force | ForEach-Object {
    $rel = $_.FullName.Substring($src.Length).TrimStart('\','/')
    $dest = Join-Path $Dir $rel
    if ((Test-Path $dest) -and -not $Force) { Write-Host "  skip    $rel (exists; use -Force)"; return }
    if (Test-Path $dest) { Copy-Item $dest "$dest.bak" -Force }
    New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
    Copy-Item $_.FullName $dest -Force
    Write-Host "  write   $rel"
  }
  Write-Host "Done. Edit .claude/docs/architecture.md, then run 'claude'."
} finally { Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue }
