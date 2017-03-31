library(sp)
library(maptools)
library(lattice)
#library(gstat)
lighttrap <- read.csv(file="C:/Users/Pring/Documents/GAMA Projects/3D_SurveillanceNet/includes/datasources/lighttrap_data_2010_SE_Calculation.csv",head=TRUE,sep=",")

region_grid <- read.csv(file="C:/Users/Pring/Documents/GAMA Projects/3D_SurveillanceNet/includes/RCode/Three_Provinces_Grids_6060.csv",head=TRUE,sep=",")

coordinates(lighttrap)=~x+y
pts = region_grid[c("x", "y")]
predictiongrid = SpatialPixels(SpatialPoints(pts))
gridded(predictiongrid) = TRUE

###########################################
i=4
data =data.frame(lighttrap)[,i]
v_uk = gstat::variogram(data~x+y, lighttrap)
uk_model = gstat::fit.variogram(v_uk, gstat::vgm(1, "Lin", 4000, 0)) 
zn_uk = gstat::krige(data~x+y, lighttrap, predictiongrid, model = uk_model)
zn = zn_uk
zn[["sum_se"]] = sqrt(zn_uk[["var1.var"]])
		
for(i in 5:243)
{
	data =data.frame(lighttrap)[,i]
	v_uk = gstat::variogram(data~x+y, lighttrap)
	uk_model = gstat::fit.variogram(v_uk, gstat::vgm(1, "Lin", 40000, 0)) 
	zn_uk = gstat::krige(data~x+y, lighttrap, predictiongrid, model = uk_model)
	zn[["sum_se"]] <- zn[["sum_se"]] + sqrt(zn_uk[["var1.var"]])
}
zn[["se_mekong"]] = zn[["sum_se"]]/240

write.csv(zn[["se_mekong"]],"C:/Users/Pring/Documents/GAMA Projects/3D_SurveillanceNet/includes/datasources/stdStandardErrors.csv")
result<-zn[["se_mekong"]]