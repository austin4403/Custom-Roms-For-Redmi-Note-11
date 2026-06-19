if exist %~dp0images\anti_version.txt (for /f "delims==" %%a in (%~dp0images\anti_version.txt) do (set CURRENT_ANTI_VER=%%a))
if [%CURRENT_ANTI_VER%] EQU [] set CURRENT_ANTI_VER=0
for /f "tokens=2 delims=: " %%i in ('fastboot %* getvar anti 2^>^&1 ^| findstr /r /c:"anti:"') do (set version=%%i)
if [%version%] EQU [] set version=0
set anticheck="antirollback check pass"
if %version% GTR %CURRENT_ANTI_VER% set anticheck="Current device antirollback version is greater than this pakcage"
echo %anticheck% | findstr /r /c:"pass" || @echo "Antirollback check error" && exit /B 1
fastboot %* getvar product 2>&1 | findstr /r /c:"^product: *tanzanite" || @echo "error : Missmatching image and device" && pause && exit /B 1

::set CURRENT_ANTI_VER=1
::for /f "tokens=2 delims=: " %%i in ('fastboot %* getvar anti 2^>^&1 ^| findstr /r /#c:"anti:"') do (set version=%%i)
::if [%version%] EQU [] set version=0
::if %version% GTR %CURRENT_ANTI_VER% (
::	@echo "error : current device antirollback version is greater than this package"
::	exit /B 1
::)
fastboot %* getvar partition-type:opcust 2>&1 | findstr /r /c:"^partition-type:opcust: raw"
if %errorlevel% equ 0 (
fastboot %* erase opcust || @echo "Erase opcust error" && exit /B 1
)
fastboot %* getvar partition-type:opcust 2>&1 | findstr /r /c:"^partition-type:opcust: ext4"
if %errorlevel% equ 0 (
fastboot %* erase opcust || @echo "Erase opcust error" && exit /B 1
)
fastboot %* getvar partition-type:opconfig 2>&1 | findstr /r /c:"^partition-type:opconfig: raw"
if %errorlevel% equ 0 (
fastboot %* erase opconfig || @echo "Erase opconfig error" && exit /B 1
)
fastboot %* getvar partition-type:opconfig 2>&1 | findstr /r /c:"^partition-type:opconfig: ext4"
if %errorlevel% equ 0 (
fastboot %* erase opconfig || @echo "Erase opconfig error" && exit /B 1
)
fastboot %* erase boot || @echo "Erase boot error" && pause && exit /B 1
fastboot %* flash preloader_ab %~dp0\images\preloader_tanzanite.bin || @echo "Flash preloader_a error" && pause && exit /B 1
::fastboot %* flash preloader_b %~dp0\images\preloader_tanzanite.bin || @echo "Flash preloader_b error" && exit /B 1
::fastboot %* flash frp %~dp0\images\frp_zero.img || @echo "Flash frp error" && exit /B
fastboot %* flash vbmeta_ab %~dp0\images\vbmeta.img || @echo "Flash vbmeta_a error" && pause && exit /B 1
::fastboot %* flash vbmeta_b %~dp0\images\vbmeta.img || @echo "Flash vbmeta_b error" && exit /B 1
fastboot %* flash vbmeta_system_ab %~dp0\images\vbmeta_system.img || @echo "Flash vbmeta_system_a error" && pause && exit /B 1
::fastboot %* flash vbmeta_system_b %~dp0\images\vbmeta_system.img || @echo "Flash vbmeta_system_b error" && exit /B 1
fastboot %* flash vbmeta_vendor_ab %~dp0\images\vbmeta_vendor.img || @echo "Flash vbmeta_vendor_a error" && pause && exit /B 1
::fastboot %* flash vbmeta_vendor_b %~dp0\images\vbmeta_vendor.img || @echo "Flash vbmeta_vendor_b error" && exit /B 1
fastboot %* flash md1img_ab %~dp0\images\md1img.img || @echo "Flash md1img_a error" && pause && exit /B 1
::fastboot %* flash md1img_b %~dp0\images\md1img.img || @echo "Flash md1img_b error" && exit /B 1
fastboot %* flash spmfw_ab %~dp0\images\spmfw.img || @echo "Flash spmfw error" && pause && exit /B 1
::fastboot %* flash spmfw_b %~dp0\images\spmfw.img || @echo "Flash spmfw error" && exit /B 1
fastboot %* flash pi_img_ab %~dp0\images\pi_img.img || @echo "Flash pi_a error" && pause && exit /B 1
::fastboot %* flash pi_img_b %~dp0\images\pi_img.img || @echo "Flash pi_b error" && exit /B 1
fastboot %* flash dpm_ab %~dp0\images\dpm.img || @echo "Flash dpm_a error" && pause && exit /B 1
::fastboot %* flash dpm_b %~dp0\images\dpm.img || @echo "Flash dpm_b error" && exit /B 1
fastboot %* flash scp_ab %~dp0\images\scp.img || @echo "Flash scp_a error" && pause && exit /B 1
::fastboot %* flash scp_b %~dp0\images\scp.img || @echo "Flash scp_b error" && exit /B 1
fastboot %* flash sspm_ab %~dp0\images\sspm.img || @echo "Flash sspm_a error" && pause && exit /B 1
::fastboot %* flash sspm_b %~dp0\images\sspm.img || @echo "Flash sspm_b error" && exit /B 1
fastboot %* flash mcupm_ab %~dp0\images\mcupm.img || @echo "Flash mcupm_a error" && pause && exit /B 1
::fastboot %* flash mcupm_b %~dp0\images\mcupm.img || @echo "Flash mcupm_b error" && exit /B 1
fastboot %* flash gz_ab %~dp0\images\gz.img || @echo "Flash gz_a error" && pause && exit /B 1
::fastboot %* flash gz_b %~dp0\images\gz.img || @echo "Flash gz_b error" && exit /B 1
fastboot %* flash dtbo_ab %~dp0\images\dtbo.img || @echo "Flash dtbo_a error" && pause && exit /B 1
::fastboot %* flash dtbo_b %~dp0\images\dtbo.img || @echo "Flash dtbo_b error" && exit /B 1
fastboot %* flash tee_ab %~dp0\images\tee.img || @echo "Flash tee_a error" && pause && exit /B 1
::fastboot %* flash tee_b %~dp0\images\tee.img || @echo "Flash tee_b error" && exit /B 1
fastboot %* flash logo_ab %~dp0\images\logo.bin || @echo "Flash logo_a error" && pause && exit /B 1
::fastboot %* flash logo_b %~dp0\images\logo.bin || @echo "Flash logo_b error" && exit /B 1
fastboot %* flash super %~dp0\images\super.img || @echo "Flash super error" && pause && exit /B 1
::fastboot %* flash userdata %~dp0\images\userdata.img || @echo "Flash userdata error" && exit /B 1
fastboot %* flash boot_ab %~dp0\images\boot.img || @echo "Flash boot_a error" && pause && exit /B 1
::fastboot %* flash boot_b %~dp0\images\boot.img || @echo "Flash boot_b error" && exit /B 1
fastboot %* flash vendor_boot_ab %~dp0\images\vendor_boot.img || @echo "Flash vendor_boot_a error" && pause && exit /B 1
::fastboot %* flash vendor_boot_b %~dp0\images\vendor_boot.img || @echo "Flash vendor_boot_b error" && exit /B 1
::fastboot %* flash efuse %~dp0\images\efuse.img || @echo "Flash efuse error" && exit /B 1:::
fastboot %* flash rescue %~dp0\images\rescue.img || @echo "Flash rescue error" && pause && exit /B 1
::fastboot %* flash cust %~dp0\images\cust.img || @echo "Flash cust error" && exit /B 1 error" && exit /B 1
::fastboot %* flash oops %~dp0\images\oops.img || @echo "Flash oops error" && exit /B 1 error" && exit /B 1
fastboot %* flash lk_ab %~dp0\images\lk.img || @echo "Flash lk_a error" && pause && exit /B 1
::fastboot %* flash lk_b %~dp0\images\lk.img || @echo "Flash lk_b error" && exit /B 1
fastboot %* set_active a || @echo "set_active  a error" && pause && exit /B 1
fastboot %* erase misc || @echo "Erase misc error" && pause && exit /B 1
fastboot %* oem cdms
fastboot %* reboot || @echo "Reboot error" && pause && exit /B 1
