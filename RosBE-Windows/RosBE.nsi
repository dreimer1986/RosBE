Unicode true
!define PRODUCT_NAME "ReactOS Build Environment"
!define PRODUCT_VERSION "2.3.0"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\RosBE.cmd"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKCU"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"

;;
;; Basic installer options
;;
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "RosBE-${PRODUCT_VERSION}.exe"
InstallDirRegKey HKCU "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

;;
;; Add version/product information metadata to the installation file.
;;
VIAddVersionKey /LANG=1033 "FileVersion" "2.3.0.0"
VIAddVersionKey /LANG=1033 "ProductVersion" "${PRODUCT_VERSION}"
VIAddVersionKey /LANG=1033 "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=1033 "Comments" "This installer was written by Peter Ward and Daniel Reimer using Nullsoft Scriptable Install System"
VIAddVersionKey /LANG=1033 "CompanyName" "ReactOS Foundation"
VIAddVersionKey /LANG=1033 "LegalTrademarks" "Copyright © 2020 ReactOS Foundation"
VIAddVersionKey /LANG=1033 "LegalCopyright" "Copyright © 2020 ReactOS Foundation"
VIAddVersionKey /LANG=1033 "FileDescription" "${PRODUCT_NAME} Setup"
VIProductVersion "2.3.0.0"

CRCCheck force
SetDatablockOptimize on
XPStyle on
SetCompressor /FINAL /SOLID lzma

!include "MUI2.nsh"
!include "InstallOptions.nsh"
!include "RosSourceDir.nsh"
!include "LogicLib.nsh"
!include "WinVer.nsh"

;;
;; Read our custom page ini, remove previous version and make sure only
;; one instance of the installer is running.
;;
Function .onInit
    ReadRegStr $R3 HKLM \
    "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
    StrCpy $R4 $R3 3
    System::Call 'kernel32::CreateMutex(i 0, i 0, t "RosBE-v${PRODUCT_VERSION}-Installer")p.r1 ?e'
    Pop $R0
    StrCmp $R0 0 +3
        MessageBox MB_OK|MB_ICONEXCLAMATION "The ${PRODUCT_NAME} v${PRODUCT_VERSION} installer is already running."
        Abort

    ${If} $INSTDIR == "" ; InstallDirRegKey not valid?
        StrCpy $0 $SysDir 1
        ${If} $0 == "\"
            StrCpy $0 'C'
        ${EndIf}
        StrCpy $INSTDIR "$0:\RosBE"
    ${EndIf}

    Call UninstallPrevious
    !insertmacro INSTALLOPTIONS_EXTRACT "RosSourceDir.ini"
FunctionEnd

;;
;; MUI Settings
;;
!define MUI_ABORTWARNING
!define MUI_ICON "RosBE\rosbe.ico"
!define MUI_UNICON "RosBE\uninstall.ico"
!define MUI_COMPONENTSPAGE_NODESC

!define MUI_WELCOMEPAGE_TITLE_3LINES
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "RosBE\License.txt"
!insertmacro MUI_PAGE_DIRECTORY

;;
;; ReactOS Source Directory Pages
;;
var REACTOS_SOURCE_DIRECTORY
!insertmacro CUSTOM_PAGE_ROSDIRECTORY

;;
;; Start menu page
;;
var ICONS_GROUP
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "ReactOS Build Environment"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"
!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP

!insertmacro MUI_PAGE_COMPONENTS

!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_TITLE_3LINES
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\README.pdf"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!insertmacro MUI_PAGE_FINISH

;;
;; Uninstaller pages
;;
!insertmacro MUI_UNPAGE_INSTFILES

;;
;;  Language and reserve files
;;
ReserveFile /plugin InstallOptions.dll
!insertmacro MUI_LANGUAGE "English"

