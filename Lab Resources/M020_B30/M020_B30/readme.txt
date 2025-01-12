Readme.txt for Zipped Estuarine Bathymetry Products
March 30, 2006

The products which have been zipped into this archive were generated by 
the Special Projects Office of the National Ocean Service, NOAA as part 
of a project to produce user friendly bathymetry for those estuaries that 
contained more than 80% spatial coverage of digital sounding data.  Not 
every estuary contained sufficient source data in digital form, thus only 
70+ of the 130+ estuaries are included in the full data set.  These data 
sets can be retrieved from the NOS Data Explorer service <http://nosdataexplorer.noaa.gov>.  

The included Metadata file should be consulted for details on the generation, 
quality, and format of these Bathymetric products.

The source data for these bathymetric products were soundings collected by The 
National Ocean Service over the last 150 years (retrieved from the national 
archives held by the National Geophysical Data Center in Boulder, CO) and 
Shorelines delineated by the National Ocean Service.  

Each Archive file contains the products applicable to one of two data sets 
possible for an estuary.  The two data sets include: 

1. DEM for 30m gridded bathymetry, or                   [eda_B30.zip]
2. DEM for  3 arc second gridded [90m] bathymetry       [eda_B90.zip]

where "eda" represents a unique 4 character code assigned by NOAA's Coastal 
Assessment Framework (CAF) to each estuary.  The first character of this code 
is a letter signifying N = North Atlantic,  M = Mid Atlantic, S = South Atlantic, 
G = Gulf of Mexico, L = Great Lakes, and P = Pacific.  The remaining 3 characters 
are digits which, in general, were assigned increasing clockwise around the coast.

A separate archive file for each estuary [eda_SC.zip] contains visual GIF images 
showing the locations of all soundings used to generate these bathymetric products 
superimposed on NOAA Nautical chart backgrounds.  These files can be accessed 
through the NOS Data Explorer Service noted above. 

The high resolution bathymetric data are gridded to 30m cells defined on a UTM 
projection where the locations of the value for each cell are at coordinates in 
UTM meter units evenly divisible by 30.  The origin of these units is 500,000 
meters west of the central meridian for the UTM projection and the equator. 
It should be noted that these UTM grids do NOT align with geographic parallels 
and meridians which define the extents of these DEM data sets.  

The lower resolution bathymetric data are gridded to 3 arc second cells defined 
on a geographic projection (latitude & longitudes) with units of arc seconds (1 
degee = 3600 arc seconds).  The locations of the value for each cell are at 
geographic coordinates in arc second units evenly divisible by 3.  The origin 
of these units is the prime meridian and the equator.  The vertical extent of 
these grid cells are approximately 90m in length.  The horizontal extent of these 
grid cells vary with latitude and in the real world the cells are not square.  
These grids are congruent with geographic parallels and meridians which define 
the extents of these DEM data sets.   These 3 arc second gridded data are 
equivalently referred to as 3 arc second, Degree Square (DSQ), or 90m data. 
In this context these terms are interchangeable.

The 3 arc second bathymetric data were derived from the higher resolution 30m 
gridded bathymetry and not generated independently.  

Null values (encoded -32767 within the DEMs) are used to represent all locations 
either above (outside) the local high water datum (the shoreline as defined by 
the National Ocean Service) or outside the extents of the estuary as delineated 
by the CAF.

Bathymetric elevations within these data sets are referenced to the local tidal 
datum which typicaly is Mean Lowest Low Water (MLLW) averaged over a 19 year 
tidal epoch.  Elevations above this datum (between the datum and the shoreline) 
have positive values (meters to centimeter resolution) while those below are 
negative.  Note that this datum is different from that used by USGS for land 
elevation data that it distributes in DEM form which are referenced to Mean 
Sea Level (MSL). 

INCLUDED PRODUCTS
Each of these data sets is supported by visual images and text files products.
The products include:
readme.txt		an overview +++ THIS FILE +++ 
metadata---.txt	A text file containing FGDC compliant metadata about the products.
				 The 30m and 90m grids have different metadata files.  
eda_desc.txt		A short descriptive text file for the estuary
eda_view.gif		A GIF image showing color coded bathymentry for the estuary
eda_GI.gif		A GIF image delineating Standard DEM tile extents & names for estuary
eda_idx.gif		A GIF image showing where the estuary is.	 
eda_ ----.dem		one or more DEMs containing the Bathymetry data.

USAGE

THESE BATHYMETRIC DATA SHOULD NOT BE USED FOR NAVIGATION PURPOSES

For further information contact:
------------------------------------------------------------------
Mr. Robert Wilson
Special Projects - National Ocean Service
1305 East-West Highway, SSMC4
Silver Spring, MD 20910
(301) 713-3000 
robert.wilson@noaa.gov 
-------------------------------------------------------------------
