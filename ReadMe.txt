-------------------
TO DO


-Trouble to use the 7segment Display not working as expected


-Try to use two inputs bytes    (for the 16 sw's)   but only one byte trigger the program 
    => Always the first 8 switches : even if I try once to assign it to the register s1 and another time to the register s0 it has the same behaviour
    => something's not clear here 


    in the beginnin everything is rather easy + i'm learning to do stuff so i co with easy cases but later on i try to add a bit of diffuclty and it start 
    to be hard understanding what's going on in my program so I think here I should use Test Bench because ok it takes more time
    but I think my biggest mistake is to try coding my idea straight to see if it can saves everything and if it's not working i try another idea
    so good idea when the task is easy but when it's getting complicated I should go slower and take notes/ draw diagrams so I can better understand and best of all
    prevent myself from getting lost.  




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