Section -BaseFiles SEC01

    ;; Make the directory "$INSTDIR" read write accessible by all users
    AccessControl::SetOnFile "$INSTDIR" "(BU)" "FullAccess"
    Pop $0 ; "error" on errors

    SetOutPath "$INSTDIR"
    SetOverwrite try
    File /r RosBE\rosbe.ico
    File /r RosBE\Basedir.cmd
    File /r RosBE\Build-Shared.cmd
    File /r RosBE\changelog.txt
    File /r RosBE\charch.cmd
    File /r RosBE\chdefdir.cmd
    File /r RosBE\chdefgcc.cmd
    File /r RosBE\Clean.cmd
    File /r RosBE\Help.cmd
    File /r RosBE\kdbg.cmd
    File /r RosBE\LICENSE.txt
    File /r RosBE\Make.cmd
    File /r RosBE\Makex.cmd
    File /r RosBE\options.cmd
    File /r RosBE\raddr2line.cmd
    File /r RosBE\raddr2lineNW.cmd
    File /r RosBE\README.pdf
    File /r RosBE\Remake.cmd
    File /r RosBE\Remakex.cmd
    File /r RosBE\Renv.cmd
    File /r RosBE\RosBE.cmd
    File /r RosBE\rosbe-gcc-env.cmd
    File /r RosBE\scut.cmd
    File /r RosBE\TimeDate.cmd
    File /r RosBE\update.cmd
    File /r RosBE\version.cmd
    SetOutPath "$INSTDIR\include"
    SetOverwrite try
    File /r RosBE\include\*.*
    SetOutPath "$INSTDIR\lib"
    SetOverwrite try
    File /r RosBE\lib\*.*
    SetOutPath "$INSTDIR\share"
    SetOverwrite try
    File /r RosBE\share\*.*
    SetOutPath "$INSTDIR\bin"
    SetOverwrite try
    File /r RosBE\bin\7z.exe
    File /r RosBE\bin\7z.dll
    File /r RosBE\bin\bison.exe
    File /r RosBE\bin\buildtime.exe
    File /r RosBE\bin\ccache.exe
    File /r RosBE\bin\chknewer.exe
    File /r RosBE\bin\chkslash.exe
    File /r RosBE\bin\cmake.exe
    ;File /r RosBE\bin\cmcldeps.exe
    File /r RosBE\bin\cmp.exe
    ;File /r RosBE\bin\cpack.exe
    File /r RosBE\bin\cpucount.exe
    ;File /r RosBE\bin\ctest.exe
    File /r RosBE\bin\diff.exe
    File /r RosBE\bin\diff3.exe
    File /r RosBE\bin\echoh.exe
    File /r RosBE\bin\flash.exe
    File /r RosBE\bin\flex.exe
    File /r RosBE\bin\flex++.exe
    ;File /r RosBE\bin\gdb.exe
    ;File /r RosBE\bin\gdbserver.exe
    File /r RosBE\bin\getdate.exe
    ;File /r RosBE\bin\libgcc_s_dw2-1.dll
    ;File /r RosBE\bin\libstdc++-6.dll
    ;File /r RosBE\bin\libwinpthread-1.dll
    ;File /r RosBE\bin\log2lines.exe
    File /r RosBE\bin\m4.exe
    ;File /r RosBE\bin\mingw32-make.exe
    File /r RosBE\bin\msys-2.0.dll
    File /r RosBE\bin\msys-gnutls-30.dll
    File /r RosBE\bin\msys-iconv-2.dll
    File /r RosBE\bin\msys-idn2-0.dll
    File /r RosBE\bin\msys-intl-8.dll
    File /r RosBE\bin\msys-nettle-8.dll
    File /r RosBE\bin\msys-pcre2-8-0.dll
    File /r RosBE\bin\msys-psl-5.dll
    File /r RosBE\bin\msys-uuid-1.dll
    File /r RosBE\bin\msys-z.dll
    File /r RosBE\bin\ninja.exe
    File /r RosBE\bin\options.exe
    File /r RosBE\bin\patch.exe
    File /r RosBE\bin\patch.exe.manifest
    ;File /r RosBE\bin\pexports.exe
    ;File /r RosBE\bin\piperead.exe
    File /r RosBE\bin\playwav.exe
    File /r RosBE\bin\rquote.exe
    File /r RosBE\bin\scut.exe
    File /r RosBE\bin\sdiff.exe
    File /r RosBE\bin\tee.exe
    File /r RosBE\bin\wget.exe
    ;File /r RosBE\bin\zlib1.dll
    SetOutPath "$INSTDIR\samples"
    SetOverwrite try
    File /r RosBE\samples\*.*
