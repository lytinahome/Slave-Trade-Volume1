### This is the directory of the project:
# Estimation of slave trade volume.

## Step 1: Data Cleaning

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

* **Figure 1. TASTD Voyages by Types of Documentation** fig_1.png
* **Table 1. TASTDB Variables in the Analysis. Source: TASTDB 2010 codebook.**
* **Table 2. TASTDB 2010 records by embarkation region, 1650s to 1860s.**
* **Table 3. TASTDB 2010 records by arrival region, 1650s to 1860s.**
* *needed data_8.txt*

## Step 2: EDA
**data scource: needed data_8.txt**

**R program: check the assumption.R**

* perform the initial data analysis of data, including basic summary of embarkation/disembarkation regions; missing pattern; classicification of records.
* propose the constant flow assumption and validate it by simulation.

**Output of the program**

* **Table 4. WHCCDB records by embarkation region, 1650s to 1860s.**
* **Table 5. WHCCDB records by arrival region, 1650s to 1860s.**
* **Table 6. Sub-datasets for known data in WHCCDB-2017 dataset.**
* **Figure 2. Missing Data, by variable and by decade.**   fig_2.png
* **Figure 4. Total known voyages by decade.**   fig_4.jpeg
* **Table 7. Embarkation and arrival regions.**
* **Figure 3. Voyage Pattern for Documented Routes.** fig_3.jpeg
* **Figure 5. Pattern of documented captive flows within calculated regions.**   fig_5.jpeg
* **Figure 6a and 6b. Mean and sample distribution of voyages for two routes: Windward coast to Caribbean (3-2); Bight of Biafra to Spanish Mainland (6-3).** 
* **Figure 7. Total documented embarkations, arrivals, and percentage loss: average by decade.**   fig_7.jpg
* **Figure 8. Documented embarkations, arrivals, and loss rates, averaged by decade (circles); and simulated data, assuming constant average flow per voyage (red lines).** fig_8.jpg
* *venn diagram.png*

## Step 3: Imputation of Regions

**data scource: needed data_8.txt**

**R program: impute region.R**

* impute region info by multinomial model.

**Output of the program**

* **Table 8. Sub-datasets for known and imputed data in WHCCDB-2017 dataset.**
* **Figure 9. Imputed voyage pattern for all documented voyages.**  fig_9.jpeg
* **Figure 10. Known captive flows with imputed regions.**  fig_10.jpeg
* *data_impute_region_1.txt*

## Step 4: Imputation of Populations

**data scource: data_impute_region_1.txt**

**R program: mcmc.R**

* impute population info by mcmc model.
* required files: mcmc.stan; generated files: data.tdump; 

**Output of the program**

* **Table 9. Parameters for Embarkations, Arrivals, and Loss Rates.** 
* **Table 10. Estimated total flows of captives.**
* **Figure 11. Overall estimation of Atlantic slave trade volume (from Table 10).**
* **Table 11. Number of voyages for major routes, 1700 – 1860.**
* *summary.xlsx*
* *mcmc.txt*
