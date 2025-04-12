import os, rawSnap, strutils, compress

var arguments: seq[string] = @[]

proc red(msg: string, error=true) = 
    echo "\e[31m"&msg&"\e[0m";
    if error:
        quit(1)

proc green(msg: string) = 
    echo "\e[32m" & msg & "\e[0m";
    
proc getArgumentFromN(i: int, default:string="ERROR"):string = 
    if arguments.len >= (i+1):
        let arg = arguments[i];
        return arg
    elif default == "ERROR":
        red("Error: Some arguments are missing")
        quit()
    else:
        return default

proc getArgumentFromName(name: string, default:string="ERROR"): string = 
    var found = false;
    var el = "";
    for arg in arguments:
        if arg.startsWith("--"&name&":"):
            el = arg.replace("--"&name&":", "")
            found = true;
    if found:
        return el
    elif default == "ERROR":
        red("Error: Some arguments are missing")
        quit()
    else:
        return default

proc cli*() = 
    arguments = commandLineParams()

    proc help() = 
        echo """Help still in development..."""

    var command = ""
    if arguments.len() > 0:
        command = arguments[0]
    else:
        help()
        quit(0)


    if command == "raw":
        let filePath = getArgumentFromN(1)
        let targetPath = getArgumentFromName("o", filePath&".snap")
        green "Generating snap from scratch..."
        writeFile(targetPath,compressFile(filePath.extractFilename(),$(rawSnap(filePath))))
        green "Snap generated succesfully at " & targetPath
    else:
        echo "Command does not exist"