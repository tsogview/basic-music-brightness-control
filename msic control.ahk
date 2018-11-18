MsgBox VER1.1`nctrl+shift+{+}向前一曲`n ctrl+shift{-}向后一曲`n ctrl+win+space暂停`n ctrl+win+滚轮音量调节`n win+滚轮调节亮度 `nmade by kasu
^+:: Media_Next
^_:: Media_Prev
^#Space::Media_Play_Pause
^#WheelUp::Volume_Up
^#WheelDown::Volume_Down
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
