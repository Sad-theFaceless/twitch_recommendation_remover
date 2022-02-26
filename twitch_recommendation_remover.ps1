#Set-PSDebug -Trace 1

$repo_name = 'twitch_recommendation_remover'

$tmp_dir_name = "$repo_name.tmp"
$script_name = "$repo_name.sh"
$script_source = "https://raw.githubusercontent.com/Sad-theFaceless/$repo_name/main/$script_name"

if ((gwmi win32_operatingsystem | select osarchitecture).osarchitecture -eq "64-bit")
{
    $arch = '64'
}
else
{
    $arch = '32'
}

if (!(Test-Path "$PSScriptRoot/$tmp_dir_name"))
{
    New-Item "$PSScriptRoot/$tmp_dir_name" -ItemType Directory
}

if (!(Test-Path "$PSScriptRoot/$tmp_dir_name/PortableGit.7z.exe") -and !(Test-Path "$PSScriptRoot/$tmp_dir_name/PortableGit"))
{
    $download_source = -join('https://github.com', ((Invoke-WebRequest 'https://github.com/git-for-windows/git/releases/latest').Links.href | Select-String -Pattern "PortableGit-.*$arch-bit\.7z\.exe"))
    Invoke-WebRequest "$download_source" -OutFile "$PSScriptRoot/$tmp_dir_name/PortableGit.7z.exe"
}

if (!(Test-Path "$PSScriptRoot/$tmp_dir_name/PortableGit"))
{
    $wshell = New-Object -ComObject wscript.shell;
    & "$PSScriptRoot/$tmp_dir_name/PortableGit.7z.exe"
    Sleep 1
    $pid_PortableGit = Get-Process | Where-Object {$_.MainWindowTitle -like "*Portable Git for Windows $arch-bit*"} | Select -ExpandProperty Id
    for ($i = 0; $i -lt 10; $i++)
    {
        $wshell.AppActivate("Portable Git for Windows $arch-bit")
    }
    $wshell.SendKeys('~')
    Wait-Process -ID $pid_PortableGit
}

if (!(Test-Path "$PSScriptRoot/$tmp_dir_name/$script_name"))
{
    Invoke-WebRequest "$script_source" -OutFile "$PSScriptRoot/$tmp_dir_name/$script_name"
}

Set-Location "$PSScriptRoot/$tmp_dir_name/"
Start-Process cmd -Argument "/c $PSScriptRoot\$tmp_dir_name\PortableGit\bin\bash.exe -li"

#Read-Host -Prompt "Press Enter to exit"
