#SingleInstance, Force
#NoEnv

Menu, Tray, Icon, %A_ScriptDir%/resources/stopwatch.ico, , 0

rscrn := A_ScreenWidth-300

Gui , Timer:Show , w165 h88 X%rscrn% Y0, StopWatch
Gui , Timer: +hwndguiId +AlwaysOnTop +ToolWindow 
Gui , Timer:Font , s10 , Trebuchet MS                       

;   ===========================================================
Gui , Timer:Add , Button , gStart   x0 y0 w80 h22 center vbStart, Start
Gui , Timer:Add , Button , gResume x80 y0 w85 h22 center vbPause, Pause
;   ===========================================================
Gui , Timer:add, text      , vtStartTime        x1 y22 w58 ,                 ; This is the time the timer last started.
Gui , Timer:Add, Checkbox  , gMuteSoundToggle  x70 y21 center Checked ,      ; Mute sound notification
Gui , Timer:add, text      , vtPausedTime     x110 y22 w58 ,                 ; This time when the timer ended.
;   ===========================================================
Gui , Timer:Font, s26 cBlue , Segoe UI
Gui , Timer:add , text , gResume x0 y36 w160 h38 center vtTimerText,  00:00:00
;   ===========================================================
bMuteSoundFlag := 0

;return   ;=== Uncomment this if the stopwatch should not autostart
 
Start:
   togglePauseResume:=1
   Gui , Submit , NoHide
  ; GuiControl ,, bStart, Re-Start
  ; GuiControl ,, bPause, Pause
  ; GuiControl , Timer:text , tPausedTime ,
   Gui , Timer:Font , s26 cBlue , Segoe UI
   GuiControl , Timer:Font , tTimerText
   secsCounted :=  0
   
  
   GuiControl , Timer:text , tTimerText , 00:00:00   
   FormatTime , currTimeStr, , HH:mm:ss               
   GuiControl , Timer:text , tStartTime , %currTimeStr%
   GuiControl , Timer:text , tPausedTime ,
   
   SetTimer , CDTimer , 1000   
return

Resume:
  SetTimer, CDTimer, % (togglePauseResume:=!togglePauseResume) ? "on":"off"
  
   IfEqual, togglePauseResume,1
   {
     GuiControl ,, bPause, Pause
     GuiControl , Timer:text , tPausedTime , 
     
   }
   else 
   {
    GuiControl ,, bPause, Resume       
    FormatTime , currTimeStr, , HH:mm:ss               
    GuiControl , Timer:text , tPausedTime , %currTimeStr%
   }
return

CDTimer:
   secsCounted++
   ;secsCounted:= secsCounted +30                                  ; This is used to make screenshots
   
   hur := Format("{:02}" , floor(abs(secsCounted)/3600))           ;display
   min := Format("{:02}" , floor(mod(abs(secsCounted/60),60)))
   sec := Format("{:02}" , floor(mod(abs(secsCounted), 60)))
   
  
   if Mod(secsCounted, 120) == 0
   {
      Gui , Timer:Font , s26 cRed bold , Segoe UI
      GuiControl , Timer:Font , tTimerText
      GuiControl , Timer:text , tTimerText, %hur%:%min%:%sec%
      IfEqual, bMuteSoundFlag, 1 
      {
        SoundBeep, 750, 1000
        secsCounted++                          ; Skip 1 second as the sound took 1 second
      }
   }
   else
   {
      Gui , Timer:Font , s26 cBlue  norm, Segoe UI
      GuiControl , Timer:Font , tTimerText
      GuiControl , Timer:text , tTimerText, %hur%:%min%:%sec%
   }
return

MuteSoundToggle:
  bMuteSoundFlag := NOT bMuteSoundFlag
return

TimerGuiClose:
ExitApp