SectionEnd

Section -MinGWGCC SEC02
    SetOutPath "$INSTDIR\i386"
    SetOverwrite try
    File /r RosBE\i386\*.*
SectionEnd

Section /o "AMD64 Compiler" SEC03
    SetOutPath "$INSTDIR\amd64"
    SetOverwrite try
    File /r RosBE\amd64\*.*
SectionEnd

Section /o "Add BIN folder to PATH variable (MSVC users)" SEC04
    EnVar::SetHKCU
    EnVar::AddValue "PATH" "$INSTDIR\bin"
    Pop $0
SectionEnd

Section /o "PowerShell Version" SEC05
    SetOutPath "$INSTDIR"
    SetOverwrite try
    File /r RosBE\Build.ps1
    File /r RosBE\charch.ps1
    File /r RosBE\chdefdir.ps1
    File /r RosBE\chdefgcc.ps1
    File /r RosBE\Clean.ps1
    File /r RosBE\Help.ps1
    File /r RosBE\kdbg.ps1
    File /r RosBE\options.ps1
    File /r RosBE\playwav.ps1
    File /r RosBE\reladdr2line.ps1
    File /r RosBE\reladdr2lineNW.ps1
    File /r RosBE\Remake.ps1
    File /r RosBE\Remakex.ps1
    File /r RosBE\RosBE.ps1
    File /r RosBE\rosbe-gcc-env.ps1
    File /r RosBE\scut.ps1
    File /r RosBE\update.ps1
    File /r RosBE\version.ps1
    SetOutPath "$DESKTOP"
    SetOverwrite try
    File /r "RosBE\RosBE PS - PostInstall.reg"
    MessageBox MB_ICONINFORMATION|MB_OK \
               "A REG-File was generated on your desktop. Please use it with Admin Rights to set Powershell's execution rights correctly if your RosBE Powershell Version fails to run after install. Otherwise, just delete it."
SectionEnd

Section -StartMenuShortcuts SEC06

    ;;
    ;; Add our start menu shortcuts.
    ;;
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
        SetOutPath $REACTOS_SOURCE_DIRECTORY
        IfFileExists "$INSTDIR\RosBE.cmd" 0 +2
            CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\ReactOS Build Environment ${PRODUCT_VERSION}.lnk" "$SYSDIR\cmd.exe" '/t:0A /k "$INSTDIR\RosBE.cmd"' "$INSTDIR\rosbe.ico"
        IfFileExists "$INSTDIR\RosBE.ps1" 0 +2
            CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\ReactOS Build Environment ${PRODUCT_VERSION} - PS.lnk" "$SYSDIR\WindowsPowerShell\v1.0\powershell.exe" "-noexit &'$INSTDIR\RosBE.ps1'" "$INSTDIR\rosbe.ico"
        IfFileExists "$INSTDIR\amd64\*" 0 +5
            IfFileExists "$INSTDIR\RosBE.cmd" 0 +2
                CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\ReactOS Build Environment ${PRODUCT_VERSION} AMD64.lnk" "$SYSDIR\cmd.exe" '/t:0B /k "$INSTDIR\RosBE.cmd" amd64' "$INSTDIR\rosbe.ico"
            IfFileExists "$INSTDIR\RosBE.ps1" 0 +2
                CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\ReactOS Build Environment ${PRODUCT_VERSION} AMD64 - PS.lnk" "$SYSDIR\WindowsPowerShell\v1.0\powershell.exe" "-noexit &'$INSTDIR\RosBE.ps1' amd64" "$INSTDIR\rosbe.ico"
        SetOutPath $INSTDIR
        CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Uninstall RosBE.lnk" \
                       "$INSTDIR\Uninstall.exe"
        CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Readme.lnk" \
                       "$INSTDIR\README.pdf"
        CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Options.lnk" \
                       "$INSTDIR\bin\options.exe"
    !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section /o "Desktop Shortcuts" SEC07

    ;;
    ;; Add our desktop shortcuts.
    ;;
    SetOutPath $REACTOS_SOURCE_DIRECTORY
    IfFileExists "$INSTDIR\RosBE.cmd" 0 +2
        CreateShortCut "$DESKTOP\ReactOS Build Environment ${PRODUCT_VERSION}.lnk" "$SYSDIR\cmd.exe" '/t:0A /k "$INSTDIR\RosBE.cmd"' "$INSTDIR\rosbe.ico"
    IfFileExists "$INSTDIR\RosBE.ps1" 0 +2
        CreateShortCut "$DESKTOP\ReactOS Build Environment ${PRODUCT_VERSION} - PS.lnk" "$SYSDIR\WindowsPowerShell\v1.0\powershell.exe" "-noexit &'$INSTDIR\RosBE.ps1'" "$INSTDIR\rosbe.ico"
    IfFileExists "$INSTDIR\amd64\*" 0 +5
        IfFileExists "$INSTDIR\RosBE.cmd" 0 +2
            CreateShortCut "$DESKTOP\ReactOS Build Environment ${PRODUCT_VERSION} AMD64.lnk" "$SYSDIR\cmd.exe" '/t:0B /k "$INSTDIR\RosBE.cmd" amd64' "$INSTDIR\rosbe.ico"
        IfFileExists "$INSTDIR\RosBE.ps1" 0 +2
            CreateShortCut "$DESKTOP\ReactOS Build Environment ${PRODUCT_VERSION} AMD64 - PS.lnk" "$SYSDIR\WindowsPowerShell\v1.0\powershell.exe" "-noexit &'$INSTDIR\RosBE.ps1' amd64" "$INSTDIR\rosbe.ico"
