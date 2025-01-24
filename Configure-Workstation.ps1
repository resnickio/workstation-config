# Function to check if the script is running with administrator permissions
function Test-IsAdministrator {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# Function to install packages using winget
function Install-WingetPackage {
    param (
        [string]$PackageName
    )
    Write-Host "Installing $PackageName using winget..."
    winget install --id $PackageName --silent
}

# Function to install applications from local executable files
function Install-LocalExecutable {
    param (
        [string]$ExecutablePath,
        [string]$Arguments = "/S"
    )
    Write-Host "Installing application from $ExecutablePath..."
    Start-Process -FilePath $ExecutablePath -ArgumentList $Arguments -Wait
}

# Function to download and install applications from web locations
function Install-WebInstaller {
    param (
        [string]$Url,
        [string]$InstallerPath,
        [string]$Arguments = "/S"
    )
    Write-Host "Downloading installer from $Url..."
    Invoke-WebRequest -Uri $Url -OutFile $InstallerPath
    Write-Host "Installing application from $InstallerPath..."
    Start-Process -FilePath $InstallerPath -ArgumentList $Arguments -Wait
    Remove-Item -Path $InstallerPath -Force
}

# Check if running as administrator
if (-not (Test-IsAdministrator)) {
    Write-Host "This script must be run as an administrator. Please run it with elevated permissions." -ForegroundColor Red
    exit
}

# Install packages using winget
$packages = @(
    "Git.Git"
    "GitHub.GitHubDesktop",
    "Jabra.Direct",
    "Microsoft.PowerToys",
    "Microsoft.SQLServerManagementStudio",
    "Microsoft.VisualStudio.2022.Professional",
    "Microsoft.VisualStudioCode",
    "Notepad++.Notepad++",
    "Python.Python.3.11",
    "vim.vim",
    "Zoom.Zoom"
)
foreach ($package in $packages) {
    Install-WingetPackage -PackageName $package
}

# Install applications from local executable files
# $localInstallerPath = "C:\Path\To\Your\Installer.exe"
# Install-LocalExecutable -ExecutablePath $localInstallerPath

# Download and install applications from web locations
# $webInstallerUrl = "https://example.com/installer.exe"
# $tempInstallerPath = "$env:TEMP\installer.exe"
# Install-WebInstaller -Url $webInstallerUrl -InstallerPath $tempInstallerPath

Write-Host "Configuration complete!"
