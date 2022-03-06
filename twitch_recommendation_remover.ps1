$repo_name = 'twitch_recommendation_remover'

$tmp_dir_name = "$repo_name.tmp"
$script_name = "$repo_name.sh"
$script_source = "https://raw.githubusercontent.com/Sad-theFaceless/$repo_name/main/$script_name"

$sevenzip_extra_source = "https://gist.github.com/Sad-theFaceless/13495618d5a81f61d21a2bb662610b38/raw/ca0eed83e1374ff3b2b043b4e2bc1ef50b16957e/7z2107-extra.zip"

Write-Host "Verifying PowerShell version..."
if ($PSVersionTable.PSVersion.Major -lt 5)
{
    Write-Host "Outdated PowerShell version. This script requires PowerShell 5 or higher."
    Read-Host -Prompt "Press Enter to exit"
    Exit
}
Write-Host "Verifying PowerShell version... Done."

Write-Host "Checking system architecture..."
if ((gwmi win32_operatingsystem | select osarchitecture).osarchitecture -eq "64-bit")
{
    $arch = '64'
}
else
{
    $arch = '32'
}
Write-Host "Checking system architecture... Done."

if (!(Test-Path "$PSScriptRoot/$tmp_dir_name"))
{
    Write-Host "Creating temporary directory..."
    New-Item "$PSScriptRoot/$tmp_dir_name" -ItemType Directory
    Write-Host "Creating temporary directory... Done."
}

if (!(Test-Path "$PSScriptRoot/$tmp_dir_name/PortableGit"))
{
    if (!(Test-Path "$PSScriptRoot/$tmp_dir_name/PortableGit.7z.exe"))
    {
        Write-Host "Downloading Git Portable..."
        $download_source = -join('https://github.com', ((Invoke-WebRequest 'https://github.com/git-for-windows/git/releases/latest').Links.href | Select-String -Pattern "PortableGit-.*$arch-bit\.7z\.exe"))
        Invoke-WebRequest "$download_source" -OutFile "$PSScriptRoot/$tmp_dir_name/PortableGit.7z.exe"
        Write-Host "Downloading Git Portable... Done."
    }
    if (!(Test-Path "$PSScriptRoot/$tmp_dir_name/7z-extra"))
    {
        if (!(Test-Path "$PSScriptRoot/$tmp_dir_name/7z-extra.zip"))
        {
            Write-Host "Downloading 7z-extra..."
            Invoke-WebRequest "$sevenzip_extra_source" -OutFile "$PSScriptRoot/$tmp_dir_name/7z-extra.zip"
            Write-Host "Downloading 7z-extra... Done."
        }
        Write-Host "Extracting 7z-extra..."
        Expand-Archive "$PSScriptRoot/$tmp_dir_name/7z-extra.zip" -DestinationPath "$PSScriptRoot/$tmp_dir_name/7z-extra"
        Write-Host "Extracting 7z-extra... Done."
    }
    Write-Host "Extracting Git Portable..."
    if ($arch -eq "64")
    {
        Start-Process "$PSScriptRoot\$tmp_dir_name\7z-extra\x64\7za.exe" -ArgumentList "x","$PSScriptRoot/$tmp_dir_name/PortableGit.7z.exe","-o$PSScriptRoot\$tmp_dir_name\PortableGit" -NoNewWindow -Wait
    }
    else
    {
        Start-Process "$PSScriptRoot\$tmp_dir_name\7z-extra\7za.exe" -ArgumentList "x","$PSScriptRoot/$tmp_dir_name/PortableGit.7z.exe","-o$PSScriptRoot\$tmp_dir_name\PortableGit" -NoNewWindow -Wait
    }
    Write-Host "Extracting Git Portable... Done."
}

if (Test-Path "$PSScriptRoot/$tmp_dir_name/PortableGit.7z.exe")
{
    Remove-Item "$PSScriptRoot/$tmp_dir_name/PortableGit.7z.exe"
}
if (Test-Path "$PSScriptRoot/$tmp_dir_name/7z-extra.zip")
{
    Remove-Item "$PSScriptRoot/$tmp_dir_name/7z-extra.zip"
}
if (Test-Path "$PSScriptRoot/$tmp_dir_name/7z-extra")
{
    Remove-Item "$PSScriptRoot/$tmp_dir_name/7z-extra" -Recurse
}

if (!(Test-Path "$PSScriptRoot/$tmp_dir_name/$script_name"))
{
    Write-Host "Downloading script..."
    Invoke-WebRequest "$script_source" -OutFile "$PSScriptRoot/$tmp_dir_name/$script_name"
    Write-Host "Downloading script... Done."
}

Write-Host "Opening bash command prompt."
Set-Location "$PSScriptRoot/$tmp_dir_name/"
Start-Process cmd -ArgumentList "/c","$PSScriptRoot\$tmp_dir_name\PortableGit\bin\bash.exe","-li","-c","./$script_name;bash"
