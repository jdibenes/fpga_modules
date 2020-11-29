# RGB2Y_CORE

Pipelined RGB to gray conversion. Latency is 4.

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
23 - 16 | R
15 -  8 | B
 7 -  0 | G
```
