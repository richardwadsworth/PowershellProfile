Function Initialize-VSEnvironment() {
  Push-Location "C:\Program Files (x86)\Microsoft Visual Studio 12.0\vc";
  cmd /c "vcvarsall.bat & set" |
  foreach {
    if ($_ -match "=") {
      $v = $_.split("="); set-item -force -path "ENV:\$($v[0])" -value "$($v[1])";
    }
  }
  Pop-Location;
  Write-Host "`nVisual Studio 2013 Command Prompt variables set." -ForegroundColor Green;
}

Function Initialize-RubyEnvironment() {
  Push-Location "C:\Ruby193\bin";
  cmd /E:ON /c setrbvars.bat
  Pop-Location;
  Write-Host "`nRuby variables set." -ForegroundColor Green;

}

# for configururing Git
Function Set-GitCore {
  $gitIgnorePath = Join-Path $ProfilePath .gitignore;
  git config --global user.name "Richard Wadsworth";
  #git config --global core.editor vim;
  git config --global color.ui true;
  git config --global core.autocrlf true;
  git config --global core.excludesfile $gitIgnorePath;
  #git config --global mergetool.vimdiff3.cmd 'vim -f -d -c "wincmd J" "$MERGED" "$LOCAL" "$BASE" "$REMOTE"';
  #git config --global merge.tool vimdiff3;
  #git config --global diff.tool.bc4;
  #git config --global difftool.bc4.path $BeyondCompPath;
  #git config --global branch.autosetupmerge true;
}

# for configuring git at Amido with suitable settings
Function Set-AmidoGitConfiguration {
  git config --global user.email richard.wadsworth@amido.com;
  Set-GitCore;

  $sshKey = ssh-add -L | Select-String "richard.wadsworth@amido.co.uk";
  if (!$sshKey) {
    $sshKeyFile = Join-Path $env:USERPROFILE "Dropbox\SSH\richard.wadsworth@amido.co.uk_rsa";
    ssh-add $sshKeyFile;
  }
}

Function Visualize-Git {
  git log --oneline --decorate --all --graph --simplify-by-decoration;
}

$ProfilePath    = Split-Path $PROFILE;

. $($ProfilePath + '\Modules\posh-git\profile.example.ps1'); # Posh-Git

Set-Alias subl 'C:\Program Files\Sublime Text 2\sublime_text.exe'

Set-StrictMode -Version Latest;
$Global:DebugPreference = "SilentlyContinue";
$Global:VerbosePreference = "SilentlyContinue";

Initialize-VSEnvironment
Initialize-RubyEnvironment

#Set-AmidoGitConfiguration
#Visualize-Git



