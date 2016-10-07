$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'mcollective-puppet-agent'
$version = '1.11.1'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$pluginDir = 'C:\Program Files\Puppet Labs\Puppet\mcollective\lib\mcollective'

Get-ChocolateyUnzip -FileFullPath "$toolsDir\mcollective-puppet-agent-$version.zip" -Destination $toolsDir

$installedFiles = @()
ForEach ($dir in 'agent','aggregate','application','data','util','validator') {
  New-Item -ItemType Directory -Force -Path $pluginDir\$dir
  $files = Copy-Item $toolsDir\mcollective-puppet-agent-$version\$dir\* $pluginDir\$dir -recurse -force -PassThru -ErrorAction silentlyContinue
  if($files) {
    $installedFiles += $files
  } else { "Copy failure"}
}
$installedFiles | select -exp FullName | set-content $toolsDir\installed_files.log

get-service mcollective | restart-service -force
