# MEDIAN_FILTER1D

Pipelined 1D median filter. Window size is 1x3. Latency is 2 clock cycles.
Expected video format is Y8 with 2 pixels per clock cycle.

Input Format
```
Bit     | Description
---------------------
15 -  8 | Y1
 7 -  0 | Y0
```

Output
```
Bit    | Description
--------------------
15 - 8 | Y1
 7 - 0 | Y0
```
