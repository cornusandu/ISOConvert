try {
    scoop list 1>$NULL
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
               echo "We failed a third time at downloiading the 'cdrtools' dependency. Feel free to open an issue on our GitHub repository at: https://github.com/cornusandu/ISOConvert/issues. If you do open an issue, copy&paste this information to the developers:`n``````"
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

$regPath = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.cso"
$exportFile = "$env:USERPROFILE\Desktop\Backup_CSO_UserChoice.reg"

# Export the key (using reg.exe)
reg export "`"$regPath`"" "`"$exportFile`"" /y
if ($LASTEXITCODE -eq 0) {
    Write-Host "Exported fileexts.cso key to $exportFile in case anything goes wrong."
} else {
    Write-Host "Export failed (code $LASTEXITCODE)"
}

mkdir -Force "C:\Program Files\ISOCONVERT"

echo "Automatic setup completed. Please do the following to complete the installation:"
echo "1. Copy and paste all the executables from ./output into the C:\Program Files\ISOCONVERT folder we made for you"
echo "2. Manually install maxcso. You can find binaries at https://github.com/unknownbrackets/maxcso/releases/tag/v1.13.0 (unzip the archives and add the output directory to path; if you are confused on the process, feel free to ask on our github repo: https://github.com/cornusandu/ISOConvert/issues)"
echo "3. Consecutivelly double-click on all the .reg (registry) files in the local directory to manually load them"
echo "4. Use the tool to make a .iso and .cso, and right click on the folder, .iso and .cso files to make sure the utility is showing up correctly"
echo "|  Note: If you're on Windows 11, you may need to click on ;'Show more options' for the utility to appear"
echo "5. Once you're done, come back and press any key to exit"

pause
