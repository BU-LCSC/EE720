# EE720
Sample scripts for accessing and visualizing satellite remote sensing imagery

**Download HLS V1.4 imagery**
   1. Select tile(s), save them as a txt file into: e.g., ~/EE720/MSLSP/SCC/tileLists/cr_etc.txt
   2. Edit JSON file (~/EE720/MSLSP/MSLSP_Parameters.json) to set 
      - Time range (L4 and 5): `imgStarYr` for starting year and `imgEndYr` for ending year
      - Pathways (L42-47)
   3. Open a shell scirpt ~/EE720/MSLSP/SCC/MSLSP_submitTiles_SCC.sh, and make sure you assign appropriate file paths for the JSON and txt files in the line 4 and 5, respectively.
   4. Then, open terminal, go to ~/EE720/MSLSP/SCC/ using 'cd' command, and submite the schell script on the current pathway by using this command './MSLSP_submitTiles_SCC.sh' 
   5. Usually takes several hours (assigning a job to SCC, time for actual downloading, and depending on how many images (i.e., how many years of data) you requsted). Check the directory 'dataDir' out for images downloaded.
   



  

