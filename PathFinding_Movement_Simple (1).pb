; AI - LOGIC / Pathfinding - Simple Version
;----------------------------------------------------------------------------------------------------------------------
;
; My attempt at making a simplier form of pathfinding.
; Instead of using tracers that fire all around checking the path, the Enemy only needs to know if the direction it is heading in is solid.
; If it is solid, check another direction to see if it is solid or not.
; If it is solid keeping checking until no solid is found.
; If a clear path is found, is it the shortest to its target? If not then choose which path is shortest.
;
; --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; NOTES:
;
;
; --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; BUGS:
;
; Tracer bullets draw endlessly if Enemy moves to any coordinate on the edge of the screen.
; I think this happens because the Tracer check goes negative and does not catch the value set on the movement value.
;
; --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
OpenConsole()                                                                  ; Open the console.
ConsoleTitle ("AI LOGIC : PATHFINDING - SIMPLE MOVEMENT")                      ; Title of application.                                            
EnableGraphicalConsole(1)                                                      ; Enable Graphical Consoles - Allows for greater flexibility.
ConsoleColor(15, 0)                                                            ; Default Console Color. Character color & Background Color.
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

#False = 0
#True  = 1

#OBJECT_NOT_SOLID = 0
#OBJECT_IS_SOLID  = 1

Global AI_LOGIC_CAN_GO_UP.b     = 2
Global AI_LOGIC_CAN_GO_DOWN.b   = 2
Global AI_LOGIC_CAN_GO_LEFT.b   = 2
Global AI_LOGIC_CAN_GO_RIGHT.b  = 2

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
Global AI_CURRENT_LOCATION_Y.b = 4

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


