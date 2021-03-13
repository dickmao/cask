$here = $PSScriptRoot
$project_root = (Get-Item $here).Parent.FullName

# XXX: It seems that Emacs writes to stderr, so PowerShell thinks it's an error. Redirecting to
# stdout alone doesn't help, because it's the processed stderr, which contain error records, not
# the original stderr. Piping at the end to convert these error records into strings doesn't
# work either.
#
# It's worth noting that the issue happens only on Azure Pipelines, with Windows 2019, probably
# because of the execution mode being remote or something.
#
# https://mnaoumov.wordpress.com/2015/01/11/execution-of-external-commands-in-powershell-done-right/
# https://github.com/PowerShell/JEA/issues/24
# https://github.com/PowerShell/PowerShell/issues/4002
# https://stackoverflow.com/questions/2095088/error-when-calling-3rd-party-executable-from-powershell-when-using-an-ide
$ErrorActionPreference = 'Continue'
emacs --version
Push-Location $project_root
.\w32-bin\cask install
.\w32-bin\cask emacs --batch `
  -l ert `
  -f ert-run-tests-batch-and-exit
Pop-Location
