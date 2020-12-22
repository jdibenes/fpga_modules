# MEDIAN_FILTER1D

Pipelined 1D median filter. Window size is 1x3. Latency is 2 clock cycles.
Expected video format is Y8 with 2 pixels per clock cycle. This filter preserves line width so the first 2 pixels contain garbage and the output is shifted by 1 pixel.

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
