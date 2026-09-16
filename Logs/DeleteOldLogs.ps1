$FileMask = "Errors*.txt*"
$DaysOld = 90
$CutoffDate = (Get-Date).AddDays(-$DaysOld)

$FolderPath = "D:\MassSender\BabilonMobile.InformDiesel.MindMassSmsSender\Log"
Get-ChildItem -Path $FolderPath -Filter $FileMask | Where-Object { $_.LastWriteTime -lt $CutoffDate } | ForEach-Object { Remove-Item -Path $_.FullName -Force -Verbose}

$FolderPath = "D:\MassSender\BabilonMobile.InformDiesel.MassSmsSender\Log"
Get-ChildItem -Path $FolderPath -Filter $FileMask | Where-Object { $_.LastWriteTime -lt $CutoffDate } | ForEach-Object { Remove-Item -Path $_.FullName -Force -Verbose}

$FolderPath = "D:\MassSender\BabilonMobile.InformDiesel.IrsSmsSender\Log"
Get-ChildItem -Path $FolderPath -Filter $FileMask | Where-Object { $_.LastWriteTime -lt $CutoffDate } | ForEach-Object { Remove-Item -Path $_.FullName -Force -Verbose}

$FolderPath = "D:\MassSender\BabilonMobile.InformDiesel.MassSmsSenderFlo\Log"
Get-ChildItem -Path $FolderPath -Filter $FileMask | Where-Object { $_.LastWriteTime -lt $CutoffDate } | ForEach-Object { Remove-Item -Path $_.FullName -Force -Verbose}

$DaysOld = 180
$CutoffDate = (Get-Date).AddDays(-$DaysOld)
$FolderPath = "D:\MassSender\ToKeepAbreast\Log"
Get-ChildItem -Path $FolderPath -Filter $FileMask | Where-Object { $_.LastWriteTime -lt $CutoffDate } | ForEach-Object { Remove-Item -Path $_.FullName -Force -Verbose}


$FileMask = "Log.txt*"
$FolderPath = "D:\MassSender\SubscriptionService\Log"
Get-ChildItem -Path $FolderPath -Filter $FileMask | Where-Object { $_.LastWriteTime -lt $CutoffDate } | ForEach-Object { Remove-Item -Path $_.FullName -Force -Verbose}

$FileMask = "Errors.txt*"
$FolderPath = "D:\BudVKurse\Log"
Get-ChildItem -Path $FolderPath -Filter $FileMask | Where-Object { $_.LastWriteTime -lt $CutoffDate } | ForEach-Object { Remove-Item -Path $_.FullName -Force -Verbose}


