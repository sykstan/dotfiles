# Nerd Fonts Installer for Windows with Scoop
# Automates: Scoop setup, nerd-fonts bucket, manifest generation, and font installation

# Require admin privileges for Set-ExecutionPolicy
# Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

# Colors for output
$InfoColor = "Cyan"
$SuccessColor = "Green"
$WarningColor = "Yellow"
$ErrorColor = "Red"

function Write-Info {
    param([string]$Message)
    Write-Host $Message -ForegroundColor $InfoColor
}

function Write-Success {
    param([string]$Message)
    Write-Host $Message -ForegroundColor $SuccessColor
}

function Write-Warn {
    param([string]$Message)
    Write-Host $Message -ForegroundColor $WarningColor
}

function Write-Err {
    param([string]$Message)
    Write-Host $Message -ForegroundColor $ErrorColor
}

# Step 1: Check and install Scoop
Write-Info "=== Step 1: Checking Scoop Installation ==="
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Success "Scoop is already installed."
} else {
    Write-Warn "Scoop not found. Installing Scoop..."
    
    # Set execution policy
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Write-Success "Execution policy set to RemoteSigned."
    } catch {
        Write-Err "Failed to set execution policy: $_"
        exit 1
    }
    
    # Install Scoop
    try {
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
        Write-Success "Scoop installed successfully."
    } catch {
        Write-Err "Failed to install Scoop: $_"
        exit 1
    }
}

# Step 2: Check and add nerd-fonts bucket
Write-Info ""
Write-Info "=== Step 2: Adding Nerd Fonts Bucket ==="
try {
    $buckets = scoop bucket list
    if ($buckets -match "nerd-fonts") {
        Write-Success "Nerd-fonts bucket is already added."
    } else {
        Write-Warn "Nerd-fonts bucket not found. Adding..."
        scoop bucket add nerd-fonts https://github.com/matthewjberger/scoop-nerd-fonts.git
        Write-Success "Nerd-fonts bucket added successfully."
    }
} catch {
    Write-Err "Failed to add nerd-fonts bucket: $_"
    exit 1
}

# Step 3: Generate/update manifests
Write-Info ""
Write-Info "=== Step 3: Generating Manifests ==="

# Find the nerd-fonts bucket path
$username = $env:USERNAME
$scoopRoot = Join-Path -Path $env:USERPROFILE -ChildPath "scoop"
$nerdFontsBucket = Join-Path -Path $scoopRoot -ChildPath "buckets\nerd-fonts"
$generateScript = Join-Path -Path $nerdFontsBucket -ChildPath "bin\generate-manifests.ps1"

if (-not (Test-Path $generateScript)) {
    Write-Err "Could not find generate-manifests.ps1 at: $generateScript"
    Write-Warn "Scoop bucket path might be different. Checked: $nerdFontsBucket"
    exit 1
}

try {
    Write-Info "Running manifest generation from: $generateScript"
    & $generateScript
    Write-Success "Manifests generated successfully."
} catch {
    Write-Err "Failed to generate manifests: $_"
    exit 1
}

# Step 4: Install fonts
Write-Info ""
Write-Info "=== Step 4: Installing Nerd Fonts ==="

# Define the list of fonts to install
$fonts = @(
    '0xproto-NF',
    'Agave-NF',
    'AtkinsonHyperlegibleMono-NF',
    'CascadiaCode-NF',
    'CaskaydiaCove-NF',
    'CodeNewRoman-NF',
    'ComicShannsMono-NF',
    'CommitMono-NF',
    'DejaVuSansMono-NF',
    'DroidSansMono-NF',
    'FantasqueSansMono-NF',
    'FiraCode-NF',
    'GeistMono-NF',
    'Hack-NF',
    'IBMPlexMono-NF',
    'Inconsolata-NF',
    'Iosevka-NF',
    'IosevkaTerm-NF',
    'JetBrainsMono-NF',
    'Lekton-NF',
    'Lilex-NF',
    'Maple-Mono',
    'Meslo-NF',
    'Monaspace-NF',
    'Mononoki-NF',
    'Recursive-NF',
    'SourceCodePro-NF',
    'Ubuntu-NF',
    'VictorMono-NF'
)

$failedFonts = @()

foreach ($font in $fonts) {
    Write-Host "Installing $font..." -ForegroundColor $InfoColor
    try {
        scoop install $font
        Write-Success "  [OK] $font installed."
    } catch {
        Write-Warn "  [FAIL] $font"
        $failedFonts += $font
    }
}

# Summary
Write-Info ""
Write-Info "=== Installation Summary ==="
Write-Success "Successfully installed $($fonts.Count - $failedFonts.Count)/$($fonts.Count) fonts."

if ($failedFonts.Count -gt 0) {
    Write-Warn "Failed to install the following fonts:"
    foreach ($font in $failedFonts) {
        Write-Host "  - $font"
    }
}

Write-Success "Nerd fonts installation complete!"