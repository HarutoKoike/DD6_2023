PRO cis::instrument, azimuth=azimuth, elevation=elevation, $
                     energy=energy, hia=hia, codif=codif
;
COMPILE_OPT IDL2
;
IF KEYWORD_SET(hia) THEN GOTO, hia

e = [34117.30,26796.81,21047.05,16531.02,12983.98,10198.03,8009.85,$
     6291.19,4941.30,3881.05,3048.30,2394.23,1880.50,1477.01,1160.09,$
     911.17,715.66,562.10,441.49,346.76,272.36,213.92,168.02,131.97, $
     103.65,81.41,63.94,50.22,39.45,30.98,24.33]
;
theta = [-78.750, -56.250, -33.750, -11.250, 11.250, 33.750, 56.250, 78.750]
;
phi = [-45.417, -67.917, -90.417, -112.917, -135.417, -157.917, 179.583, $
       157.083, 134.583, 112.083, 89.583, 67.083, 44.583, 22.083, -0.417,$
       -22.917]

hia:
;
e = [28898.33,21728.22,16337.12,12283.63,9235.88,6944.32,5221.33,3925.84, $
     2951.78,2219.40,1668.73,1254.69,943.39,709.32,533.32,401.00,301.50,  $
     226.70, 170.45, 128.16, 96.36,72.45,54.48,40.96,30.80,23.16,17.41,   $
     13.09,9.84,7.40,5.56]
;
theta = [-78.750, -56.250, -33.750, -11.250, 11.250, 33.750, 56.250, 78.750]
;
phi = [11.184, -11.316, -33.816, -56.316, -78.816, -101.316, -123.816, $
       -146.316, -168.816, 168.684, 146.184, 123.684, 101.184, 78.684, $
       56.184, 33.684, 5.770, 4.530, 3.560]

IF ARG_PRESENT(azimuth)   THEN azimuth = phi
IF ARG_PRESENT(elevation) THEN elevation = theta
IF ARG_PRESENT(energy)    THEN energy = e

END
