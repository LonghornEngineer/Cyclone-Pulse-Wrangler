CON
  _CLKMODE      = XTAL1 + PLL16X                        
  _XINFREQ      = 5_000_000

OBJ
  LCD : "LCD_16X2_4BIT"

VAR
  byte temp0
  byte temp1
  byte temp2
  byte temp3
  byte bright
  
PUB DEMO
  LCD.START


  LCD.MOVE(1,1)
  LCD.STR(STRING("TRANS TEMP:"))
   
  LCD.MOVE(1,2)
  LCD.STR(STRING("E.OIL TEMP:"))
   
  LCD.MOVE(1,3)
  LCD.STR(STRING("WATER TEMP:"))

  LCD.MOVE(1,4)
  LCD.STR(STRING("ENVRO TEMP:"))

  LCD.MOVE(25,2)
  LCD.STR(STRING("A/C:"))
  
  repeat
    if(temp0 < 10)
      LCD.MOVE(14,1)
      LCD.STR(STRING("  "))
      LCD.DEC(temp0)

    elseif(temp0 < 100)
      LCD.MOVE(14,1)
      LCD.STR(STRING(" "))
      LCD.DEC(temp0)

    else
      LCD.MOVE(14,1)
      LCD.DEC(temp0)

    if(temp1 < 10)
      LCD.MOVE(14,2)
      LCD.STR(STRING("  "))
      LCD.DEC(temp1)

    elseif(temp1 < 100)
      LCD.MOVE(14,2)
      LCD.STR(STRING(" "))
      LCD.DEC(temp1)

    else
      LCD.MOVE(14,2)
      LCD.DEC(temp1)

    if(temp2 < 10)
      LCD.MOVE(14,3)
      LCD.STR(STRING("  "))
      LCD.DEC(temp2)

    elseif(temp2 < 100)
      LCD.MOVE(14,3)
      LCD.STR(STRING(" "))
      LCD.DEC(temp2)

    else
      LCD.MOVE(14,3)
      LCD.DEC(temp2)

    if(temp3 < 10)
      LCD.MOVE(14,4)
      LCD.STR(STRING("  "))
      LCD.DEC(temp3)

    elseif(temp3 < 100)
      LCD.MOVE(14,4)
      LCD.STR(STRING(" "))
      LCD.DEC(temp3)

    else
      LCD.MOVE(14,4)
      LCD.DEC(temp3)

    LCD.MOVE(29,2)
    
    if(temp0//2)
      LCD.STR(STRING("/"))
    else
      LCD.STR(STRING("\"))
      
    temp0++
    temp1++
    temp2++
    temp3++
     
    LCD.B_CTRL(bright)
    bright ++
     
    if(bright > 3)
      bright := 0   

    