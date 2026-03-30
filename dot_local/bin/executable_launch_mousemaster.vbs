Set WshShell = CreateObject("WScript.Shell")

binPath = WshShell.ExpandEnvironmentStrings("%USERPROFILE%") & "\.local\bin"

WshShell.CurrentDirectory = binPath
WshShell.Run """" & binPath & "\mousemaster.exe""", 0, False
