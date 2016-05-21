CON
  _CLKMODE      = XTAL1 + PLL16X                        
  _XINFREQ      = 6_000_000

OBJ
  LCD : "LCD_16X2_4BIT"
  TC  : "MAX31855K"
  SEN : "Prop_Fan_Sensors"

VAR
  byte temp0
  byte temp1
  byte temp2
  byte temp3
  byte bright

  byte count

  long ID
  
PUB MAIN
  LCD.START
  TC.START
  SEN.START

  Setup
  
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
    
    'if(count//2)
    '  LCD.STR(STRING("/"))
    'else
    '  LCD.STR(STRING("\"))

    LCD.MOVE(28,3)

    'ID := SEN.Get_ID

    'LCD.BIN(ID,8)

    'ID := SEN.Get_Status
    'LCD.MOVE(28,4)
    'LCD.BIN(ID,8)

    ID := SEN.Get_Data(0)
    LCD.MOVE(20,1)  
    LCD.BIN(ID,16)
    LCD.MOVE(20,2)
    LCD.STR(STRING("        "))
    LCD.MOVE(20,2)
    LCD.DEC(fixA(ID))

      
    temp0 :=  TC.GET_TEMP(0)  
    temp1 :=  TC.GET_TEMP(1)
    temp2 :=  TC.GET_TEMP(2)
    temp3 :=  TC.GET_TEMP(3)

    if(TC.GET_FAULTS(0))
      temp0 := TC.GET_FAULTS(0)

    if(TC.GET_FAULTS(1))
      temp1 := TC.GET_FAULTS(1)

    if(TC.GET_FAULTS(2))
      temp2 := TC.GET_FAULTS(2)

    if(TC.GET_FAULTS(3))
      temp3 := TC.GET_FAULTS(3)
    
    
    if (count == 254)
      LCD.B_CTRL(bright)
      bright++
      if(bright > 3)
        bright := 0


    count++

    waitcnt(cnt+clkfreq/8)

pri fixA(d)
  return d << 18 ~> 18


PUB Setup

  
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

  LCD.MOVE(25,3)
  LCD.STR(STRING("ID:"))

return
    