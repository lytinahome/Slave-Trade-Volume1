### This is the directory of the project Estimation of slave trade volume.
# step 1: *Clean the data*.
**data scource: tastdb-exp-2010.sav**
**R program: 8 embarkation.R**
* perform basic data analysis of the dataset of tastdb-exp-2010.sav
* recode the embarkation and disembarkation regions in tastdb-exp-2010.sav.
* edit the odd records in data source.
* involve the following features as the output.
  * voyageid: arbitrary voyage identification number; assigned by editors 
  * year10: decade; calculated and numbered serially from 1650s to 1860s 
  * majbyimp: region of embarkation; calculated, based on port data 
  * mjselimp: region of initial arrival; calculated, based on port data 
  * voy2imp: calculated days of transatlantic voyage  
  * tslavesd: captive embarkations by region and decade; calculated from recorded captive embarkations by port 
  * slaarriv: captive arrivals by region and decade; calculated from recorded captive arrivals by port 
**Output of the program**
* **Figure 1. TASTD Voyages by Types of Documentation**
* 
