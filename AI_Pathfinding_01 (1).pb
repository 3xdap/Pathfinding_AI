; AI - LOGIC / Pathfinding
;----------------------------------------------------------------------------------------------------------------------
;
; My attempt at making a AI that moves SMURT.
;
; --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; NOTES:
;
;
; --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; BUGS:
;
;
; --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
OpenConsole()                                                                  ; Open the console.
ConsoleTitle ("AI LOGIC : PATHFINDING")                                        ; Title of application.                                            
EnableGraphicalConsole(1)                                                      ; Enable Graphical Consoles - Allows for greater flexibility.
ConsoleColor(15, 0)                                                            ; Default Console Color. Character color & Background Color.
;IncludeFile "color_table.pbi"                                                 ; Change Console Colors when needed. (not used yet)
; --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; SET THE CONSOLE & WINDOW SIZE
ImportC "msvcrt.lib"
  system(cmd.p-ascii)
EndImport

Global TERMINAL_HORZ.i = 72
Global TERMINAL_VERT.i = 30

ClearConsole()
system("mode "+TERMINAL_HORZ+","+TERMINAL_VERT+"")
; --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Default Console -TEXT- Colors
#TEXT_COLOR_Black = 0
#TEXT_COLOR_Blue = 1
#TEXT_COLOR_Green = 2
#TEXT_COLOR_Cyan = 3
#TEXT_COLOR_Red = 4
#TEXT_COLOR_Magenta = 5
#TEXT_COLOR_Brown = 6
#TEXT_COLOR_LightGrey = 7
#TEXT_COLOR_DarkGrey = 8
#TEXT_COLOR_BrightBlue = 9
#TEXT_COLOR_BrightGreen = 10
#TEXT_COLOR_BrightCyan = 11
#TEXT_COLOR_BrightRed = 12
#TEXT_COLOR_BrightMagenta = 13
#TEXT_COLOR_Yellow = 14
#TEXT_COLOR_White = 15
; --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Global CONSOLE_CURSOR_CURRENT_LOCATION_X.i = 0
Global CONSOLE_CURSOR_CURRENT_LOCATION_Y.i = 0

Global CONSOLE_CURSOR_OLD_LOCATION_X.i = 0
Global CONSOLE_CURSOR_OLD_LOCATION_Y.i = 0

;Resposition the cursor
; This sets the standing location for the Cursor. If you don't do this and move the location the values will be wrong and increment from the current location instead of the actual terminal dimesions.
CONSOLE_CURSOR_CURRENT_LOCATION_X=30  ;36
CONSOLE_CURSOR_CURRENT_LOCATION_Y=25  ;56

;WAIT UNTIL A KEY IS PRESSED.
Procedure.s WaitForKey()
 
  Protected Key$
 
  Repeat
    Key$ = Inkey()
    If key$ = ""
      If RawKey()
        Break
      Else
        Delay(10)
      EndIf
    EndIf
   
  Until Key$ <> ""
 
  ProcedureReturn Key$
 
EndProcedure


Procedure SHOW_CURSOR_CURRENT_LOCATION()
  
ConsoleLocate(CONSOLE_CURSOR_CURRENT_LOCATION_X,CONSOLE_CURSOR_CURRENT_LOCATION_Y) 
Print("x")  
  
  EndProcedure
  
  
Procedure PASS_OLD_LOCATION_INTO_MEMORY()
    
CONSOLE_CURSOR_OLD_LOCATION_X =  CONSOLE_CURSOR_CURRENT_LOCATION_X
CONSOLE_CURSOR_OLD_LOCATION_Y = CONSOLE_CURSOR_CURRENT_LOCATION_Y  

EndProcedure

;#TRUETYPE_FONTTYPE

#False = 0
#True = 1

Global AI_LOGIC_CAN_GO_UP.b     = #False
Global AI_LOGIC_CAN_GO_DOWN.b   = #False
Global AI_LOGIC_CAN_GO_LEFT.b   = #False
Global AI_LOGIC_CAN_GO_RIGHT.b   = #False

Global AI_LOGIC_AM_I_IN_LINE_WITH_X.b   = #False
Global AI_LOGIC_AM_I_IN_LINE_WITH_Y.b   = #False

