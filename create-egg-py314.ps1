# Build script for Python 3.14 egg on Windows
# Run with: powershell -ExecutionPolicy Bypass -File .\create-egg-py314.ps1

Write-Host "Creating Deluge Streaming Plugin egg for Python 3.14..." -ForegroundColor Green

# Create virtual environment
Write-Host "Creating virtual environment..." -ForegroundColor Yellow
python -m venv .env-egg314

# Activate virtual environment and install dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow
& .\.env-egg314\Scripts\Activate.ps1
pip install --upgrade pip setuptools wheel
pip install thomas rarfile rfc6266

# Create symbolic links or copy dependencies
Write-Host "Linking dependencies..." -ForegroundColor Yellow
$pythonVersion = python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')"
$sitePackages = ".\.env-egg314\Lib\site-packages"

# Create symbolic links (requires admin privileges) or use junction/copy as fallback
try {
    New-Item -ItemType SymbolicLink -Path "thomas" -Target "$sitePackages\thomas" -ErrorAction Stop
    New-Item -ItemType SymbolicLink -Path "rarfile.py" -Target "$sitePackages\rarfile.py" -ErrorAction Stop
    New-Item -ItemType SymbolicLink -Path "rfc6266.py" -Target "$sitePackages\rfc6266.py" -ErrorAction Stop
    New-Item -ItemType SymbolicLink -Path "lepl" -Target "$sitePackages\lepl" -ErrorAction Stop
    New-Item -ItemType SymbolicLink -Path "pytz" -Target "$sitePackages\pytz" -ErrorAction Stop
    Write-Host "Symbolic links created successfully" -ForegroundColor Green
} catch {
    Write-Host "Creating junctions/copies instead (no admin privileges)..." -ForegroundColor Yellow
    if (Test-Path "$sitePackages\thomas") { cmd /c mklink /J thomas "$sitePackages\thomas" }
    if (Test-Path "$sitePackages\rarfile.py") { Copy-Item "$sitePackages\rarfile.py" -Destination "." }
    if (Test-Path "$sitePackages\rfc6266.py") { Copy-Item "$sitePackages\rfc6266.py" -Destination "." }
    if (Test-Path "$sitePackages\lepl") { cmd /c mklink /J lepl "$sitePackages\lepl" }
    if (Test-Path "$sitePackages\pytz") { cmd /c mklink /J pytz "$sitePackages\pytz" }
}

# Build the egg
Write-Host "Building egg..." -ForegroundColor Yellow
python setup.py bdist_egg

Write-Host "Build complete! Check the dist/ directory for the egg file." -ForegroundColor Green
Write-Host "Remember to clean up symbolic links/junctions after building if needed." -ForegroundColor Cyan

deactivate

