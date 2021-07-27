CON
  _CLKMODE      = XTAL1 + PLL16X                        
  _XINFREQ      = 6_000_000

OBJ
  LCD : "LCD_16X2_4BIT"
  TC  : "MAX31855K"
  SEN : "Prop_Fan_Sensors"
  F32F: "Float32Full"  

VAR
  long temp0
  long temp1
  long temp2
  long temp3
  long bright

  byte count

  byte Cur_Heading

  byte toggle

  long ID
  long Degree
  
PUB MAIN

  if(INA[21] == 0)
    toggle := 1

  LCD.START
  TC.START
  SEN.START(toggle)
  F32F.START

  Setup_Main_Screen
  
  repeat
  
    if(TC.GET_FAULTS(0))
      temp0 := TC.GET_FAULTS(0)
    else
      temp0 := F32F.FTrunc((F32F.FAdd(F32F.FMul(F32F.FFloat(TC.GET_TEMP(0)), 1.8),32.00)))    

    if(TC.GET_FAULTS(1))
      temp1 := TC.GET_FAULTS(1)
    else
      temp1 := F32F.FTrunc((F32F.FAdd(F32F.FMul(F32F.FFloat(TC.GET_TEMP(1)), 1.8),32.00)))
      
    if(TC.GET_FAULTS(2))
      temp2 := TC.GET_FAULTS(2)
    else
      temp2 := F32F.FTrunc((F32F.FAdd(F32F.FMul(F32F.FFloat(TC.GET_TEMP(2)), 1.8),32.00)))

    if(TC.GET_FAULTS(3))
      temp3 := TC.GET_FAULTS(3)
    else
      temp3 := F32F.FTrunc((F32F.FAdd(F32F.FMul(F32F.FFloat(TC.GET_TEMP(3)), 1.8),32.00)))

    Draw_Temperatures
    
    Draw_Heading    
    
    if (count == 254)
      LCD.B_CTRL(bright)
      bright++
      if(bright > 3)
        bright := 0

    count++

    'waitcnt(cnt+clkfreq/8)

PUB Setup_Main_Screen

  LCD.CLEAR
  
  LCD.MOVE(1,1)
  LCD.STR(STRING("TRANS TEMP:"))
   
  LCD.MOVE(1,2)
  LCD.STR(STRING("E.OIL TEMP:"))
   
  LCD.MOVE(1,3)
  LCD.STR(STRING("WATER TEMP:"))

  LCD.MOVE(1,4)
  LCD.STR(STRING("ENVRO TEMP:"))

  LCD.MOVE(18,2)
  LCD.STR(STRING("A/C:"))

  LCD.MOVE(18,1)
  LCD.STR(STRING("DIR:"))

return

