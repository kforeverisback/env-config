function update-keychain {
  [CmdletBinding()]
  param(
    [Parameter()]
    [string] $sshKeyPath = "$HOME\.ssh\github-key-ms"
  )
  Start-Service ssh-agent
  $sig=ssh-keygen -lf $sshKeyPath
  foreach($line in (ssh-add -l) -split "\r\n") {
    if ($line -eq $sig) {
      echo "$sshKeyPath already added"
      return;
    }
  }
  echo "Adding $sshKeyPath"
  ssh-add $sshKeyPath
}

Set-Alias -Name ll -Value 'ls'
Set-Alias -Name wg -Value 'winget'
Set-Alias -Name g -Value 'git'
Set-alias -Name gvim -Value "C:\Program Files\Vim\vim90\gvim.exe"
Set-alias -Name vim -Value "C:\Program Files\Vim\vim90\vim.exe"

Invoke-Expression (&"C:\Program Files\starship\bin\starship.exe" init powershell)
#C:\Users\mekram\AppData\Local\Programs\oh-my-posh\bin\oh-my-posh.exe --init --shell pwsh  | Invoke-Expression
