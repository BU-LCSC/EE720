# EE720
Sample scripts for accessing and visualizing satellite remote sensing imagery


**Download HLS V1.4 imagery**
- Downloading HLS imagery using a bash shell script
   1. Select tile(s), and save them as a txt file into: e.g., `~/EE720/MSLSP/SCC/tileLists/cr_etc.txt`
   2. Edit JSON file (`~/EE720/MSLSP/MSLSP_Parameters.json`) to set 
      - Time range (L4 and 5): `imgStarYr` for starting year and `imgEndYr` for ending year
      - Pathways (L42-47)
   3. Open a shell script `~/EE720/MSLSP/SCC/MSLSP_submitTiles_SCC.sh`, and make sure you assigned the right file paths for the JSON and txt files in the lines 4 and 5.
   4. Then, open terminal, go to ~/EE720/MSLSP/SCC/ using `cd` command, and submit the shell script on the current pathway by using this command `./MSLSP_submitTiles_SCC.sh` 
   5. Usually takes several hours (assigning a job to SCC, time for actual downloading, and depending on how many images (i.e., how many years of data) you requsted). Check the directory `dataDir` in the JSON file for images downloaded.
   
   
**Open and visualize HLS V1.4 imagery**
- HLS V1.4 imagery is archived into a format HDF [https://en.wikipedia.org/wiki/Hierarchical_Data_Format]
- Using an R package `terra` (or `raster` for older versions of R), we can easily handle HDF files
- A R script `~/EE720/MSLSP/Development/EE720_001.r` is for a simple example of how to load and display HLS imagery on `rstudio`
