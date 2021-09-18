#SingleInstance Force

; Increase the following value to make the mouse cursor move faster:
JoyMultiplier = 0.40

; Decrease the following value to require less joystick displacement-from-center
; to start moving the mouse.  However, you may need to calibrate your joystick
; -- ensuring it's properly centered -- to avoid cursor drift. A perfectly tight
; and centered joystick could use a value of 1:
JoyThreshold = 10

; Change the following to true to invert the Y-axis, which causes the mouse to
; move vertically in the direction opposite the stick:
InvertYAxis := false

; Change these values to use joystick button numbers other than 1, 2, and 3 for
; the left, right, and middle mouse buttons.  Available numbers are 1 through 32.
; Use the Joystick Test Script to find out your joystick's numbers more easily.
ButtonA = 1 ;; Middle Button
ButtonB = 2 ;; Right Button
ButtonX = 3 ;; Left Button
ButtonY = 4 ;; F11
ButtonLB = 5 ;; Prev Tab
ButtonRB = 6 ;; Next Tab
ButtonBack= 7 ;; Prev Visited Page
ButtonStart = 8 ;; Next Visited Page
ButtonLA = 9 ;; Ctrl + D / Bookmark
ButtonRA = 10 ;; Ctrl + W / Close Page
;; Triggers - 
;; POV Left/Right - 

;; TBA - Music Play/Stop, Forward, Backward
;; Dpad combinations, with GUI
;; Similar to tf2 voice lines
;; reverse button action goes in the menu back by one

; If your joystick has a POV control, you can use it as a mouse wheel.  The
; following value is the number of milliseconds between turns of the wheel.
; Decrease it to have the wheel turn faster:
WheelDelay = 40

; If your system has more than one joystick, increase this value to use a joystick
; other than the first:
JoystickNumber = 1

; END OF CONFIG SECTION -- Don't change anything below this point unless you want
; to alter the basic nature of the script.


JoystickPrefix = %JoystickNumber%Joy
Hotkey, %JoystickPrefix%%ButtonA%, ButtonA
Hotkey, %JoystickPrefix%%ButtonB%, ButtonB
Hotkey, %JoystickPrefix%%ButtonX%, ButtonX
Hotkey, %JoystickPrefix%%ButtonY%, ButtonY
Hotkey, %JoystickPrefix%%ButtonLB%, ButtonLB
Hotkey, %JoystickPrefix%%ButtonRB%, ButtonRB
Hotkey, %JoystickPrefix%%ButtonBack%, ButtonBack
Hotkey, %JoystickPrefix%%ButtonStart%, ButtonStart
Hotkey, %JoystickPrefix%%ButtonLA%, ButtonLA
Hotkey, %JoystickPrefix%%ButtonRA%, ButtonRA

; Calculate the axis displacements that are needed to start moving the cursor:
JoyThresholdUpper := 50 + JoyThreshold
JoyThresholdLower := 50 - JoyThreshold
if InvertYAxis
    YAxisMultiplier = -1
else
    YAxisMultiplier = 1

SetTimer, WatchJoystick, 10  ; Monitor the movement of the joystick.

GetKeyState, JoyInfo, %JoystickNumber%JoyInfo
IfInString, JoyInfo, P  ; Joystick has POV control, so use it as a mouse wheel.
    SetTimer, MouseWheel, %WheelDelay%

return  ; End of auto-execute section.


; The subroutines below do not use KeyWait because that would sometimes trap the
; WatchJoystick quasi-thread beneath the wait-for-button-up thread, which would
; effectively prevent mouse-dragging with the joystick.

ButtonX:
SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, left,,, 1, 0, D  ; Hold down the left mouse button.
SetTimer, WaitForButtonXUp, 10
return

ButtonB:
SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, right,,, 1, 0, D  ; Hold down the right mouse button.
SetTimer, WaitForButtonBUp, 10
return

ButtonA:
SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, middle,,, 1, 0, D  ; Hold down the right mouse button.
SetTimer, WaitForButtonAUp, 10
return

WaitForButtonXUp:
if GetKeyState(JoystickPrefix . ButtonX)
    return  ; The button is still, down, so keep waiting.
; Otherwise, the button has been released.
SetTimer, WaitForButtonXUp, off
SetMouseDelay, -1  ; Makes movement smoother.
MouseClick, left,,, 1, 0, U  ; Release the mouse button.
return

WaitForButtonBUp:
if GetKeyState(JoystickPrefix . ButtonB)
    return  ; The button is still, down, so keep waiting.
; Otherwise, the button has been released.
SetTimer, WaitForButtonBUp, off
MouseClick, right,,, 1, 0, U  ; Release the mouse button.
return

WaitForButtonAUp:
if GetKeyState(JoystickPrefix . ButtonA)
    return  ; The button is still, down, so keep waiting.
; Otherwise, the button has been released.
SetTimer, WaitForButtonAUp, off
MouseClick, middle,,, 1, 0, U  ; Release the mouse button.
return

WatchJoystick:
MouseNeedsToBeMoved := false  ; Set default.
SetFormat, float, 03
GetKeyState, joyX, %JoystickNumber%joyX
GetKeyState, joyY, %JoystickNumber%joyY
if joyX > %JoyThresholdUpper%
{
    MouseNeedsToBeMoved := true
    DeltaX := joyX - JoyThresholdUpper
}
else if joyX < %JoyThresholdLower%
{
    MouseNeedsToBeMoved := true
    DeltaX := joyX - JoyThresholdLower
}
else
    DeltaX = 0
if joyY > %JoyThresholdUpper%
{
    MouseNeedsToBeMoved := true
    DeltaY := joyY - JoyThresholdUpper
}
else if joyY < %JoyThresholdLower%
{
    MouseNeedsToBeMoved := true
    DeltaY := joyY - JoyThresholdLower
}
else
    DeltaY = 0
if MouseNeedsToBeMoved
{
    SetMouseDelay, -1  ; Makes movement smoother.
    MouseMove, DeltaX * JoyMultiplier, DeltaY * JoyMultiplier * YAxisMultiplier, 0, R
}
return

MouseWheel:
GetKeyState, JoyPOV, %JoystickNumber%JoyPOV
if JoyPOV = -1  ; No angle.
    return
if (JoyPOV > 31500 or JoyPOV < 4500)  ; Forward
    Send {WheelUp}
else if JoyPOV between 13500 and 22500  ; Back
    Send {WheelDown}
return

ButtonY:
	Send, {F11}
Return

ButtonLB:
	Send, ^+{Tab}
Return

ButtonRB:
	Send, ^{Tab}
Return

ButtonStart:
	Send, {XButton2}
Return

ButtonBack:
	Send, {XButton1}
Return

ButtonLA:
	Send, ^d
Return

ButtonRA:
	Send, ^w
Return

*~f12::
	Suspend, Off
ExitApp
