#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; shift + capslock -> capslock 
Lshift & Rshift::SetCapsLockState, % GetKeyState("CapsLock", "T")? "Off":"On"

; single capslock tap to Esc
CapsLock::Esc

; copy paste cut for Dvorak
^j::^c
^q::^x
^k::^v

; super key capslock
CapsLock & j::^c
CapsLock & e::^x
CapsLock & k::^v

; volume control
^sc0046::Send {Volume_Down}
^PrintScreen::Send {Volume_Up}