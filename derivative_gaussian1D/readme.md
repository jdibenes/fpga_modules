# DERIVATIVE_GAUSSIAN1D

Pipelined 1D derivative of Gaussian filter for edge detection. Window size is 1x13 and sigma value is 2. Latency is 10 clock cycles.
Expected video format is Y8 with 2 pixels per clock cycle. This filter preserves line width so the first 12 pixels contain garbage.

Coefficients
```
[7 23 57 103 128 93 0 -93 -128 -103 -57 -23 -7] / 128
```

Input Format
```
Bit     | Description
---------------------
15 -  8 | Y1
 7 -  0 | Y0
```

Output
```
Bit     | Description
--------------------
21 - 11 | Filter response 1, signed 11-bit integer
10 -  0 | Filter response 0, signed 11-bit integer
```
