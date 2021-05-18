#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
ListLines Off
Process, Priority, %PID%, High
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
DetectHiddenWindows, On
SetTitleMatchMode, 2
;Gui Start
Start: 
Gui, Font, s10
Gui, Add, Text,, Enter hinted letters (e.g. p_k_)
Gui, Add, Edit, vSearchString
Gui, Add, CheckBox, vAutoFill, Auto Guess
Gui, Add, Button, w100 Default, Search
Gui, Show, w250, Decoder
Guicontrol,, AutoFill, 1
Return
;Gui End

ButtonSearch:

Gui, Submit
FileDelete, %A_ScriptDir%\PossibleWords.txt
LetterCount := StrLen(SearchString)

Lines =
Loop, Read, %A_ScriptDir%\wordlist.txt
	If RegExMatch(A_LoopReadLine, "i)" StrReplace(SearchString, "_", "."))
	&& StrLen(A_LoopReadLine) = LetterCount
	Lines .= SubStr(A_LoopReadLine, 1+InStr(A_LoopReadLine,"/",,0)) "`r`n"
GuiControlGet, vAutoFill
If (AutoFill = 0)
{
	MsgBox, % Lines
	Reload
	Goto, Start
}
Else
GuessTryCount := 1 
FileAppend, %Lines%, %A_ScriptDir%\PossibleWords.txt
Loop, Read, %A_ScriptDir%\PossibleWords.txt
{
	total_lines = %A_Index%
}
If (total_lines > 40)
{
	MsgBox, Too many matches!
	Reload
	Goto, start
}
Else
If (total_lines < 1) 
{
	MsgBox, No matches!
	Reload
	Goto, start 
}
Else 
MsgBox, Press CtrlQ to start guessing. Once you guess correctly, press CtrlE to stop guessing.
Pause

^q:: 
Loop, %total_lines% 
{
	FileReadLine, Guess, %A_ScriptDir%\PossibleWords.txt, %GuessTryCount%
	SendInput, %Guess% {enter}
	GuessTryCount++
	Sleep, 900
}
Reload
Return
^e::
Reload
Return