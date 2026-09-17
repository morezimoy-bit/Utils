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
        [string]$FolderPath,
        [string]$FileMask,
        [int]$DaysOld,
        [int]$FilesToKeep
    )
    # Получаем старые файлы
    $OldFiles = Get-OldFiles `
        -FolderPath $FolderPath `
        -FileMask $FileMask `
        -DaysOld $DaysOld


    # Получаем количество всех фалов
    [int]$AllFilesCount = @(Get-ChildItem -Path $FolderPath -File -Filter $FileMask).Count

    # Подсчитываем сколько файлов из выбранных на удаление оставить
    Write-Host "Всего:" $AllFilesCount
    Write-Host "Бронь:"$FilesToKeep
    Write-Host "Просроценных:"$OldFiles.Count


    if (($AllFilesCount - $OldFiles.Count) -ge $FilesToKeep) {
        $FilesToKeep = 0
        Write-Host "Да"
    }
    else {
        $FilesToKeep = $FilesToKeep - ($AllFilesCount - $OldFiles.Count)
        Write-Host "Нет"
    }

    Write-Host "Бронь:"$FilesToKeep

    # Сначала сортируем файлы от новых к старым
    $OldFiles = $OldFiles | Sort-Object LastWriteTime -Descending



    # Пропускаем последние файлы, которые нужно сохранить
    $FilesToDelete = $OldFiles | Select-Object -Skip $FilesToKeep

    foreach ($File in $FilesToDelete) {
        Remove-Item -Path $File.FullName -Force -Verbose # -WhatIf # Убрать предыдущий rem если надо тестировать
    }
}





Remove-OldFiles -FolderPath "D:\Halk\Tests\Logs" -FileMask "Errors*.txt*" -DaysOld 180 -FilesToKeep 10

