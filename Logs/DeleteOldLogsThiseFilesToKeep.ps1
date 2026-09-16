# Удалям старые файлы, но оставляем самые новые при любом раскладе обстоятельств (логи перестали писаться)
$FileMask = "Errors*.txt*"
$DaysOld = 15
$FilesToKeep = 10

$FolderPath = "D:\Halk\Tests\Logs"


function Get-OldFiles {
    param(
        [string]$FolderPath,
        [string]$FileMask,
        [int]$DaysOld
    )

    $CutoffDate = (Get-Date).AddDays(-$DaysOld)

    Get-ChildItem `
        -Path $FolderPath `
        -File `
        -Filter $FileMask |
        Where-Object {
            $_.LastWriteTime -lt $CutoffDate
        }
}


function Remove-OldFiles {
    param(
        [System.IO.FileInfo[]]$Files,
        [int]$FilesToKeep
    )

    # Получаем количество всех фалов
    [int]$AllFilesCount = @(Get-ChildItem -Path $FolderPath -File -Filter $FileMask).Count
    Write-Host "Всего:" $AllFilesCount
    Write-Host "Бронь:"$FilesToKeep
    Write-Host "Просроценных:"$Files.Count


    if (($AllFilesCount - $Files.Count) -ge $FilesToKeep) {
        $FilesToKeep = 0
        Write-Host "Да"
    }
    else {
        $FilesToKeep = $FilesToKeep - ($AllFilesCount - $Files.Count)
        Write-Host "Нет"
    }

    Write-Host "Бронь:"$FilesToKeep

    # Сначала сортируем файлы от новых к старым
    $Files = $Files | Sort-Object LastWriteTime -Descending



    # Пропускаем последние файлы, которые нужно сохранить
    $FilesToDelete = $Files | Select-Object -Skip $FilesToKeep

    foreach ($File in $FilesToDelete) {
        Remove-Item `
            -Path $File.FullName `
            -Force `
            -Verbose `
            -WhatIf
    }
}


# Получаем старые файлы
$OldFiles = Get-OldFiles `
    -FolderPath $FolderPath `
    -FileMask $FileMask `
    -DaysOld $DaysOld



# Удаляем старые файлы, сохраняя последние 10
Remove-OldFiles `
    -Files $OldFiles `
    -FilesToKeep $FilesToKeep
