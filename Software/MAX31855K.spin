CON

        TC_SCK    = 27
        TC_SO     = 26
        TC_CS0    = 22
        TC_CS1    = 23
        TC_CS2    = 24
        TC_CS3    = 25

VAR
  long TC_STACK[100]

  long TC_Value[4]

  long TC_Temp
  
PUB START    

  cognew(RUN_TC, @TC_STACK)

return

PUB RUN_TC | i

  OUTA[TC_SCK] := 0
  OUTA[TC_CS0..TC_CS3] := $FF
                                                                                      
  DIRA[TC_SCK] := 1
  DIRA[TC_CS0..TC_CS3] := $FF 

  DIRA[TC_SO]  := 0

    repeat
      repeat i from 0 to 7
        TC_Value[i] := read_TC(i)

return

pub GET_FAULTS(TC_Num)

return TC_Value[TC_Num] & %0111

PUB GET_TEMP(TC_Num)
                            
return TC_Value[TC_Num] ~> 18  

PRI read_TC(TC_Num)
  
  'Set CS Low
  OUTA[TC_CS0 + TC_Num] := 0
  
  repeat 32
    TC_Temp := (TC_Temp << 1) | INA[TC_SO]    
    OUTA[TC_SCK] := 1                                      
    OUTA[TC_SCK] := 0
 
  'Set CS High
  OUTA[TC_CS0 + TC_Num] := 1

return TC_Temp      
      