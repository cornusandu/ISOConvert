try {
    & scoop list 1>$NULL -ErrorAction Stop
    echo "Scoop already installed."
}
catch {
    echo "Installing scoop..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression 1>$NULL
    echo "Scoop installed."
}

echo "Installing dependencies."

try {
    & mkisofs 1>$NULL -ErrorAction Stop
}
catch {
    try {
        echo "Installing mkisofs"
        scoop install main/cdrtools --no-update-scoop
    } catch {
        echo "Oops! Looks like we failed to download some dependencies. Hold on, we will try again."
        try {
            scoop install main/cdrtools --no-cache
        } catch {
            echo "We failed a second time at downloiading the `cdrtfe` dependency (`choco install cdrtfe`). Trying again..." 
            scoop checkup
            $err = $NULL
            $out = scoop install main/cdrtools --no-cache -ErrorVariable err -ErrorAction Continue
            
            # After this line, you should check if the install was successful
            if ($err) {
               echo "We failed a third time at downloiading the 'cdrtools' dependency. Feel free to open an issue on our GitHub repository at: [...]. If you do open an issue, copy&paste this information to the developers:`n``````"
               echo "`t`tSTDOUT"
               echo $out
               echo "`t`tSTDERR"
               echo $err
               echo "``````"
               exit 1
            }
        }
    }
}

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.cso"
$exportFile = "$env:USERPROFILE\Desktop\Backup_CSO_UserChoice.reg"

# Export the key (using reg.exe)
reg export "`"$regPath`"" "`"$exportFile`"" /y
if ($LASTEXITCODE -eq 0) {
    Write-Host "Exported fileexts.cso key to $exportFile in case anything goes wrong."
} else {
    Write-Error "Export failed (code $LASTEXITCODE)"
}

echo "Automatic setup completed. Please manually load all the .reg (registry) files in the local directory to finish installation."
