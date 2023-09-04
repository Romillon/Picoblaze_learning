-------------------
TO DO
I guess if I have the seg7.vhd file with an it should works
add the s1 register in prog3.psm (2nd reg for switches)

How to Implement a Test_bench in Vivado


--------
FINIR LE LEARNING (afficheurs  7 segs)
too complicated with 4 digits from now




Translate this in english
DO the internship report
--------------------




Things I sould try  :

#                                                                           We may add another 7segs if needed.


0) print the number with 7 segs                                             Using the Video of https://www.youtube.com/watch?v=KurFCcvw0qA&ab_channel=VahidMeghdadi
1)a) 3 switch for 2^3 = 8 levels for power.                                 When Level >=3           POWER_LED is on.              #POWER = WIND + SOLAR - FARM
  b)                    8 levels for water_level                            When Level = max         MAX_LEVEL is on
  c)              2^7   128 levels for water_temp  (SUR 2 CHIFFRES)         When Level = 7           +1 water level  -3 water temp
  # total   13 switch


2) gestion timing quand on entre dans le cas qu'il faut -> on commence a chauffer l'eau    (water_temp va s'incrémenter tout seul)



3) terminer + optimiser le program







-- Troubles to use The Fidex program.
