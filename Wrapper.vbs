' Create WScript Shell Object to access filesystem.
Set WshShell = WScript.CreateObject("WScript.Shell")
' Start / Run YOSYS.EXE
WshShell.Run "yosys.exe"

' Select, or bring Focus to a window named `TESTABILITY MEARSUREMENT TOOL`
WshShell.AppActivate "YOSYS"

' Wait for 1 second(s)
WScript.Sleep 1000

WshShell.SendKeys "read_verilog uart.v u_rec.v u_xmit.v"
WshShell.SendKeys "{ENTER}"

WshShell.SendKeys "hierarchy -check -top uart"
WshShell.SendKeys "{ENTER}"

WshShell.SendKeys "proc; opt; fsm; opt; memory; opt"
WshShell.SendKeys "{ENTER}"

WshShell.SendKeys "techmap; opt"
WshShell.SendKeys "{ENTER}"

WshShell.SendKeys "write_json Jsonscript.txt"
WshShell.SendKeys "{ENTER}"

' Wait for 5 second(s)
WScript.Sleep 5000

' Start / Run PythonScript
WshShell.Run "Draftfull.py"

' Select, or bring Focus to a window named `PYTHON SCRIPTING`
WshShell.AppActivate "PYTHON"

' Wait for 3 second(s)
WScript.Sleep 3000

' Start / Run ScoapTool.EXE
WshShell.Run "C:\Users\PULKIT\Desktop\Project\scoaptool.exe"

' Select, or bring Focus to a window named `TESTABILITY MEARSUREMENT TOOL`
WshShell.AppActivate "Testability Measurement Tool"

' Wait for 1 second(s)
WScript.Sleep 1000

WshShell.SendKeys "^o" 
WshShell.SendKeys "OutToScoap.txt"
WshShell.SendKeys "{ENTER}"

' Wait for 5 second(s) for the tool to compute the testability values
WScript.Sleep 5000

WshShell.SendKeys "+^s" 
WshShell.SendKeys "output_values.txt"
WshShell.SendKeys "{ENTER}"