Global AI_LOGIC_FIRED_TRACER_DOWNWARD.b = #False ;checks to see if a tracer has been fired. Only do this ONCE for every key press.
Global AI_TRACER_DOWNWARD_X.i = 0
Global AI_TRACER_DOWNWARD_Y.i = 0

Global AI_LOGIC_FIRED_TRACER_UPWARD.b   = #False
Global AI_TRACER_UPWARD_X.i = 0
Global AI_TRACER_UPWARD_Y.i = 0

Global AI_LOGIC_FIRED_TRACER_LEFT.b     = #False
Global AI_TRACER_LEFT_X.i = 0
Global AI_TRACER_LEFT_Y.i = 0

Global AI_LOGIC_FIRED_TRACER_RIGHT.b    = #False
Global AI_TRACER_RIGHT_X.i = 0
Global AI_TRACER_RIGHT_Y.i = 0

Global AI_LOGIC_I_AM_FROZEN.b = #False

Global AI_SEEKER_TRACER_X.b = 0
Global AI_SEEKER_TRACER_Y.b = 0

Global AI_CURRENT_LOCATION_X.b = 36
Global AI_CURRENT_LOCATION_Y.b = 5

Global AI_PREVIOUS_LOCATION_X.b = 0
Global AI_PREVIOUS_LOCATION_Y.b = 0

Global AI_TARGET_X_LOCATION.b = 0 ;have it pick either PLAYERS or COMPANIONS
Global AI_TARGET_Y_LOCATION.b = 0 



;--- Finding the shortest distance between the Cursor and Enemy
Global X_DIFFERENCE.i = 0
Global Y_DIFFERENCE.i = 0

Global DISTANCE_X_TARGET.i = 0
Global DISTANCE_Y_TARGET.i = 0

Global PLAYER_X_LOCATION.b = 0
Global PLAYER_Y_LOCATION.b = 0



Procedure UPDATE_ENEMY_POSITION()
  
  
  
EndProcedure


Procedure DRAW_ENEMY_SPRITE()
  
ConsoleLocate(AI_CURRENT_LOCATION_X,AI_CURRENT_LOCATION_Y) 
Print("☻")  
 
EndProcedure
  


;/////////////////////////////////////////////////////////////////////// MAIN LOOP ////////////////////////////////////////////////////////////////////////////
BEGIN_LOOP:
;X distance from target
DISTANCE_X_TARGET = CONSOLE_CURSOR_CURRENT_LOCATION_X - AI_CURRENT_LOCATION_X
;Y distance from target
DISTANCE_Y_TARGET = CONSOLE_CURSOR_CURRENT_LOCATION_Y - AI_CURRENT_LOCATION_Y
ClearConsole()

ConsoleLocate(0,0)
ConsoleCursor(0)

