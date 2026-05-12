Set WshShell = CreateObject("WScript.Shell")

binPath = WshShell.ExpandEnvironmentStrings("%USERPROFILE%") & "\AppData\Local\Microsoft\WinGet\Links"
repoPath = WshShell.ExpandEnvironmentStrings("%USERPROFILE%") & "\things\repos"

WshShell.CurrentDirectory = repoPath
WshShell.Run """" & binPath & "\mise.exe""" & " exec -- opencode serve --port 6767 --hostname 0.0.0.0", 0, False