SectionEnd

Section /o "Quick Launch Shortcuts" SEC08

    ;;
    ;; Add our quick launch shortcuts.
    ;;
    SetOutPath $REACTOS_SOURCE_DIRECTORY
    IfFileExists "$INSTDIR\RosBE.cmd" 0 +2
        CreateShortCut "$QUICKLAUNCH\ReactOS Build Environment ${PRODUCT_VERSION}.lnk" "$SYSDIR\cmd.exe" '/t:0A /k "$INSTDIR\RosBE.cmd"' "$INSTDIR\rosbe.ico"
    IfFileExists "$INSTDIR\RosBE.ps1" 0 +2
        CreateShortCut "$QUICKLAUNCH\ReactOS Build Environment ${PRODUCT_VERSION} - PS.lnk" "$SYSDIR\WindowsPowerShell\v1.0\powershell.exe" "-noexit &'$INSTDIR\RosBE.ps1'" "$INSTDIR\rosbe.ico"
    IfFileExists "$INSTDIR\amd64\*" 0 +5
        IfFileExists "$INSTDIR\RosBE.cmd" 0 +2
            CreateShortCut "$QUICKLAUNCH\ReactOS Build Environment ${PRODUCT_VERSION} AMD64.lnk" "$SYSDIR\cmd.exe" '/t:0B /k "$INSTDIR\RosBE.cmd" amd64' "$INSTDIR\rosbe.ico"
        IfFileExists "$INSTDIR\RosBE.ps1" 0 +2
            CreateShortCut "$QUICKLAUNCH\ReactOS Build Environment ${PRODUCT_VERSION} AMD64 - PS.lnk" "$SYSDIR\WindowsPowerShell\v1.0\powershell.exe" "-noexit &'$INSTDIR\RosBE.ps1' amd64" "$INSTDIR\rosbe.ico"
SectionEnd

Section -Post SEC09
    WriteUninstaller "$INSTDIR\Uninstall.exe"
    WriteRegStr HKCU "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\RosBE.cmd"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
SectionEnd

Function un.onUninstSuccess
    HideWindow
    MessageBox MB_ICONINFORMATION|MB_OK \
               "ReactOS Build Environment was successfully removed from your computer."
FunctionEnd

