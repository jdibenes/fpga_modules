# L2DMA

Video DMA for capturing scanlines from a two camera system. Ignores SOF (tuser) signal. Expected video format is YUV 4:2:2, 16 bits per pixel, and 2 pixels per clock. This module requires a FIFO, which is not included. Use the FIFO Generator from the Vivado IP catalog to create one.
```
Bit   | Description
-------------------
 0- 7 | Y1 
 8-15 | U 
16-23 | Y2
24-31 | V
```
## Memory Map
### 00h - CONTROL
```
Bit |     | Description
-----------------------
0   | R/W | start / busy (write '1' to start capturing, bit stays as '1' until DMA is done, do not write another 1 before DMA is complete)
1   | R   | fifo 1 full
2   | R   | fifo 2 full
```
### 04h - COUNT
```
Bit  |     | Description
------------------------
0-15 | R/W | Number of scanlines to capture minus 1 (0 = 1 line, 1 = 2 lines, ...)
```
### 08h - DSTADDR0
```
Bit  |     | Description
------------------------
0-31 | R/W | Destination address for camera 0
```
### 0Ch - DSTADDR1
```
Bit  |     | Description
------------------------
0-31 | R/W | Destination address for camera 1
```
