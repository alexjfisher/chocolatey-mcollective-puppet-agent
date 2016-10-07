$ErrorActionPreference = 'Stop';
$toolsDir   = 'C:\ProgramData\chocolatey\lib\mcollective-puppet-agent\tools' #"$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installedFiles = gc $toolsDir\installed_files.log
$installedFiles | ?{$_.trim() -ne '' -and (test-path $_)} | %{
  gci $_ | ?{-not $_.PSIsContainer} | %{
    Remove-Item $_.FullName -force
  }
}
get-service mcollective | restart-service -force
