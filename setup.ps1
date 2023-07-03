function setMSGTemp($message){
	$progressBarValue = Get-Content -Path $env:USERPROFILE\AppData\Roaming\EmuDeck\msg.log -TotalCount 1 -ErrorAction SilentlyContinue
	$progressBarUpdate=[int]$progressBarValue+1

	#We prevent the UI to close if we have too much MSG, the classic eternal 99%
	if ( $progressBarUpdate -eq 95 ){
		$progressBarUpdate=90
	}
	"$progressBarUpdate" | Out-File -encoding ascii $env:USERPROFILE\AppData\Roaming\EmuDeck\msg.log
	echo $message
	Add-Content $env:USERPROFILE\AppData\Roaming\EmuDeck\msg.log "# $message" -NoNewline
	Start-Sleep -Seconds 0.5
}
setMSGTemp 'Creating configuration files. please wait'

echo "" > $env:USERPROFILE/EmuDeck/EmuDeck.log

Start-Sleep -Seconds 1.5

Start-Transcript $env:USERPROFILE/EmuDeck/EmuDeck.log

#We install 7zip - Now its on the appimage
#winget install -e --id 7zip.7zip --accept-package-agreements --accept-source-agreements

# JSON Parsing to ps1 file

. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\JSONtoPS1.ps1
JSONtoPS1


#
# Functions, settings and vars
#

. $env:USERPROFILE\AppData\Roaming\EmuDeck\backend\functions\all.ps1


#
# Installation
#
#
#Clear old installation msg log
Remove-Item $userFolder\AppData\Roaming\EmuDeck\msg.log -ErrorAction SilentlyContinue
Write-Output "Installing, please stand by..."
Write-Output ""

copyFromTo "$env:USERPROFILE\AppData\Roaming\EmuDeck\backend\roms" "roms"

#old Files cleanup
#$testN3ds
#if ( Test-Path $emulationPath\roms\n3ds -PathType Leaf -eq "true" ){
#	#Delete the file
#	Remove-Item $emulationPath\roms\n3ds -ErrorAction SilentlyContinue
#	Rename-Item $emulationPath\roms\3ds $emulationPath\roms\n3ds -ErrorAction SilentlyContinue
#}
#
#if ( Test-Path $emulationPath\roms\gc -PathType Leaf -eq "true" ){
#	#Delete the file
#	Remove-Item $emulationPath\roms\gc -ErrorAction SilentlyContinue
#	Rename-Item $emulationPath\roms\gamecube $emulationPath\roms\gc -ErrorAction SilentlyContinue
#}


#Dowloading..ESDE
$test=Test-Path -Path "$esdePath\EmulationStation.exe"
if(-not($test) -and $doInstallESDE -eq "true" ){
	ESDE_install
}


#SRM
$test=Test-Path -Path "$toolsPath\srm.exe"
if(-not($test)){
	SRM_install
}

#
# Emulators Download
#

#RetroArch
$test=Test-Path -Path "$emusPath\RetroArch\RetroArch.exe"
if(-not($test) -and $doInstallRA -eq "true" ){
	RetroArch_install
}

#Dolphin
$test=Test-Path -Path "$emusPath\Dolphin-x64\Dolphin.exe"
if(-not($test) -and $doInstallDolphin -eq "true" ){
	Dolphin_install
}

#PCSX2 
$test=Test-Path -Path "$emusPath\PCSX2-Qt\pcsx2-qtx64-avx2.exe"
if(-not($test) -and $doInstallPCSX2 -eq "true" ){
	PCSX2QT_install
}

#RPCS3
#$test=Test-Path -Path "$emusPath\RPCS3"
#if(-not($test) -and $doInstallRPCS3 -eq "true" ){
#	RPCS3_install
#}

#Xemu
#$test=Test-Path -Path "$emusPath\xemu"
#if(-not($test) -and $doInstallXemu -eq "true" ){
#	Xemu_install
#}

