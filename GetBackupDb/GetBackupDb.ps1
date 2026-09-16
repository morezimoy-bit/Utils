$CurDate = (Get-Date)
# $DateStr = ($CurDate.Year, $CurDate.Month, $CurDate.Day) -join "_"
$DateStr = Get-Date -Format "yyyy_MM_dd"
$FileName = "ProjBoots_backup_"+ $DateStr + "*.bak"
$DirSrc = "\\172.16.6.194\MassSmsSender"
$DirDst = "D:\temp"
$FileLog = $DirDst + "\Logs\log_" + $DateStr + ".txt"

echo $CurDate
echo $DateStr
echo $FileName
chcp 1251
# robocopy "\\172.16.6.194\SMS_Numbers\BackUp" "D:\temp" *.txt /Z /COPY:DAT /R:3 /W:10

robocopy $DirSrc $DirDst $FileName /Z /COPY:DAT /R:3 /W:10 /LOG:$FileLog