PUB Draw_Heading

  LCD.MOVE(23,1)
  
  Degree := F32F.FTrunc(F32F.Degrees(F32F.ATan2(F32F.FFloat(SEN.Get_FXO_Data(1)), F32F.FFloat(SEN.Get_FXO_Data(0)))))

  CASE Cur_Heading

    0:  'N

      if(Degree < 122 AND Degree > 58)                  'N
        Cur_Heading := 0

      elseif(Degree < 68 AND Degree > 23)               'N/E
        Cur_Heading := 1

      elseif(Degree < 23 AND Degree > -23)              'E
        Cur_Heading := 2

      elseif(Degree < -23 AND Degree > -68)             'S/E
        Cur_Heading := 3

      elseif(Degree < -68 AND Degree > -112)            'S
        Cur_Heading := 4

      elseif(Degree < -112 AND Degree > -157)           'S/W
        Cur_Heading := 5

      elseif(Degree < -157 OR Degree > 157)             'W
        Cur_Heading := 6

      elseif(Degree < 157 AND Degree > 112)             'N/W
        Cur_Heading := 7

      LCD.STR(STRING("N  "))  
     
    1:  'N/E

      if(Degree < 78 AND Degree > 13)                   'N/E
        Cur_Heading := 1
        
      if(Degree < 112 AND Degree > 68)                  'N
        Cur_Heading := 0

      elseif(Degree < 23 AND Degree > -23)              'E
        Cur_Heading := 2

      elseif(Degree < -23 AND Degree > -68)             'S/E
        Cur_Heading := 3

      elseif(Degree < -68 AND Degree > -112)            'S
        Cur_Heading := 4

      elseif(Degree < -112 AND Degree > -157)           'S/W
        Cur_Heading := 5

      elseif(Degree < -157 OR Degree > 157)             'W
        Cur_Heading := 6

      elseif(Degree < 157 AND Degree > 112)             'N/W
        Cur_Heading := 7
    
      LCD.STR(STRING("N/E"))
     
    2:  'E

      if(Degree < 33 AND Degree > -33)                  'E
        Cur_Heading := 2
    
      if(Degree < 112 AND Degree > 68)                  'N
        Cur_Heading := 0

      elseif(Degree < 68 AND Degree > 23)               'N/E
        Cur_Heading := 1

      elseif(Degree < -23 AND Degree > -68)             'S/E
        Cur_Heading := 3

      elseif(Degree < -68 AND Degree > -112)            'S
        Cur_Heading := 4

      elseif(Degree < -112 AND Degree > -157)           'S/W
        Cur_Heading := 5

      elseif(Degree < -157 OR Degree > 157)             'W
        Cur_Heading := 6

      elseif(Degree < 157 AND Degree > 112)             'N/W
        Cur_Heading := 7
    
      LCD.STR(STRING("E  "))
       
    3:  'S/E
    
      if(Degree < -13 AND Degree > -78)                 'S/E
        Cur_Heading := 3
          
      if(Degree < 112 AND Degree > 68)                  'N
        Cur_Heading := 0

      elseif(Degree < 68 AND Degree > 23)               'N/E
        Cur_Heading := 1

      elseif(Degree < 23 AND Degree > -23)              'E
        Cur_Heading := 2

      elseif(Degree < -68 AND Degree > -112)            'S
        Cur_Heading := 4

      elseif(Degree < -112 AND Degree > -157)           'S/W
        Cur_Heading := 5

      elseif(Degree < -157 OR Degree > 157)             'W
        Cur_Heading := 6

      elseif(Degree < 157 AND Degree > 112)             'N/W
        Cur_Heading := 7
    
      LCD.STR(STRING("S/E"))
      
    4:  'S

      if(Degree < -58 AND Degree > -122)                'S
        Cur_Heading := 4
          
      if(Degree < 112 AND Degree > 68)                  'N
        Cur_Heading := 0

      elseif(Degree < 68 AND Degree > 23)               'N/E
        Cur_Heading := 1

      elseif(Degree < 23 AND Degree > -23)              'E
        Cur_Heading := 2

      elseif(Degree < -23 AND Degree > -68)             'S/E
        Cur_Heading := 3

      elseif(Degree < -112 AND Degree > -157)           'S/W
        Cur_Heading := 5

      elseif(Degree < -157 OR Degree > 157)             'W
        Cur_Heading := 6

      elseif(Degree < 157 AND Degree > 112)             'N/W
        Cur_Heading := 7
    
      LCD.STR(STRING("S  "))
       
    5:  'S/W

      if(Degree < -102 AND Degree > -167)               'S/W
        Cur_Heading := 5
        
      elseif(Degree < 112 AND Degree > 68)              'N
        Cur_Heading := 0

      elseif(Degree < 68 AND Degree > 23)               'N/E
        Cur_Heading := 1

      elseif(Degree < 23 AND Degree > -23)              'E
        Cur_Heading := 2

      elseif(Degree < -23 AND Degree > -68)             'S/E
        Cur_Heading := 3

      elseif(Degree < -68 AND Degree > -112)            'S
        Cur_Heading := 4

      elseif(Degree < -157 OR Degree > 157)             'W
        Cur_Heading := 6

      elseif(Degree < 157 AND Degree > 112)             'N/W
        Cur_Heading := 7
    
      LCD.STR(STRING("S/W"))
       
    6:  'W

      if(Degree < -147 OR Degree > 167)                 'W
        Cur_Heading := 6
        
      elseif(Degree < 112 AND Degree > 68)              'N
        Cur_Heading := 0

      elseif(Degree < 68 AND Degree > 23)               'N/E
        Cur_Heading := 1

      elseif(Degree < 23 AND Degree > -23)              'E
        Cur_Heading := 2

      elseif(Degree < -23 AND Degree > -68)             'S/E
        Cur_Heading := 3

      elseif(Degree < -68 AND Degree > -112)            'S
        Cur_Heading := 4

      elseif(Degree < -112 AND Degree > -157)           'S/W
        Cur_Heading := 5

      elseif(Degree < 157 AND Degree > 112)             'N/W
        Cur_Heading := 7
    
      LCD.STR(STRING("W  "))
       
    7:  'N/W
    
      if(Degree < 167 AND Degree > 102)                 'N/W
        Cur_Heading := 7
            
      elseif(Degree < 112 AND Degree > 68)              'N
        Cur_Heading := 0

      elseif(Degree < 68 AND Degree > 23)               'N/E
        Cur_Heading := 1

      elseif(Degree < 23 AND Degree > -23)              'E
        Cur_Heading := 2

      elseif(Degree < -23 AND Degree > -68)             'S/E
        Cur_Heading := 3

      elseif(Degree < -68 AND Degree > -112)            'S
        Cur_Heading := 4

      elseif(Degree < -112 AND Degree > -157)           'S/W
        Cur_Heading := 5

      elseif(Degree < -157 OR Degree > 157)             'W
        Cur_Heading := 6

      LCD.STR(STRING("N/W"))

  LCD.STR(STRING("     "))
  LCD.MOVE(27,1)
  LCD.DEC(Degree)
  
return

PUB Draw_Temperatures

  LCD.MOVE(14,1)
  if(temp0 =< 10)
    LCD.STR(STRING("  "))
   
  elseif(temp0 =< 100)
    LCD.STR(STRING(" "))
 
  LCD.DEC(temp0)

  LCD.MOVE(14,2)
  if(temp1 =< 10)   
    LCD.STR(STRING("  "))
   
  elseif(temp1 =< 100)
    LCD.STR(STRING(" "))

  LCD.DEC(temp1)

  LCD.MOVE(14,3)   
  if(temp2 =< 10)
    LCD.STR(STRING("  "))
   
  elseif(temp2 =< 100)
    LCD.STR(STRING(" "))

  LCD.DEC(temp2)

  LCD.MOVE(14,4)  
  if(temp3 =< 10)  
    LCD.STR(STRING("  "))
    
  elseif(temp3 =< 100)
    LCD.STR(STRING(" "))

  LCD.DEC(temp3)

return
    