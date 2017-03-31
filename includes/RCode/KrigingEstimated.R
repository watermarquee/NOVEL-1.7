library(sp)
library(maptools)
library(lattice)
#library(gstat)
lighttrap <- read.csv(file="C:/Users/Pring/Documents/GAMA Projects/3D_SurveillanceNetMeta/includes/datasources/lighttrap_data_2010_Correlation_Var2.csv",head=TRUE,sep=",")
lighttrap[,4]<-vectorParam
region_grid <- read.csv(file="C:/Users/Pring/Documents/GAMA Projects/3D_SurveillanceNet/includes/RCode/Three_Provinces_Grids_6060.csv",head=TRUE,sep=",")
rg <- readShapeSpatial("D:/PSN - Models/1.5/3D_SurveillanceNet/includes/RCode/3_Provinces_UTM.shp")
rg1<-as(rg,"SpatialPolygons")
coordinates(lighttrap)=~x+y
pts = region_grid[c("x", "y")]
predictiongrid = SpatialPixels(SpatialPoints(pts))
gridded(predictiongrid) = TRUE
v_uk = gstat::variogram(Day1~x+y, lighttrap)
uk_model = gstat::fit.variogram(v_uk, gstat::vgm(1, "Lin", 40000, 0)) 
zn_uk = gstat::krige(Day1~x+y, lighttrap, predictiongrid, model = uk_model)
zn = zn_uk
zn[["mekong"]] <- zn_uk[["var1.pred"]]
zn[["se_mekong"]] = sqrt(zn_uk[["var1.var"]])

for(i in 1:length(zn[["var1.pred"]]))
{
	while(zn[["var1.pred"]][i] < 0)
	{
		zn[["var1.pred"]][i] = 0
	}

}
result<-zn[["var1.pred"]]