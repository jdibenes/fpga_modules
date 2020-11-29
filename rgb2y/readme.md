# RGB2Y

Pipelined RGB to gray conversion. Latency is 4 clock cycles.
Expected video format is RBG8 with 2 pixels per clock cycle.

Coefficients
```
a_r = 1/4  + 1/32 + 1/64         = 0.296875
a_g = 1/2  + 1/16 + 1/64 + 1/128 = 0.5859375
a_b = 1/16 + 1/32 + 1/64 + 1/128 = 0.1171785
```

Input Format
```
Bit     | Description
---------------------
47 - 40 | R1
39 - 32 | B1
31 - 24 | G1
23 - 16 | R0
15 -  8 | B0
 7 -  0 | G0
```

Output
```
Bit    | Description
--------------------
15 - 8 | Y1
 7 - 0 | Y0
```
