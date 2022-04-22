; https://superuser.com/a/1557323/89743

#Persistent ; script will stay running after the auto-execute section (top part of the script) completes
#SingleInstance Force ; Replaces the old instance of this script automatically

; https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-setthreadexecutionstate
; 0x80000002 = ES_CONTINUOUS | ES_DISPLAY_REQUIRED
DllCall("SetThreadExecutionState", UInt, 0x80000002)