#Yuzu
$test=Test-Path -Path "$emusPath\yuzu\yuzu-windows-msvc\yuzu.exe"
if(-not($test) -and $doInstallYuzu -eq "true" ){
	Yuzu_install
}

#Citra
$test=Test-Path -Path "$emusPath\citra"
if(-not($test) -and $doInstallCitra -eq "true" ){
	Citra_install
}
#melonDS
$test=Test-Path -Path "$emusPath\melonDS"
if(-not($test) -and $doInstallmelonDS -eq "true" ){
	melonDS_install
}

#Ryujinx
$test=Test-Path -Path "$emusPath\Ryujinx"
if(-not($test) -and $doInstallRyujinx -eq "true" ){
	Ryujinx_install
}

#DuckStation
$test=Test-Path -Path "$emusPath\duckstation\duckstation-qt-x64-ReleaseLTCG.exe"
if(-not($test) -and $doInstallDuck -eq "true" ){
	DuckStation_install
}

#Cemu
$test=Test-Path -Path "$emusPath\cemu\Cemu.exe"
if(-not($test) -and $doInstallCemu -eq "true" ){
	Cemu_install
}

#Xenia
#$test=Test-Path -Path "$emusPath\xenia"
#if(-not($test) -and $doInstallXenia -eq "true" ){
#	Xenia_install
#}

#PPSSPP
$test=Test-Path -Path "$emusPath\ppsspp_win\PPSSPPWindows64.exe"
if(-not($test) -and $doInstallPPSSPP -eq "true" ){
	PPSSPP_install
}


#
# Emus Configuration
# 

setMSG 'Configuring Emulators'


if ( "$doSetupRA" -eq "true" ){
	RetroArch_init
}

if ( "$doSetupDuck" -eq "true" ){
	DuckStation_init
}

if ( "$doSetupDolphin" -eq "true" ){
	Dolphin_init
}

if ( "$doSetupYuzu" -eq "true" ){
	Yuzu_init
}

if ( "$doSetupRyujinx" -eq "true" ){
	Ryujinx_init
}

if ( "$doSetupCitra" -eq "true" ){
	Citra_init
}

if ( "$doSetupCemu" -eq "true" ){
	Cemu_init
}

if ( "$doSetupPCSX2" -eq "true" ){
	PCSX2QT_init
}

if ( "$doSetupRPCS3" -eq "true" ){
	RPCS3_init
}

#if ( "$doSetupXemu" -eq "true" ){
	#Xemu_init
#}

#if ( "$doSetupXenia" -eq "true" ){
	#Xenia_init
#}

#if ( "$doSetupPPSSPP" -eq "true" ){
	#PPSSPP_init
#}

#if ( "$doSetupVita3K" -eq "true" ){
	#Vita3K_init
#}

#if ( "$doSetupScummVM" -eq "true" ){
	#ScummVM_init
#}

if ( "$doSetupESDE" -eq "true" ){
	ESDE_init
}

if ( "$doSetupSRM" -eq "true" ){
	SRM_init
}


#Customization

#RetroAchievments
if ( "$doSetupRA" -eq "true" ){
	RetroArch_retroAchievementsSetLogin
	if  ("$doRASignIn" -eq "true" ){
		#RetroArch_retroAchievementsPromptLogin
		#RetroArch_retroAchievementsSetLogin
		RetroArch_retroAchievementsOn
	}
	
	if ( "$doRAEnable" -eq "true" ){
		RetroArch_retroAchievementsOn
	}
	
	if ( "$achievementsHardcore" -eq "true" ){
		RetroArch_retroAchievementsHardCoreOn
	}else{
		RetroArch_retroAchievementsHardCoreOff
	}
}

if  ("$doRASignIn" -eq "true" ){
	if ( "$doInstallDuck" -eq "true" ){
		DuckStation_retroAchievementsSetLogin
	}
	if ( "$doInstallPCSX2" -eq "true" ){
		PCSX2QT_retroAchievementsSetLogin
	}
}

