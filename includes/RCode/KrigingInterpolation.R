library(sp)
library(maptools)
library(lattice)

n<-length(vectorParam)/3
lighttrap <- data.frame(x=c(1:n), y=c(1:n), density=c(1:n))

lighttrap[,3]<-vectorParam[1:n]
lighttrap[,1]<-vectorParam[(n+1):(2*n)]
lighttrap[,2]<-vectorParam[(2*n+1):(3*n)]
region_grid <- read.csv(file="C:/Users/Pring/Documents/GAMA Projects/3D_SurveillanceNet/includes/RCode/Three_Provinces_Grids_6060.csv",head=TRUE,sep=",")

# PROCESSING
coordinates(lighttrap)=~x+y
pts = region_grid[c("x", "y")]
predictiongrid = SpatialPixels(SpatialPoints(pts))
gridded(predictiongrid) = TRUE
v_uk = gstat::variogram(density~x+y, lighttrap)
uk_model = gstat::fit.variogram(v_uk, gstat::vgm(1, "Lin", 40000, 0)) 
zn_uk = gstat::krige(density~x+y, lighttrap, predictiongrid, model = uk_model)
minCorr<-min(zn_uk[["var1.pred"]])
maxCorr<-max(zn_uk[["var1.pred"]])
for(i in 1:length(zn_uk[["var1.pred"]]))
{
	zn_uk[["var1.pred"]][i] = (zn_uk[["var1.pred"]][i] - minCorr) * 2 / (maxCorr - minCorr) - 1
}
result<-zn_uk[["var1.pred"]]