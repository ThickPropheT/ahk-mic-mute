;
; AutoHotkey Version: v1.1.37.01
; Language:       English
; Platform:       Windows 10
; Author(s):      Andy Terra <github.com/airstrike>, ThickProphet <github.com/ThickPropheT>
;
; Script Function:
;	Set Microphone Mute -- assumes device_desc to be "capture" (see .\Lib\VA\VA.html > VA_GetDevice(...)).
;		- On key-press, toggles mute
;		- On key-held, turns mute on until key-up
;


;
; Library Imports
;

; Requires Vista Audio Control Functions Library (see .\Lib\VA\README.md)
#Include <VA\VA>


;
; AutoHotkey v1.x.x.x Flags
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force


;
; Configuration (Customize these settings to your liking).
;

; search criteria for device to mute. default: "capture"
global device_desc := "capture"

; determines whether or not to show toolTips
global toolTip_enabled := true

; how long toolTips remain visible. default: 750
global toolTip_duration := 750

; how long the key must be held to trigger the key-held handler. default: 250
global key_heldThreshold := 250


;
; Key Trigger (up|down|press|hold) to Handler (functions) Mappings
;

; push-to-talk (on hold)
global key_OnBeginHoldHandler := "Mic_Unmute"
global key_OnEndHoldHandler := "Mic_Mute"

; toggle mute (on press)
global key_OnPressHandler := "Mic_ToggleMute"

; unused at the moment. don't delete them.
global key_OnUpHandler :=
global key_OnDownHandler :=


;
; Constants / Enums
;

global KEY_UP := "UP"
global KEY_DOWN := "DOWN"
global KEY_HELD := "HELD"

global MUTE_ON := 1
global MUTE_TOGGLE := 0
global MUTE_OFF := -1


;
; State
;

global key_state := KEY_UP



;
; ToolTip Functions
;

; hide the toolTip.
HideToolTip() {

	SetTimer, HideToolTip, Off
	ToolTip
}

; when toolTip is enabled, show toolTip with the given text for the given duration; otherwise no-op.
ShowToolTip(text, duration) {

	if not (toolTip_enabled) {
		return
	}

	#Persistent

	ToolTip %text%
	SetTimer, HideToolTip, %duration%
}

; when toolTip is enabled, show toolTip with target device's mute status; otherwise no-op.
ShowMute(duration, setting) {

	onOff := setting ? "On" : "Off"
	text := % "Mic Mute: " . onOff

	ShowToolTip(text, duration)
}



;
; Integration Functions
;

; set mute for the given device descriptor.
; params:
;	desc: a descriptor for the target device.
;	new_setting:
;		 1 -> turn mute on
;		 0 -> toggle mute
;		-1 -> turn mute off
; returns:
; 	the target device's new mute state.
SetMute(desc, new_setting := 0) {

	mute := true

	if (new_setting < 0) {
		mute := false
	}
	else if (new_setting = 0) {
		mute := !VA_GetMute( , desc)
	}
	else if (0 < new_setting) {
		mute := true
	}
	else {
		throw Exception("Error for SetMute. new_setting is out of range.")
	}

	VA_SetMute(mute, , desc)

	return VA_GetMute( , desc)
}



;
; Core Functions
;

; set mute for the given device descriptor (see SetMute(...)).
SetMuteAndShow(new_setting) {

	setting := SetMute(device_desc, new_setting)

	ShowMute(toolTip_duration, setting)
}



;
; User Functions (Customize these functions to your liking).
;

; key-held(begin) handler.
Mic_Unmute() {

	; on key-held(begin), turn mute off
	SetMuteAndShow(MUTE_OFF)
}

; key-held(end) handler.
Mic_Mute() {

	; on key-held(end), turn mute on
	SetMuteAndShow(MUTE_ON)
}

; key-press handler.
Mic_ToggleMute() {

	; on key-press, toggle mute
	SetMuteAndShow(MUTE_TOGGLE)
}



;
; Key State Functions
;

; coordinates key-held portion of key-held state management.
Key_OnHold() {

	SetTimer Key_OnHold, Off

	if (key_OnBeginHoldHandler) {
		%key_OnBeginHoldHandler%()
	}

	key_state := KEY_HELD
}

; coordinates key-down portion of key-held state management.
Key_OnDown() {

	if not (key_state = KEY_UP) {
		return
	}

	if (key_OnDownHandler) {
		%key_OnDownHandler%()
	}

	SetTimer Key_OnHold, %key_heldThreshold%

	key_state := KEY_DOWN
}

; coordinates key-up portion of key-held state management.
Key_OnUp() {

	SetTimer, Key_OnHold, Off

	if (key_OnUpHandler) {
		%key_OnUpHandler%(key_state)
	}

	if (key_state = KEY_HELD and key_OnEndHoldHandler) {
		%key_OnEndHoldHandler%()
	}

	if (key_state = KEY_DOWN and key_OnPressHandler) {
		%key_OnPressHandler%()
	}

	key_state := KEY_UP
}



;
; Key Bindings
;

;
; 75% Board (knob mapped to NumLock) Bindings
;

; bind key-down handler to NumLock
NumLock::Key_OnDown()

; bind key-up handler to NumLock
~NumLock up::Key_OnUp()

;
; TKL Board (w/ PrintScreen key) Bindings
;

; bind key-down handler to PrintScreen
PrintScreen::Key_OnDown()

; bind key-up handler to PrintScreen
~PrintScreen up::Key_OnUp()