#AR, Bezels and Shaders
#RA Bezels	
if ( "$doSetupRA" -eq "true" ){
	RetroArch_setBezels #needs to change
	
	#RA AutoSave	
	if ( "$RAautoSave" -eq "true" ){
		RetroArch_autoSaveOn
	}else{
		RetroArch_autoSaveOff
	}	
}

#
#New Shaders
#Moved before widescreen, so widescreen disabled if needed.
#	
if ( "$doSetupRA" -eq "true" ){
	RetroArch_setShadersCRT
	RetroArch_setShaders3DCRT
	RetroArch_setShadersMAT
}

	#
	#New Aspect Ratios
	#
	
	#Sega Games
		#Master System
		#Genesis
		#Sega CD
		#Sega 32X
	if ( "$doSetupRA" -eq "true" ){
		switch ($arSega){
		  32 {	 
			RetroArch_mastersystem_ar32;
			RetroArch_genesis_ar32;
			RetroArch_segacd_ar32
			RetroArch_sega32x_ar32	
		  }			
		  43 {
			RetroArch_mastersystem_ar43
			RetroArch_genesis_ar43
			RetroArch_segacd_ar43
			RetroArch_sega32x_ar43
			if ( "$RABezels" -eq "true"){
				if ("$doSetupRA" -eq "true" ){
				  RetroArch_mastersystem_bezelOn
				  RetroArch_genesis_bezelOn
				  RetroArch_segacd_bezelOn
				  RetroArch_sega32x_bezelOn
				}
			}
		  }
		}
		
		#Snes and NES
		switch ($arSnes){
		  87{
			RetroArch_snes_ar87
			RetroArch_nes_ar87
		  }
		  43{
			RetroArch_snes_ar43
			RetroArch_nes_ar43
			if ( "$RABezels" -eq "true" ){
				if( "$doSetupRA" -eq "true" ){
					RetroArch_snes_bezelOn
				}	
			}
		  }		  
		}
	}
	# Classic 3D Games
		#Dreamcast
		#PSX
		#Nintendo 64
		#Saturn
		#Xbox
	if ( "$arClassic3D" -eq 169 ){		
		if ( "$doSetupRA" -eq "true" ){	
			RetroArch_Beetle_PSX_HW_wideScreenOn
			RetroArch_Flycast_wideScreenOn			
			RetroArch_dreamcast_bezelOff
			RetroArch_psx_bezelOff
			RetroArch_n64_wideScreenOn
			RetroArch_SwanStation_wideScreenOn
		}
		if ( "$doSetupDuck" -eq "true" ){
			DuckStation_wideScreenOn
		}
		if ( "$doSetupXemu" -eq "true" ){
			Xemu_wideScreenOn
		}

	}else{
		if ( "$doSetupRA" -eq "true" ){
			#"SET 4:3"
			RetroArch_Flycast_wideScreenOff
			RetroArch_n64_wideScreenOff
			RetroArch_Beetle_PSX_HW_wideScreenOff
			RetroArch_SwanStation_wideScreenOff
		}
		if ( "$doSetupDuck" -eq "true" ){
			DuckStation_wideScreenOff
		}
		if ( "$doSetupXemu" -eq "true" ){
			Xemu_wideScreenOff
		}
		#"Bezels on"
		if ( "$RABezels" -eq "true" ){
			if( "$doSetupRA" -eq "true" ){
			RetroArch_dreamcast_bezelOn			
			RetroArch_n64_bezelOn
			RetroArch_psx_bezelOn
			}
		}			
	}
	
	# GameCube
	if ( "$doSetupDolphin" -eq "true" ){
		if ( "$arDolphin" -eq 169 ){	
			Dolphin_wideScreenOn
		}else{
			Dolphin_wideScreenOff
		}
	}

Stop-Transcript