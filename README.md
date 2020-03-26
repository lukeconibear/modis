## JupyterLab script to create merged modis product
1. Download MODIS .hdf files for aerosol optical depth (AOD) from Aqua (MYD) and Terra (MOD)
2. Setup Python environment
3. Resample 5-minute satellite swaths (.hdf) onto a daily regular grid and convert to NetCDF
4. Create monthly and annual files
5. Merge (daily, monthly, and annual) data from both satellites