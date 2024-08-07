# Battlefront Overhaul Mod: CTF Script

The [`bom_ctf.lua`](bom_ctf.lua) script contains simplified functions for creating CTF game modes. Templates are provided for using the script in both 1-flag and 2-flag CTF. 

### 1-Flag CTF Simplicity

- 19 parameters set -> 6 parameter set

### 2-Flag CTF Simplicity

- 9 function calls -> 2 function calls
- 37 parameters set -> 8 parameters set

> [!NOTE]
> Logging is implemented for when functions complete successfully. If required variables are missing, errors will be thrown that inform you of what was missed.

## To install:
1. Move `bom_ctf.lau` to `data_ABC\Common\Scripts\`, where "data_ABC is your project 
	folder in BF2_ModTools
2. Open `data_ABC\Common\mission.req` and add `"bom_ctf"` to the section:
    ```
    REQN
  	{
       "script"
       ...
    
       "bom_ctf"
    }
3. For an example on setting up 1-flag CTF, view [`template_1flag.lua`](template_1flag.lua). For an example on setting up 2-flag CTF, view [`template_2flag.lua`](template_2flag.lua).

> [!IMPORTANT]
> Remember to call `ScriptCB_DoFile("bom_ctf")` near the top of your mission script!

For questions or comments, email toothpaste.main@gmail.com or message on Twitter @ToothpasteMain