Function un.onInit
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 \
        "Are you sure you want to remove ReactOS Build Environment and all of its components?" \
        IDYES +2
    Abort
    IfFileExists "$APPDATA\RosBE\." 0 +3
        MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 \
        "Do you want to remove the ReactOS Build Environment configuration file from the Application Data Path?" \
        IDNO +2
        RMDir /r /REBOOTOK "$APPDATA\RosBE"
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 \
    "Do you want to remove the Shortcuts? If you just want to Update to a new Version of RosBE, keep them. This keeps your previous settings." \
    IDNO +9
        Delete /REBOOTOK "$DESKTOP\ReactOS Build Environment ${PRODUCT_VERSION}.lnk"
        Delete /REBOOTOK "$QUICKLAUNCH\ReactOS Build Environment ${PRODUCT_VERSION}.lnk"
        Delete /REBOOTOK "$DESKTOP\ReactOS Build Environment ${PRODUCT_VERSION} - PS.lnk"
        Delete /REBOOTOK "$QUICKLAUNCH\ReactOS Build Environment ${PRODUCT_VERSION} - PS.lnk"
        Delete /REBOOTOK "$DESKTOP\ReactOS Build Environment ${PRODUCT_VERSION} AMD64.lnk"
        Delete /REBOOTOK "$QUICKLAUNCH\ReactOS Build Environment ${PRODUCT_VERSION} AMD64.lnk"
        Delete /REBOOTOK "$DESKTOP\ReactOS Build Environment ${PRODUCT_VERSION} AMD64 - PS.lnk"
        Delete /REBOOTOK "$QUICKLAUNCH\ReactOS Build Environment ${PRODUCT_VERSION} AMD64 - PS.lnk"
FunctionEnd

Section Uninstall
    !insertmacro MUI_STARTMENU_GETFOLDER "Application" $ICONS_GROUP

    ;;
    ;; Clean up PATH Variable.
    ;;
    EnVar::SetHKCU
    EnVar::DeleteValue "PATH" "$INSTDIR\bin"
    Pop $0
    
    ;;
    ;; Clean up installed files.
    ;;
    RMDir /r /REBOOTOK "$INSTDIR\i386"
    RMDir /r /REBOOTOK "$INSTDIR\amd64"
    RMDir /r /REBOOTOK "$INSTDIR\bin"
    RMDir /r /REBOOTOK "$INSTDIR\certs"
    RMDir /r /REBOOTOK "$INSTDIR\samples"
    RMDir /r /REBOOTOK "$INSTDIR\lib"
    RMDir /r /REBOOTOK "$INSTDIR\include"
    RMDir /r /REBOOTOK "$INSTDIR\share"
    StrCmp $ICONS_GROUP "" NO_SHORTCUTS
    RMDir /r /REBOOTOK "$SMPROGRAMS\$ICONS_GROUP"
    NO_SHORTCUTS:
    Delete /REBOOTOK "$INSTDIR\Basedir.cmd"
    Delete /REBOOTOK "$INSTDIR\Build.ps1"
    Delete /REBOOTOK "$INSTDIR\Build-Shared.cmd"
    Delete /REBOOTOK "$INSTDIR\ChangeLog.txt"
    Delete /REBOOTOK "$INSTDIR\charch.cmd"
    Delete /REBOOTOK "$INSTDIR\charch.ps1"
    Delete /REBOOTOK "$INSTDIR\chdefdir.cmd"
    Delete /REBOOTOK "$INSTDIR\chdefdir.ps1"
    Delete /REBOOTOK "$INSTDIR\chdefgcc.cmd"
    Delete /REBOOTOK "$INSTDIR\chdefgcc.ps1"
    Delete /REBOOTOK "$INSTDIR\Clean.cmd"
    Delete /REBOOTOK "$INSTDIR\Clean.ps1"
    Delete /REBOOTOK "$INSTDIR\Help.cmd"
    Delete /REBOOTOK "$INSTDIR\Help.ps1"
    Delete /REBOOTOK "$INSTDIR\kdbg.cmd"
    Delete /REBOOTOK "$INSTDIR\kdbg.ps1"
    Delete /REBOOTOK "$INSTDIR\LICENSE.txt"
    Delete /REBOOTOK "$INSTDIR\Make.cmd"
    Delete /REBOOTOK "$INSTDIR\Makex.cmd"
    Delete /REBOOTOK "$INSTDIR\options.cmd"
    Delete /REBOOTOK "$INSTDIR\options.ps1"
    Delete /REBOOTOK "$INSTDIR\playwav.ps1"
    Delete /REBOOTOK "$INSTDIR\raddr2line.cmd"
    Delete /REBOOTOK "$INSTDIR\raddr2lineNW.cmd"
    Delete /REBOOTOK "$INSTDIR\README.pdf"
    Delete /REBOOTOK "$INSTDIR\reladdr2line.ps1"
    Delete /REBOOTOK "$INSTDIR\reladdr2lineNW.ps1"
    Delete /REBOOTOK "$INSTDIR\Remake.cmd"
    Delete /REBOOTOK "$INSTDIR\Remakex.cmd"
    Delete /REBOOTOK "$INSTDIR\Remake.ps1"
    Delete /REBOOTOK "$INSTDIR\Remakex.ps1"
    Delete /REBOOTOK "$INSTDIR\Renv.cmd"
    Delete /REBOOTOK "$INSTDIR\RosBE PS - PostInstall.reg"
    Delete /REBOOTOK "$INSTDIR\RosBE.cmd"
    Delete /REBOOTOK "$INSTDIR\rosbe.ico"
    Delete /REBOOTOK "$INSTDIR\RosBE.ps1"
    Delete /REBOOTOK "$INSTDIR\rosbe-gcc-env.cmd"
    Delete /REBOOTOK "$INSTDIR\rosbe-gcc-env.ps1"
    Delete /REBOOTOK "$INSTDIR\scut.cmd"
    Delete /REBOOTOK "$INSTDIR\scut.ps1"
    Delete /REBOOTOK "$INSTDIR\TimeDate.cmd"
    Delete /REBOOTOK "$INSTDIR\uninstall.ico"
    Delete /REBOOTOK "$INSTDIR\update.cmd"
    Delete /REBOOTOK "$INSTDIR\update.ps1"
    Delete /REBOOTOK "$INSTDIR\version.cmd"
    Delete /REBOOTOK "$INSTDIR\version.ps1"
    Delete /REBOOTOK "$INSTDIR\Uninstall.exe"
    ;; Whoever dares to change this back into: RMDir /r /REBOOTOK "$INSTDIR" will be KILLED!!!
    RMDir /REBOOTOK "$INSTDIR"

    ;;
    ;; Clean up the registry.
    ;;
    DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
    DeleteRegKey HKCU "${PRODUCT_DIR_REGKEY}"
    SetAutoClose true
