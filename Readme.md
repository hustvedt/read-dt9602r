# DT9602R Logger

This gem can connect to a DT9602R multimeter over the serial port, and logs the data to a CSV file. All of the modes
and attributes of the DT9602R are supported.


Usage:

`read-dt9602r [Serial port]`

The default serial port is /dev/ttyUSB0

The default CSV output is:

|Row|Value Example|Meaning|
|---|-------------|-------|
|0|12345678.0|The floating point unix time|
|1|0.00|The main value as displayed on the meter|
|2|M|The SI Prefix|
|3|Volts|The unit the meter is outputting|
|4|DC|AC/DC|
|5|Ground|Not quite sure, but this seems to be measurements that aren't relative|
|6|Hold|When the display isn't changing. The values should be all the same|
|7|Delta|Delta mode, where the measurement is relative to the mode when Delta was pressed|
|8|Auto|Auto-ranging mode|
|9|Cap|Capactiance measurement mode|
|10|LowBat|Indicates that the battery for the meter is low|
|11|Min|Indicates that the minimum value is being displayed|
|12|Max|Indicates that the maximum value is being displayed|
|13|Duty|Indicates that duty cycle is being displayed|
|14|Diode|Indicates that duty cycle is being displayed|


##Details of the DT9602 Serial Protocol

The DT9602R sends out a 14-byte packet, terminated with a windows line ending (CRLF).


|Byte|Meaning|
|----|-------|
|0|Sign ('+' or '-')
|1-4|Number, 3 characters in ASCII
|5|Literal space ' '
|6|Precision
|7-8|Mode bit flags
|9|SI Prefix bit flags
|10|SI unit
|11|Don't know
|12-13|CRLF windows line ending

### Byte 6: Precision

Multiply the number by this amount: 

|0x80|0x40|0x20|0x10|0x8|  0x4|  0x2|   0x1|
|----|----|----|----|---| ----|-----|------|
|    |    |    |        |  0.1| 0.01| 0.001|

### Byte 7: Modes

|   0x80| 0x40|        0x20|0x10|0x8|       0x4|0x2 |              0x1|
|-------|-----|------------|----|---|----------|----|-----------------|
|Unknown|Delta|Auto-ranging|  DC| AC|Delta mode|Hold|Ground-reference?|



### Byte 8: Modes


|   0x80|   0x40|0x20|0x10|        0x8|    0x4|      0x2|    0x1|
|-------|-------|----|----|-----------|-------|---------|-------|
|Unknown|Unknown| Max| Min|Low Battery|Unknown|Capacitor|Unknown|

### Byte 9: SI Prefix


|0x80|0x40|0x20|0x10|0x8|0x4|0x2|0x1|
|----|----|----|----|---|---|---|---|
|&mu;|   m|   k|   M|   |   |   |   |


### Byte 10: Unit


| 0x80|0x40|0x20|   0x10|0x8|0x4                     |0x2    |0x1       |
|-----|----|----|-------|---|------------------------|-------|----------|
|Volts|Amps|Ohms|Unknown| Hz|Farads (Prefix is wrong)|Celsius|Fahrenheit|







