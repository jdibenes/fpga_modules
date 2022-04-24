# vga300M

Simple VGA controller with built-in DMA. Input clk frequency must be 300 MHz.

## Memory Map
### 00h - CONTROL
```
Bit  |     | Description
-----------------------
0    | R/W | Enable
1    | X   |
2-31 | R/W | Upper 30 bits of framebuffer address (word-aligned)
```
