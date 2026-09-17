function Get-OldFiles {
    param(
        [string]$FolderPath,
        [string]$FileMask,
        [int]$DaysOld
    )

    $CutoffDate = (Get-Date).AddDays(-$DaysOld)

    Get-ChildItem -Path $FolderPath -Filter $FileMask |
        Where-Object {
			(-not $_.PSIsContainer) -and
            ($_.LastWriteTime -lt $CutoffDate)
        }
		
		
}


function Remove-OldFiles {
    param(
        [string]$FolderPath,
        [string]$FileMask,
        [int]$DaysOld,
        [int]$FilesToKeep
    )
	Write-Host "-------------------------------------"
	Write-Host $FolderPath
	
    # Получаем старые файлы
    $OldFiles = Get-OldFiles `
        -FolderPath $FolderPath `
        -FileMask $FileMask `
        -DaysOld $DaysOld

	if ($null -eq $OldFiles -or @($OldFiles).Count -eq 0) {
		Write-Host "No old files"
		return
	}		

    # Получаем количество всех фалов
    [int]$AllFilesCount = @(Get-ChildItem -Path $FolderPath -Filter $FileMask | Where-Object { !$_.PSIsContainer }).Count

    # Подсчитываем сколько файлов из выбранных на удаление оставить
    Write-Host "All:" $AllFilesCount
    Write-Host "OldFiles:"$OldFiles.Count
    Write-Host "Reservation:"$FilesToKeep


    if (($AllFilesCount - $OldFiles.Count) -ge $FilesToKeep) {
        $FilesToKeep = 0
        Write-Host "Yes"
    }
    else {
        $FilesToKeep = $FilesToKeep - ($AllFilesCount - $OldFiles.Count)
        Write-Host "No"
    }

    Write-Host "Reservation:"$FilesToKeep

    # Сначала сортируем файлы от новых к старым
    $OldFiles = $OldFiles | Sort-Object LastWriteTime -Descending



    # Пропускаем последние файлы, которые нужно сохранить
    $FilesToDelete = $OldFiles | Select-Object -Skip $FilesToKeep

	#
	if ($null -eq $FilesToDelete -or @($FilesToDelete).Count -eq 0) {
		Write-Host "No files to delete"
		return
	}

    foreach ($File in $FilesToDelete) {
        Remove-Item -Path $File.FullName -Force -Verbose #-WhatIf # Убрать предыдущий rem если надо тестировать
    }
}





Remove-OldFiles -FolderPath "D:\MassSender\BabilonMobile.InformDiesel.MassSmsSender\Log" -FileMask "Errors*.txt*" -DaysOld 60 -FilesToKeep 10
Remove-OldFiles -FolderPath "D:\MassSender\BabilonMobile.InformDiesel.IrsSmsSender\Log" -FileMask "Errors*.txt*" -DaysOld 60 -FilesToKeep 10
Remove-OldFiles -FolderPath "D:\MassSender\BabilonMobile.InformDiesel.MassSmsSenderFlo\Log" -FileMask "Errors*.txt*" -DaysOld 60 -FilesToKeep 10
Remove-OldFiles -FolderPath "D:\MassSender\SubscriptionService\Log" -FileMask "Log.txt*" -DaysOld 60 -FilesToKeep 10
Remove-OldFiles -FolderPath "D:\BudVKurse\Log" -FileMask "Errors.txt*" -DaysOld 60 -FilesToKeep 90


