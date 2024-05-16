@echo off
setlocal enabledelayedexpansion

:: Display help if no parameters or incorrect parameters are provided
if "%~1"=="" (
    goto help
)
if "%~2"=="" (
    goto help
)

:: File containing list of possible passwords (one per line)
set dictionaryFile=%~1

:: Hashed password to crack (e.g., MD5 hash)
set targetHash=%~2

:: Function to calculate the MD5 hash of a string
:: You need CertUtil, which is available on Windows, to compute the hash
set "getMD5Hash=for /f %%i in ('echo !string! ^| certutil -hashfile - md5 ^| findstr /r /c:[0-9a-f]\{32\}') do set hash=%%i"

:: Read each password from the dictionary file and calculate its hash
for /f "tokens=*" %%a in (%dictionaryFile%) do (
    set "string=%%a"
    call %getMD5Hash%
    if "!hash!"=="%targetHash%" (
        echo Password found: %%a
        goto end
    )
)

echo Password not found.
goto end

:help
echo Usage: %~nx0 wordlist.txt hash
echo.
echo Parameters:
echo   wordlist.txt  - File containing list of possible passwords (one per line)
echo   hash          - MD5 hash of the password to crack
echo.
echo Example:
echo   %~nx0 passwords.txt d41d8cd98f00b204e9800998ecf8427e
goto end

:end
pause
