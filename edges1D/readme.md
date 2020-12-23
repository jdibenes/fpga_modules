# EDGES1D

Pipelined 1D subpixel edge detector with configurable threshold. Expected input is the response of the 1x3 median filter (median_filter1D) and 1x13 derivative of Gaussian filter (derivative_gaussian1D) with 2 samples per clock cycle. Output is a 24-bit signed fixed-point number corresponding to the horizontal subpixel coordinate of the detected edges. Subpixel precision is achieved by fitting a parabola to the peaks of the filter response. 

Input Format
```
Bit     | Description
---------------------
21 - 11 | Filter response 1, signed 11-bit integer
10 -  0 | Filter response 0, signed 11-bit integer
```

Output
```
Bit     | Description
--------------------
23      | Sign
22 - 11 | Integer portion
10 -  0 | Fractional portion
```

The output interface is compatible with AXI4-Stream, however the SOF and EOL signals may be asserted when the VALID signal is deasserted so it should not be used with AXI4-Stream modules that expect valid LAST and USER signals.
