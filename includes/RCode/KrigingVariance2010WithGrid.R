library(sp)
library(maptools)
library(lattice)
lighttrap <- read.csv(file="C:/Users/Pring/Documents/GAMA Projects/3D_SurveillanceNet/includes/datasources/lighttrap_data_2010_Correlation_Var2_48nodes.csv",head=TRUE,sep=",")

#lighttrap <- read.csv(file="D:/PSN - Models/1.5/3D_SurveillanceNet/includes/datasources/lighttrap_data_2010_SE_Calculation.csv",head=TRUE,sep=",")
#write.csv(vectorParam,"D:/Grid100x100.csv")
rowNo<-vectorParam[1]
columnNo<-vectorParam[2]
cellNo <- rowNo * columnNo
region_grid<- data.frame(x=c(1:cellNo), y=c(1:cellNo), dist=c(1:cellNo), ffreq=c(1:cellNo), part.a=c(1:cellNo), part.b=c(1:cellNo))
region_grid[,"x"]<-vectorParam[(3):(3+ cellNo - 1)]
region_grid[,"y"]<-vectorParam[(3+ cellNo):(3 + 2 * cellNo - 1)]
region_grid[,"dist"] <- 0
region_grid[,"ffreq"] <- 0
region_grid[,"part.a"] <- 0
region_grid[,"part.b"] <- 0

coordinates(lighttrap)=~x+y
pts = region_grid[c("x", "y")]
predictiongrid = SpatialPixels(SpatialPoints(pts))
gridded(predictiongrid) = TRUE

###########################################
i=200
data =data.frame(lighttrap)[,i]
v_uk = gstat::variogram(data~x+y, lighttrap)
uk_model = gstat::fit.variogram(v_uk, gstat::vgm(1, "Lin", 40000, 0)) 
zn_uk = gstat::krige(data~x+y, lighttrap, predictiongrid, model = uk_model)
zn = zn_uk
zn[["sum_se"]] = sqrt(zn_uk[["var1.var"]])


		
#for(i in 5:5)
#{
#	data =data.frame(lighttrap)[,i]
#	v_uk = gstat::variogram(data~x+y, lighttrap)
#	uk_model = gstat::fit.variogram(v_uk, gstat::vgm(1, "Lin", 40000, 0)) 
#	zn_uk = gstat::krige(data~x+y, lighttrap, predictiongrid, model = uk_model)
#	zn[["sum_se"]] <- zn[["sum_se"]] + sqrt(zn_uk[["var1.var"]])
#}
zn[["se_mekong"]] = zn[["sum_se"]]