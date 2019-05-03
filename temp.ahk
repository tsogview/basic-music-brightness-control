^#MButton::
MsgBox 
(
 *VER-2019/3/10 20:50:29
——————————————
ctrl+shift+{+} 向前一曲
ctrl+shift{-} 向后一曲
ctrl+win+space 暂停
——————————————
ctrl+win+roll 音量调节
win+roll 调节亮度 
TTT  快速时间
win+N  写字板
——————————————
*made by kasusa
)
return
^+1::send 12345678@123.com ;用这个设定一下常用字符串！很方便的

^+:: Media_Next
^_:: Media_Prev
^#Space::Media_Play_Pause
^#WheelUp::Volume_Up
^#WheelDown::Volume_Down
#n::Run notepad

::TTT::  ; 此热字串通过后面的命令把 "]d" 替换成当前日期和时间.
FormatTime, CurrentDateTime,, yyyy/M/d H:mm:ss   ; 看起来会像 9/1/2005 3:53 PM 这样
SendInput %CurrentDateTime%
return


#WheelUp::

  AdjustScreenBrightness(4)
  Return

#WheelDown::
  AdjustScreenBrightness(-4)
  Return

AdjustScreenBrightness(step) {
    service := "winmgmts:{impersonationLevel=impersonate}!\\.\root\WMI"
    monitors := ComObjGet(service).ExecQuery("SELECT * FROM WmiMonitorBrightness WHERE Active=TRUE")
    monMethods := ComObjGet(service).ExecQuery("SELECT * FROM wmiMonitorBrightNessMethods WHERE Active=TRUE")
    minBrightness := 5  ; level below this is identical to this

    for i in monitors {
        curt := i.CurrentBrightness
        break
    }
    if (curt < minBrightness)  ; parenthesis is necessary here
        curt := minBrightness
    toSet := curt + step
    if (toSet > 100)
        return
    if (toSet < minBrightness)
        toSet := minBrightness



    for i in monMethods {
        i.WmiSetBrightness(1, toSet)
        break
    }
}