ConsoleColor(#TEXT_COLOR_White,#TEXT_COLOR_Black)
SHOW_CURSOR_CURRENT_LOCATION()

;update cursor position UI
ConsoleLocate(40,0)
Print("Cursor X:"+CONSOLE_CURSOR_CURRENT_LOCATION_X+" Y:"+CONSOLE_CURSOR_CURRENT_LOCATION_Y+"")

;display previous cursor coordinates
ConsoleLocate(43,1)  
Print("Old X:"+CONSOLE_CURSOR_OLD_LOCATION_X+"")
ConsoleLocate(52,1)  
Print("Y:"+CONSOLE_CURSOR_OLD_LOCATION_Y+"")

;X distance from target
;DISTANCE_X_TARGET = CONSOLE_CURSOR_CURRENT_LOCATION_X - AI_CURRENT_LOCATION_X

;Y distance from target
;DISTANCE_Y_TARGET = CONSOLE_CURSOR_CURRENT_LOCATION_Y - AI_CURRENT_LOCATION_Y

;ConsoleLocate(58,0)  
;Print("Dist:"+DISTANCE_X_TARGET+"")
;ConsoleLocate(58,1)  
;Print("Dist:"+DISTANCE_Y_TARGET+"")

;draw text cursor at new position
;ConsoleCursor(10)
ConsoleLocate(CONSOLE_CURSOR_CURRENT_LOCATION_X,CONSOLE_CURSOR_CURRENT_LOCATION_Y)

ConsoleLocate(43,2)
If DISTANCE_X_TARGET <DISTANCE_Y_TARGET   ;<---- does not work right
Print("X distance shorter") 
Else
Print("Y distance shorter") 
EndIf

If AI_LOGIC_I_AM_FROZEN = #False
ConsoleLocate(24,0)  
Print("Enemy can Move")
  ;Update Enemy Position if it has changed.
  If AI_CURRENT_LOCATION_X < CONSOLE_CURSOR_CURRENT_LOCATION_X And AI_CURRENT_LOCATION_X <> CONSOLE_CURSOR_CURRENT_LOCATION_X ;And DISTANCE_X_TARGET < DISTANCE_Y_TARGET
  AI_CURRENT_LOCATION_X + 1  
  ElseIf AI_CURRENT_LOCATION_X > CONSOLE_CURSOR_CURRENT_LOCATION_X And AI_CURRENT_LOCATION_X <> CONSOLE_CURSOR_CURRENT_LOCATION_X ;And DISTANCE_X_TARGET > DISTANCE_Y_TARGET
  AI_CURRENT_LOCATION_X - 1
  ElseIf AI_CURRENT_LOCATION_Y < CONSOLE_CURSOR_CURRENT_LOCATION_Y And AI_CURRENT_LOCATION_Y <> CONSOLE_CURSOR_CURRENT_LOCATION_Y; And DISTANCE_Y_TARGET < DISTANCE_X_TARGET
  AI_CURRENT_LOCATION_Y + 1  
  ElseIf AI_CURRENT_LOCATION_Y > CONSOLE_CURSOR_CURRENT_LOCATION_Y And AI_CURRENT_LOCATION_Y <> CONSOLE_CURSOR_CURRENT_LOCATION_Y ;And DISTANCE_Y_TARGET > DISTANCE_X_TARGET
  AI_CURRENT_LOCATION_Y - 1 
EndIf

Else
ConsoleLocate(24,0)  
Print("Enemy FROZEN   ")
EndIf

;X distance from target
;DISTANCE_X_TARGET = CONSOLE_CURSOR_CURRENT_LOCATION_X - AI_CURRENT_LOCATION_X

;Y distance from target
;DISTANCE_Y_TARGET = CONSOLE_CURSOR_CURRENT_LOCATION_Y - AI_CURRENT_LOCATION_Y

ConsoleLocate(58,0)  
Print("Dist:"+DISTANCE_X_TARGET+"")
ConsoleLocate(58,1)  
Print("Dist:"+DISTANCE_Y_TARGET+"")


ConsoleCursor(0)
ConsoleColor(#TEXT_COLOR_BrightRed,#TEXT_COLOR_Black)
DRAW_ENEMY_SPRITE()

;Place the bullet in the same location as the Enemy (REDUNDANT !)
AI_SEEKER_TRACER_X = AI_CURRENT_LOCATION_X
AI_SEEKER_TRACER_Y = AI_CURRENT_LOCATION_Y

;Check to see if the enemy is lined up with the Cursor location
If AI_CURRENT_LOCATION_X = CONSOLE_CURSOR_CURRENT_LOCATION_X
ConsoleLocate(4,0)  
Print("Aligned X")
AI_LOGIC_AM_I_IN_LINE_WITH_X = #True
Else
ConsoleLocate(4,0)
AI_LOGIC_AM_I_IN_LINE_WITH_X = #False
Print("         ")
EndIf

If AI_CURRENT_LOCATION_Y = CONSOLE_CURSOR_CURRENT_LOCATION_Y
ConsoleLocate(14,0)  
Print("Aligned Y")
AI_LOGIC_AM_I_IN_LINE_WITH_Y = #True
Else
ConsoleLocate(14,0)
AI_LOGIC_AM_I_IN_LINE_WITH_Y = #False
Print("         ")
EndIf

;Fire Tracers in All Directions (Have them all start at current location of the Enemy)
ConsoleLocate(1,1)
Print("ALIGNMENT TRACER")

AI_TRACER_DOWNWARD_X = AI_CURRENT_LOCATION_X
AI_TRACER_DOWNWARD_Y = AI_CURRENT_LOCATION_Y

AI_TRACER_UPWARD_X.i = AI_CURRENT_LOCATION_X
AI_TRACER_UPWARD_Y.i = AI_CURRENT_LOCATION_Y

AI_TRACER_LEFT_X.i = AI_CURRENT_LOCATION_X
AI_TRACER_LEFT_Y.i = AI_CURRENT_LOCATION_Y

AI_TRACER_RIGHT_X.i = AI_CURRENT_LOCATION_X
AI_TRACER_RIGHT_Y.i = AI_CURRENT_LOCATION_Y

  Repeat
  AI_TRACER_DOWNWARD_Y + 1
  ConsoleLocate(AI_TRACER_DOWNWARD_X,AI_TRACER_DOWNWARD_Y)
  Print(".")
  Delay(2)
  Until AI_TRACER_DOWNWARD_Y = 30 ;(edge of the terminal is hit)


  Repeat
  AI_TRACER_UPWARD_Y - 1
  ConsoleLocate(AI_TRACER_UPWARD_X,AI_TRACER_UPWARD_Y)
  Print(".")
  Delay(2)
  Until AI_TRACER_UPWARD_Y = 0 ;(edge of the terminal is hit)


  Repeat
  AI_TRACER_RIGHT_X + 1
  ConsoleLocate(AI_TRACER_RIGHT_X,AI_TRACER_RIGHT_Y)
  Print(".")
  Delay(2)
  Until AI_TRACER_RIGHT_X = 72 ;(edge of the terminal is hit)
  
  
  Repeat
  AI_TRACER_LEFT_X - 1
  ConsoleLocate(AI_TRACER_LEFT_X,AI_TRACER_LEFT_Y)
  Print(".")
  Delay(2)
  Until AI_TRACER_LEFT_X = 0 ;(edge of the terminal is hit)

;reset tracer bullets to be used again
AI_TRACER_DOWNWARD_X = AI_CURRENT_LOCATION_X
AI_TRACER_DOWNWARD_Y = AI_CURRENT_LOCATION_Y

AI_TRACER_UPWARD_X.i = AI_CURRENT_LOCATION_X
AI_TRACER_UPWARD_Y.i = AI_CURRENT_LOCATION_Y

AI_TRACER_LEFT_X.i = AI_CURRENT_LOCATION_X
AI_TRACER_LEFT_Y.i = AI_CURRENT_LOCATION_Y

AI_TRACER_RIGHT_X.i = AI_CURRENT_LOCATION_X
AI_TRACER_RIGHT_Y.i = AI_CURRENT_LOCATION_Y

;Fire Pathfinding for any solid objects near enemy.
ConsoleLocate(1,2)
ConsoleColor(#TEXT_COLOR_Yellow,#TEXT_COLOR_Black)
Print("SOLID OBJECT CHECK")

AI_TRACER_DOWNWARD_Y + 1
ConsoleLocate(AI_TRACER_DOWNWARD_X,AI_TRACER_DOWNWARD_Y)
Print("▼")

AI_TRACER_UPWARD_Y - 1
ConsoleLocate(AI_TRACER_UPWARD_X,AI_TRACER_UPWARD_Y)
Print("▲")

AI_TRACER_LEFT_X - 1
ConsoleLocate(AI_TRACER_LEFT_X,AI_TRACER_LEFT_Y)
Print("◄")

AI_TRACER_RIGHT_X + 1
ConsoleLocate(AI_TRACER_RIGHT_X,AI_TRACER_RIGHT_Y)
Print("►")

Delay(20)

;Fire Pathfinding Check in direction of Target for shortest route (Which is this case is Player)
;
;
;
; still need to do this
;
;
;
;

;---------------------------------------- FOR - TEST CODE
For Y = 10 To 20
ConsoleLocate(10,Y)
Delay(80)
Print(".")
X+1
Next


For X = 10 To 20
ConsoleLocate(X,20)
Delay(80)
Print(".")
X+1
Next
;----------------------------------------



ConsoleColor(#TEXT_COLOR_White,#TEXT_COLOR_Black)
SHOW_CURSOR_CURRENT_LOCATION()
ConsoleCursor(10)
ConsoleLocate(0,0)
;>>>>>>>>>>>>>>>>>>>>>>> STATE MACHINE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< [START]
BEGIN_STATE_MACHINE:

; FIRE TRACER TEST
;--------------------------
 ;If AI_LOGIC_AM_I_IN_LINE_WITH_X = #True And AI_LOGIC_FIRED_TRACER_DOWNWARD = #False

  ;Repeat
  ;AI_SEEKER_TRACER_Y + 1
  ;;ClearConsole()
  ;ConsoleLocate(AI_SEEKER_TRACER_X,AI_SEEKER_TRACER_Y)
  ;Delay(100)
  ;Print(".")
  ;Until AI_SEEKER_TRACER_Y = 30
  ;AI_SEEKER_TRACER_Y = AI_CURRENT_LOCATION_Y ;reset bullet
  ;AI_LOGIC_FIRED_TRACER_DOWNWARD = #True
  ;EndIf

KeyPressed$ = Inkey()
      
If KeyPressed$ <> ""
  
  ;AI_LOGIC_FIRED_TRACER_DOWNWARD = #False

       ; Exit Key
       If Str(RawKey()) = "27"
         End
       EndIf
       
       ; F Key
       If Str(RawKey()) = "70" And AI_LOGIC_I_AM_FROZEN = #False
         AI_LOGIC_I_AM_FROZEN = #True
         PASS_OLD_LOCATION_INTO_MEMORY()
         Goto BEGIN_LOOP
       ElseIf Str(RawKey()) = "70" And AI_LOGIC_I_AM_FROZEN = #True
         PASS_OLD_LOCATION_INTO_MEMORY()
         AI_LOGIC_I_AM_FROZEN = #False
         Goto BEGIN_LOOP
       EndIf
   
     ElseIf RawKey()
       
        ;------------------------------------------------------------
        ; UP Arrow key (works also if numlock is off)
        ;------------------------------------------------------------
        If Str(RawKey()) = "38"
        PASS_OLD_LOCATION_INTO_MEMORY()
        CONSOLE_CURSOR_CURRENT_LOCATION_Y - 1
        ;ConsoleCursor(0)
        ConsoleLocate(40,0)
        Print("Cursor                                 ")
        Goto BEGIN_LOOP
        EndIf
        ;------------------------------------------------------------
        ; DOWN Arrow key
        ;------------------------------------------------------------
        If Str(RawKey()) = "40"
        PASS_OLD_LOCATION_INTO_MEMORY()
        CONSOLE_CURSOR_CURRENT_LOCATION_Y + 1
        ;ConsoleCursor(0)
        ConsoleLocate(40,0)
        Print("Cursor                                 ")
        Goto BEGIN_LOOP 
        EndIf
        ;------------------------------------------------------------
        ; LEFT Arrow key 
        ;------------------------------------------------------------
        If Str(RawKey()) = "37"
        PASS_OLD_LOCATION_INTO_MEMORY()
        CONSOLE_CURSOR_CURRENT_LOCATION_X - 1
        ;ConsoleCursor(0)
        ConsoleLocate(40,0)
        Print("Cursor                                 ")
        Goto BEGIN_LOOP
        EndIf
        ;------------------------------------------------------------
        ; RIGHT Arrow key 
        ;------------------------------------------------------------
        If Str(RawKey()) = "39"
        PASS_OLD_LOCATION_INTO_MEMORY()
        CONSOLE_CURSOR_CURRENT_LOCATION_X + 1
        ;ConsoleCursor(0)
        ConsoleLocate(40,0)
        Print("Cursor                                 ")
        Goto BEGIN_LOOP
        EndIf
        ;------------------------------------------------------------

        EndIf
        
; TIMING OF THE STATE MACHINE - ! IMPORTANT !  
Delay(80) ; keep timing to this or else you will see the cursor flickering between all the screen re-draws and repositioning.
Goto BEGIN_STATE_MACHINE
;>>>>>>>>>>>>>>>>>>>>>>> STATE MACHINE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< [END]
; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 380
; FirstLine = 425
; Folding = -
; EnableXP
; Executable = C:\Users\Infernus\Music\AI_Pathfinding_test.exe