Procedure SHOW_TRACER_TIPS();//marks if a solid is being touched or not
  
  
ConsoleLocate(AI_TRACER_DOWNWARD_X,AI_TRACER_DOWNWARD_Y)
If AI_LOGIC_CAN_GO_DOWN = 2
  ConsoleColor(#TEXT_COLOR_Yellow,#TEXT_COLOR_Black)
Else
  ConsoleColor(#TEXT_COLOR_Red,#TEXT_COLOR_Black)
EndIf
Print("▼")

ConsoleLocate(AI_TRACER_UPWARD_X,AI_TRACER_UPWARD_Y)
If AI_LOGIC_CAN_GO_UP = 2
  ConsoleColor(#TEXT_COLOR_Yellow,#TEXT_COLOR_Black)
Else
  ConsoleColor(#TEXT_COLOR_Red,#TEXT_COLOR_Black)
EndIf
Print("▲")

ConsoleLocate(AI_TRACER_RIGHT_X,AI_TRACER_RIGHT_Y)
If AI_LOGIC_CAN_GO_RIGHT = 2
  ConsoleColor(#TEXT_COLOR_Yellow,#TEXT_COLOR_Black)
Else
  ConsoleColor(#TEXT_COLOR_Red,#TEXT_COLOR_Black)
EndIf
Print("►")

ConsoleLocate(AI_TRACER_LEFT_X,AI_TRACER_LEFT_Y)
If AI_LOGIC_CAN_GO_LEFT = 2
  ConsoleColor(#TEXT_COLOR_Yellow,#TEXT_COLOR_Black)
Else
  ConsoleColor(#TEXT_COLOR_Red,#TEXT_COLOR_Black)
EndIf
Print("◄")  
  
  
  EndProcedure


Procedure DRAW_ENEMY_SPRITE();//show the enemy on the screen
  
ConsoleLocate(AI_CURRENT_LOCATION_X,AI_CURRENT_LOCATION_Y) 
Print("☻")  
 
EndProcedure

Global SOLID_OBJECT_TEST_X.b = 36
Global SOLID_OBJECT_TEST_Y.b = 6


Global SOLID_OBJECT_02_X.b = 36
Global SOLID_OBJECT_02_Y.b = 7


Global SOLID_OBJECT_X_03.b = 36
Global SOLID_OBJECT_Y_03.b = 8

Global SOLID_OBJECT_X_04.b = 37
Global SOLID_OBJECT_Y_04.b = 6

Procedure DRAW_ANY_SOLID_OBJECTS_ON_SCREEN();//draw some objects at these locations
  
ConsoleLocate(SOLID_OBJECT_TEST_X,SOLID_OBJECT_TEST_Y) 
Print("█")  


ConsoleLocate(SOLID_OBJECT_02_X,SOLID_OBJECT_02_Y) 
Print("█")  


ConsoleLocate(SOLID_OBJECT_X_03,SOLID_OBJECT_Y_03) 
Print("█") 


ConsoleLocate(SOLID_OBJECT_X_04,SOLID_OBJECT_Y_04) 
Print("█")  
  
EndProcedure



Procedure PROCESS_ALL_COLLISIONS_IF_ANY();//Check for some collisions
TEMP_OBJECT_X = SOLID_OBJECT_TEST_X
TEMP_OBJECT_Y = SOLID_OBJECT_TEST_Y
  
If AI_TRACER_DOWNWARD_X = TEMP_OBJECT_X And AI_TRACER_DOWNWARD_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_DOWN = 1
EndIf

If AI_TRACER_UPWARD_X = TEMP_OBJECT_X And AI_TRACER_UPWARD_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_UP = 1
EndIf

If AI_TRACER_RIGHT_X = TEMP_OBJECT_X And AI_TRACER_RIGHT_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_RIGHT = 1
EndIf

If AI_TRACER_LEFT_X = TEMP_OBJECT_X And AI_TRACER_LEFT_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_LEFT = 1
EndIf

TEMP_OBJECT_X = SOLID_OBJECT_02_X
TEMP_OBJECT_Y = SOLID_OBJECT_02_Y
 
If AI_TRACER_DOWNWARD_X = TEMP_OBJECT_X And AI_TRACER_DOWNWARD_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_DOWN = 1
EndIf

If AI_TRACER_UPWARD_X = TEMP_OBJECT_X And AI_TRACER_UPWARD_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_UP = 1
EndIf

If AI_TRACER_RIGHT_X = TEMP_OBJECT_X And AI_TRACER_RIGHT_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_RIGHT = 1
EndIf

If AI_TRACER_LEFT_X = TEMP_OBJECT_X And AI_TRACER_LEFT_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_LEFT = 1
EndIf

TEMP_OBJECT_X = SOLID_OBJECT_X_03
TEMP_OBJECT_Y = SOLID_OBJECT_Y_03

If AI_TRACER_DOWNWARD_X = TEMP_OBJECT_X And AI_TRACER_DOWNWARD_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_DOWN = 1
EndIf

If AI_TRACER_UPWARD_X = TEMP_OBJECT_X And AI_TRACER_UPWARD_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_UP = 1
EndIf

If AI_TRACER_RIGHT_X = TEMP_OBJECT_X And AI_TRACER_RIGHT_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_RIGHT = 1
EndIf

If AI_TRACER_LEFT_X = TEMP_OBJECT_X And AI_TRACER_LEFT_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_LEFT = 1
EndIf

TEMP_OBJECT_X = SOLID_OBJECT_X_04
TEMP_OBJECT_Y = SOLID_OBJECT_Y_04

If AI_TRACER_DOWNWARD_X = TEMP_OBJECT_X And AI_TRACER_DOWNWARD_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_DOWN = 1
EndIf

If AI_TRACER_UPWARD_X = TEMP_OBJECT_X And AI_TRACER_UPWARD_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_UP = 1
EndIf

If AI_TRACER_RIGHT_X = TEMP_OBJECT_X And AI_TRACER_RIGHT_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_RIGHT = 1
EndIf

If AI_TRACER_LEFT_X = TEMP_OBJECT_X And AI_TRACER_LEFT_Y = TEMP_OBJECT_Y
   AI_LOGIC_CAN_GO_LEFT = 1
EndIf

 
  EndProcedure
  
  
Global ENEMY_ONLY_ONE_WAY_OUT.b = #False  
  
Procedure CHECK_IF_AI_HAS_ONLY_ONE_FREE_DIRECTION();// Logic for if the Enemy gets stuck. (I do not think this works)
    
;additional conditions - if AI is stuck or blocked
          
           If AI_LOGIC_CAN_GO_RIGHT = 1 And AI_LOGIC_CAN_GO_LEFT = 1 And AI_LOGIC_CAN_GO_UP = 1
             AI_CURRENT_LOCATION_Y + 1 ;only  free way to move is DOWN
             ENEMY_ONLY_ONE_WAY_OUT = #True 
           EndIf
         
           If AI_LOGIC_CAN_GO_RIGHT = 1 And AI_LOGIC_CAN_GO_LEFT = 1 And AI_LOGIC_CAN_GO_DOWN = 1
             AI_CURRENT_LOCATION_Y - 1 ;only  free way to move is UP
             ENEMY_ONLY_ONE_WAY_OUT = #True 
           EndIf
          
           If AI_LOGIC_CAN_GO_UP = 1 And AI_LOGIC_CAN_GO_DOWN = 1 And AI_LOGIC_CAN_GO_RIGHT = 1
             AI_CURRENT_LOCATION_X - 1 ;only  free way to move is LEFT
             ENEMY_ONLY_ONE_WAY_OUT = #True 
           EndIf

           If AI_LOGIC_CAN_GO_UP = 1 And AI_LOGIC_CAN_GO_DOWN = 1 And AI_LOGIC_CAN_GO_LEFT = 1
             AI_CURRENT_LOCATION_X + 1 ;only  free way to move is RIGHT
             ENEMY_ONLY_ONE_WAY_OUT = #True 
           EndIf
    
    EndProcedure
    
    
Global NEXT_TURN_MOVE_UP.b = #False 
    
Procedure CHECK_IF_ABOVE_IS_BLOCKED_BUT_LEFT_IS_FREE_NEXT_TURN_MOVE_UP_IF_POSSIBLE();// -NOT FINISHED-
  If AI_LOGIC_CAN_GO_UP = 1 And  AI_LOGIC_CAN_GO_LEFT <> 1
    
  EndIf
  
  
  
  
      
EndProcedure
    

;/////////////////////////////////////////////////////////////////////// MAIN LOOP ////////////////////////////////////////////////////////////////////////////
BEGIN_LOOP:
  
;reset state - for 1 frame
;AI_LOGIC_CAN_GO_DOWN    = 2
;AI_LOGIC_CAN_GO_UP      = 2
;AI_LOGIC_CAN_GO_RIGHT   = 2
;AI_LOGIC_CAN_GO_LEFT    = 2 
 
  
;X distance from target
DISTANCE_X_TARGET = CONSOLE_CURSOR_CURRENT_LOCATION_X - AI_CURRENT_LOCATION_X
;Y distance from target
DISTANCE_Y_TARGET = CONSOLE_CURSOR_CURRENT_LOCATION_Y - AI_CURRENT_LOCATION_Y
ClearConsole()


PROCESS_ALL_COLLISIONS_IF_ANY()

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

;blank the cursor
ConsoleCursor(0)
ConsoleColor(#TEXT_COLOR_BrightRed,#TEXT_COLOR_Black)

;enemy coordinates
ConsoleLocate(1,0)
Print("X:"+AI_CURRENT_LOCATION_X+" Y:"+AI_CURRENT_LOCATION_Y+"")

;MOVING THE ENEMY CHARACTER - LOGIC
If AI_LOGIC_I_AM_FROZEN = #False
  
  
  If AI_CURRENT_LOCATION_X < CONSOLE_CURSOR_CURRENT_LOCATION_X And AI_CURRENT_LOCATION_X <> CONSOLE_CURSOR_CURRENT_LOCATION_X ;//RIGHT
    
            CHECK_IF_AI_HAS_ONLY_ONE_FREE_DIRECTION()
            
            If ENEMY_ONLY_ONE_WAY_OUT = #True
            Goto BREAKOUT
            EndIf
            
            
            If AI_LOGIC_CAN_GO_RIGHT <> 1
            AI_CURRENT_LOCATION_X + 1
            Goto BREAKOUT
            Else
    
              If AI_LOGIC_CAN_GO_DOWN <> 1
              AI_CURRENT_LOCATION_Y + 1
              Goto BREAKOUT
              EndIf
          
              If AI_LOGIC_CAN_GO_LEFT <> 1
              AI_CURRENT_LOCATION_X - 1
              Goto BREAKOUT
              EndIf
                   
              If AI_LOGIC_CAN_GO_UP <> 1
              AI_CURRENT_LOCATION_Y - 1
              Goto BREAKOUT
              EndIf
          
            EndIf

  ElseIf AI_CURRENT_LOCATION_X > CONSOLE_CURSOR_CURRENT_LOCATION_X And AI_CURRENT_LOCATION_X <> CONSOLE_CURSOR_CURRENT_LOCATION_X ;//LEFT
    
            CHECK_IF_AI_HAS_ONLY_ONE_FREE_DIRECTION()
            
            If ENEMY_ONLY_ONE_WAY_OUT = #True
            Goto BREAKOUT
            EndIf
             
            If AI_LOGIC_CAN_GO_LEFT <> 1
            AI_CURRENT_LOCATION_X - 1
            Goto BREAKOUT
            Else
            
    
              If AI_LOGIC_CAN_GO_UP <> 1
              AI_CURRENT_LOCATION_Y - 1
              Goto BREAKOUT
              EndIf
            
              If AI_LOGIC_CAN_GO_DOWN <> 1
              AI_CURRENT_LOCATION_Y + 1
              Goto BREAKOUT
              EndIf
          
              If AI_LOGIC_CAN_GO_RIGHT <> 1
              AI_CURRENT_LOCATION_X + 1
              Goto BREAKOUT
              EndIf
            
          EndIf
          
          
    
  ElseIf AI_CURRENT_LOCATION_Y < CONSOLE_CURSOR_CURRENT_LOCATION_Y And AI_CURRENT_LOCATION_Y <> CONSOLE_CURSOR_CURRENT_LOCATION_Y ;//DOWN
    
            CHECK_IF_AI_HAS_ONLY_ONE_FREE_DIRECTION()
            
            If ENEMY_ONLY_ONE_WAY_OUT = #True
            Goto BREAKOUT
            EndIf
             
            If AI_LOGIC_CAN_GO_DOWN <> 1
            AI_CURRENT_LOCATION_Y + 1
            Goto BREAKOUT
            Else

              If AI_LOGIC_CAN_GO_UP <> 1
              AI_CURRENT_LOCATION_Y - 1
              Goto BREAKOUT
              EndIf

              If AI_LOGIC_CAN_GO_RIGHT <> 1
              AI_CURRENT_LOCATION_X + 1
              Goto BREAKOUT
              EndIf 
                          
              If AI_LOGIC_CAN_GO_LEFT <> 1
              AI_CURRENT_LOCATION_X - 1
              Goto BREAKOUT
              EndIf
            
            
          EndIf
        
          ElseIf AI_CURRENT_LOCATION_Y > CONSOLE_CURSOR_CURRENT_LOCATION_Y And AI_CURRENT_LOCATION_Y <> CONSOLE_CURSOR_CURRENT_LOCATION_Y ;//UP
            
            CHECK_IF_AI_HAS_ONLY_ONE_FREE_DIRECTION()
            
            If ENEMY_ONLY_ONE_WAY_OUT = #True
            Goto BREAKOUT
            EndIf
             
            If AI_LOGIC_CAN_GO_UP <> 1
            AI_CURRENT_LOCATION_Y - 1
            Goto BREAKOUT
            Else
            
              If AI_LOGIC_CAN_GO_DOWN <> 1
              AI_CURRENT_LOCATION_Y + 1
              Goto BREAKOUT
              EndIf

              If AI_LOGIC_CAN_GO_LEFT <> 1
              AI_CURRENT_LOCATION_X - 1
              Goto BREAKOUT
              EndIf
            
              If AI_LOGIC_CAN_GO_RIGHT <> 1
              AI_CURRENT_LOCATION_X + 1
              Goto BREAKOUT
              EndIf
             
          EndIf
    
        
BREAKOUT:  

ENEMY_ONLY_ONE_WAY_OUT = #False ;reset swit

EndIf

EndIf



;Check for any solid objects
;Draw Sprite at its location
;ConsoleColor(#TEXT_COLOR_BrightRed,#TEXT_COLOR_Black)
;DRAW_ANY_SOLID_OBJECTS_ON_SCREEN()
;DRAW_ENEMY_SPRITE()


AI_TRACER_DOWNWARD_X = AI_CURRENT_LOCATION_X
AI_TRACER_DOWNWARD_Y = AI_CURRENT_LOCATION_Y + 1

AI_TRACER_UPWARD_X = AI_CURRENT_LOCATION_X
AI_TRACER_UPWARD_Y = AI_CURRENT_LOCATION_Y - 1

AI_TRACER_LEFT_X = AI_CURRENT_LOCATION_X - 1
AI_TRACER_LEFT_Y = AI_CURRENT_LOCATION_Y

AI_TRACER_RIGHT_X = AI_CURRENT_LOCATION_X + 1
AI_TRACER_RIGHT_Y = AI_CURRENT_LOCATION_Y

SHOW_TRACER_TIPS()
PROCESS_ALL_COLLISIONS_IF_ANY()



;Check for any solid objects
;Draw Sprite at its location
ConsoleColor(#TEXT_COLOR_DarkGrey,#TEXT_COLOR_Black)
DRAW_ANY_SOLID_OBJECTS_ON_SCREEN()
ConsoleColor(#TEXT_COLOR_BrightRed,#TEXT_COLOR_Black)
DRAW_ENEMY_SPRITE()
SHOW_TRACER_TIPS()



ConsoleColor(#TEXT_COLOR_White,#TEXT_COLOR_Black)
ConsoleLocate(58,0)  
Print("X_Dist:"+DISTANCE_X_TARGET+"")
ConsoleLocate(58,1)  
Print("Y_Dist:"+DISTANCE_Y_TARGET+"")



;State Status of Logic
ConsoleLocate(30,0)  
Print("▲:"+AI_LOGIC_CAN_GO_UP+"")
ConsoleLocate(30,1)  
Print("▼:"+AI_LOGIC_CAN_GO_DOWN+"")
ConsoleLocate(35,1)  
Print("►:"+AI_LOGIC_CAN_GO_RIGHT+"")
ConsoleLocate(25,1)  
Print("◄:"+AI_LOGIC_CAN_GO_LEFT+"")


SHOW_TRACER_TIPS()

;State Status of Logic
ConsoleColor(#TEXT_COLOR_White,#TEXT_COLOR_Black)
ConsoleLocate(30,0)  
Print("▲:"+AI_LOGIC_CAN_GO_UP+"")
ConsoleLocate(30,1)  
Print("▼:"+AI_LOGIC_CAN_GO_DOWN+"")
ConsoleLocate(35,1)  
Print("►:"+AI_LOGIC_CAN_GO_RIGHT+"")
ConsoleLocate(25,1)  
Print("◄:"+AI_LOGIC_CAN_GO_LEFT+"")

;reset state - for 1 frame
AI_LOGIC_CAN_GO_DOWN    = 2
AI_LOGIC_CAN_GO_UP      = 2
AI_LOGIC_CAN_GO_RIGHT   = 2
AI_LOGIC_CAN_GO_LEFT    = 2 
 


;>>>>>>>>>>>>>>>>>>>>>>> STATE MACHINE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< [START]
BEGIN_STATE_MACHINE:

PROCESS_ALL_COLLISIONS_IF_ANY()
SHOW_TRACER_TIPS()
ConsoleColor(#TEXT_COLOR_White,#TEXT_COLOR_Black)
ConsoleLocate(30,0)  
Print("▲:"+AI_LOGIC_CAN_GO_UP+"")
ConsoleLocate(30,1)  
Print("▼:"+AI_LOGIC_CAN_GO_DOWN+"")
ConsoleLocate(35,1)  
Print("►:"+AI_LOGIC_CAN_GO_RIGHT+"")
ConsoleLocate(25,1)  
Print("◄:"+AI_LOGIC_CAN_GO_LEFT+"")
KeyPressed$ = Inkey()
      
If KeyPressed$ <> ""
  


       ; Exit Key
       If Str(RawKey()) = "27"
         End
       EndIf
       
       ; F Key
       If Str(RawKey()) = "70" And AI_LOGIC_I_AM_FROZEN = #False
         AI_LOGIC_I_AM_FROZEN = #True
         PASS_OLD_LOCATION_INTO_MEMORY()
         ;Goto BEGIN_STATE_MACHINE
         Goto BEGIN_LOOP
       ElseIf Str(RawKey()) = "70" And AI_LOGIC_I_AM_FROZEN = #True
         PASS_OLD_LOCATION_INTO_MEMORY()
         AI_LOGIC_I_AM_FROZEN = #False
         ;Goto BEGIN_STATE_MACHINE
         Goto BEGIN_LOOP
       EndIf
       
       
       ; C Key
       ;------------------------------------------------------------
       If Str(RawKey()) = "67"
       ClearConsole()
       Delay(30)
       Goto BEGIN_LOOP
       EndIf
     
     
   
     ElseIf RawKey()
       
        ;------------------------------------------------------------
        ; UP Arrow key (works also if numlock is off)
        ;------------------------------------------------------------
        If Str(RawKey()) = "38"
        PASS_OLD_LOCATION_INTO_MEMORY()
        CONSOLE_CURSOR_CURRENT_LOCATION_Y - 1
        ConsoleLocate(40,0)
        Print("Cursor                                 ")
        PROCESS_ALL_COLLISIONS_IF_ANY()
        SHOW_TRACER_TIPS()
        Goto BEGIN_LOOP
        EndIf
        ;------------------------------------------------------------
        ; DOWN Arrow key
        ;------------------------------------------------------------
        If Str(RawKey()) = "40"
        PASS_OLD_LOCATION_INTO_MEMORY()
        CONSOLE_CURSOR_CURRENT_LOCATION_Y + 1
        ConsoleLocate(40,0)
        Print("Cursor                                 ")
        PROCESS_ALL_COLLISIONS_IF_ANY()
        SHOW_TRACER_TIPS()
        Goto BEGIN_LOOP 
        EndIf
        ;------------------------------------------------------------
        ; LEFT Arrow key 
        ;------------------------------------------------------------
        If Str(RawKey()) = "37"
        PASS_OLD_LOCATION_INTO_MEMORY()
        CONSOLE_CURSOR_CURRENT_LOCATION_X - 1
        ConsoleLocate(40,0)
        Print("Cursor                                 ")
        PROCESS_ALL_COLLISIONS_IF_ANY()
        SHOW_TRACER_TIPS()
        Goto BEGIN_LOOP
        EndIf
        ;------------------------------------------------------------
        ; RIGHT Arrow key 
        ;------------------------------------------------------------
        If Str(RawKey()) = "39"
        PASS_OLD_LOCATION_INTO_MEMORY()
        CONSOLE_CURSOR_CURRENT_LOCATION_X + 1
        ConsoleLocate(40,0)
        Print("Cursor                                 ")
        PROCESS_ALL_COLLISIONS_IF_ANY()
        SHOW_TRACER_TIPS()
        Goto BEGIN_LOOP
        EndIf
        ;------------------------------------------------------------

        EndIf
        
; TIMING OF THE STATE MACHINE - ! IMPORTANT !  
Delay(80) ; keep timing to this or else you will see the cursor flickering between all the screen re-draws and repositioning.
Goto BEGIN_STATE_MACHINE
;>>>>>>>>>>>>>>>>>>>>>>> STATE MACHINE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< [END]

; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 405
; FirstLine = 677
; Folding = --
; EnableXP
; Executable = Pathfinding_Simple_Version.exe