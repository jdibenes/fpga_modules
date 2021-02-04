# CAMSTAT

Obtains statistics from an AXI Stream Video Signal. Start of frame (SOF) is when the USER signal is '1' and end of line (EOL) is when the LAST signal is '1';

## Memory Map
### 00h - CONTROL
```
Bit   |     | Description
-----------------------
0     | R   | SOF detected, stays as '1' until reset
1     | R   | Number of samples per scanline is valid (see register 08h)
2     | R   | Number of scanlines per frame is valid (see register 08h)
3     | R   | Current scanline is equal to compare scanline (see register 04h)
4     | R   | SOF IRQ flag, write '1' to clear
5     | R   | EOL IRQ flag, write '1' to clear
6     | R   | Scanline compare match (see register 04h) IRQ flag, write '1' to clear
7     | R/W | SOF IRQ enable
8     | R/W | EOL IRQ enable
9     | R/W | Scanline compare match (see register 04h) IRQ enable
```
### 04h - LY
```
Bit   |     | Description
------------------------
 0-15 | R/W | Compare scanline
16-31 | R   | Current scanline (From 0 to the number given by the bits 16-31 of register 08h)
```
### 08h - WH
```
Bit   |     | Description
------------------------
 0-15 | R   | Number of samples per scanline (multiply by the number of pixels per clock to obtain the width)
16-31 | R   | Number of scanlines per frame (height)
```