SectionEnd

Function UninstallPrevious
    ReadRegStr $R0 HKCU \
               "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
               "UninstallString"
    ReadRegStr $R1 HKCU \
               "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
               "DisplayVersion"
    ${If} $R1 == "${PRODUCT_VERSION}"
        messageBox MB_OK|MB_ICONEXCLAMATION \
            "You already have the ${PRODUCT_NAME} v${PRODUCT_VERSION} installed. You should uninstall the ${PRODUCT_NAME} v${PRODUCT_VERSION} if you want to reinstall."
    ${EndIf}
    ${If} $R0 == ""
        ReadRegStr $R0 HKLM \
                   "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
                   "UninstallString"
        ReadRegStr $R1 HKLM \
                   "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" \
                   "DisplayVersion"
        ${If} $R0 == ""
            Return
        ${EndIf}
    ${EndIf}
    MessageBox MB_YESNO|MB_ICONQUESTION  \
               "A previous version of the ${PRODUCT_NAME} was found. You should uninstall it before installing this version.$\n$\nDo you want to do that now?" \
               IDNO UninstallPrevious_no \
               IDYES UninstallPrevious_yes
    Abort
    UninstallPrevious_yes:
        Var /global PREVIOUSINSTDIR
        Push $R0
        Call GetParent
        Pop $PREVIOUSINSTDIR
        Pop $R0
        ExecWait '$R0 _?=$PREVIOUSINSTDIR'
    UninstallPrevious_no:
FunctionEnd

Function GetParent
    Exch $R0
    Push $R1
    Push $R2
    Push $R3
    Push $R4

    StrCpy $R1 0
    StrLen $R2 $R0

    loop:
        IntOp $R1 $R1 + 1
        IntCmp $R1 $R2 get 0 get
        StrCpy $R3 $R0 1 -$R1
        StrCmp $R3 "\" get
        Goto loop

    get:
        StrCpy $R0 $R0 -$R1

        Pop $R3
        Pop $R2
        Pop $R1
        Exch $R0
FunctionEnd
