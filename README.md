# Civ5mod - No Cities on Small Islands



Includes a check before city building wrt the number of water tiles around the location.

Allows for some canal-type locations and investigates first and next tiles around the spot.

First city has no restrictions. Polynesia, though, get to settle as ususal.

Key DLL work by whoward69 requires Various Mod Components (v 105).





**Key lessons**

* RTFM, I needed to enable the functions in the mod before they could trigger
* The function "IsFreshWater" is really *does this field have freshwater* so it's not relevant here
* Build the function up slowly using print statements
* Chek your variables, and remember if you count water or land
* booleans needs to be converted before they can be logged
* Watch out for nil values





**Forum discussion:**

https://forums.civfanatics.com/threads/can-i-restrict-cities-on-small-islands.699641/





Version 0.3: First cities are ok, debugging and nil pointers

Version 0.2: Polynesia gets to settle.

Version 0.1: seems to work.

