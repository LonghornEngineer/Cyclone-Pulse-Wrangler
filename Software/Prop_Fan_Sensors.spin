CON

        FXOS8700CQ = %00111100
        MAX11613   = %01101000 

        SCL     = 10
        SDA     = 9
        

VAR

  long SENSOR_STACK[50]

  byte WHO_AM_I
  byte STATUS

  byte counter

  word ADC_store[4]

  word FXO_store[3]
   
OBJ

  I2C : "Basic_I2C_Driver_1"  
  
PUB START

  cognew(RUN_SENSORS, @SENSOR_STACK) 

return

PUB RUN_SENSORS

  I2C.Initialize(SCL,SDA)
  waitcnt(cnt+clkfreq)
  
  I2C.WriteByte(MAX11613, i2c#NoAddr, %1000_0000)
  I2C.WriteByte(MAX11613, i2c#NoAddr, %0000_0001)

  I2C.WriteByte(FXOS8700CQ, I2C#OneAddr | $2A, $00)
  I2C.WriteByte(FXOS8700CQ, I2C#OneAddr | $5B, $1F)
  I2C.WriteByte(FXOS8700CQ, I2C#OneAddr | $5C, $20)
  I2C.WriteByte(FXOS8700CQ, I2C#OneAddr | $0E, $01)
  I2C.WriteByte(FXOS8700CQ, I2C#OneAddr | $2A, $0D)  
   
  repeat
    CHECK_ID
    CHECK_STATUS
    CHECK_DATA
    Run_CNT
    Run_ADC
        
    
return

PUB Get_ID

return WHO_AM_I

PUB Get_Status

return STATUS

PUB Get_CNT

return counter

PUB Get_Value (ch)
  'Get the value for the ADC channel (ch) selected.

  return ADC_store[ch]

PUB Get_Data (ch)

  return FXO_store[ch]

PRI CHECK_DATA

  FXO_store[0] := Swap_FXO(I2C.ReadWord(FXOS8700CQ, I2C#OneAddr | $33))  
  FXO_store[1] := I2C.ReadByte(FXOS8700CQ, I2C#OneAddr | $34)
  FXO_store[2] := I2C.ReadByte(FXOS8700CQ, I2C#OneAddr | $37)

return

PRI CHECK_STATUS

  STATUS := I2C.ReadByte(FXOS8700CQ, I2C#OneAddr | $00)

return


PRI CHECK_ID

  WHO_AM_I := I2C.ReadByte(FXOS8700CQ, I2C#OneAddr | $0D)

return

PRI Run_CNT

  counter++

return

PRI Run_ADC  | ch, Config

  repeat ch from 0 to 3
    Config := %0110_0001 + (ch << 1) 
    ADC_store[ch] := Get_Conv(Config)

  return


PRI Get_Conv (Config)
  'Write config for a single channel read then get it. 

  I2C.WriteByte(MAX11613, i2c#NoAddr, Config)

  return Get_Read

PRI Get_Read | ADC_Value, ADC_Value_Temp
  'Reads data from I2C bus.

  ADC_Value := I2C.ReadWord(MAX11613, i2c#NoAddr)

  if ADC_Value == true
    return true
                                                                                                                                                                                                                                                                                                                                                              
  return Swap_Bytes(ADC_Value)

PRI Swap_Bytes (switch) | temp
  'Reorder the word by swapping the lower and upper Byte. 

  temp := (switch << 8) & %00001111_11111111

  return temp | (switch >> 8)

PRI Swap_FXO (switch) | temp
  'Reorder the word by swapping the lower and upper Byte. 

  temp := (switch << 8)

  return temp | (switch >> 8)