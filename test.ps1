[regex]$ipUserReg = '(?<=<IP>)(.*)(?:<\/IP><UserID>)(.*)(?=<\/UserID>)'
$files = Get-ChildItem $path -filter *.log
$users = @(
    foreach ($fileToSearch in $files) {
        $file = [System.IO.File]::OpenText($fileToSearch)
        while (!$file.EndOfStream) {
            $text = $file.ReadLine()
            if ($ipUserReg.Matches($text).Success -or $userReg.Matches($text).Success) {
                New-Object psobject -Property @{
                    IP = $ipUserReg.Matches($text).Groups[1].Value
                    User = $ipUserReg.Matches($text).Groups[2].Value
                }
            }
        }
        $file.Close()
})