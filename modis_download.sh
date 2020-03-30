#!/bin/bash

for julday in {001..365};
    do for satellite in 'MOD04_L2' 'MYD04_L2';
        do . laads-data-download.sh -s https://ladsweb.modaps.eosdis.nasa.gov/archive/allData/61/$satellite/2019/$julday -d TARGET_PATH -t KEY;
    done;
done
