library(sp)
library(maptools)
library(lattice)

n<-vectorParam[1]
rowNo<-vectorParam[2]
columnNo<-vectorParam[3]

lighttrap <- data.frame(x=c(1:n), y=c(1:n), density=c(1:n))

lighttrap[,3]<-vectorParam[4: (n+3)]
lighttrap[,1]<-vectorParam[(n+4):(2*n + 3)]
lighttrap[,2]<-vectorParam[(2*n+4):(3*n + 3)]

cellNo <- rowNo * columnNo
region_grid<- data.frame(x=c(1:cellNo), y=c(1:cellNo), dist=c(1:cellNo), ffreq=c(1:cellNo), part.a=c(1:cellNo), part.b=c(1:cellNo))
region_grid[,"x"]<-vectorParam[(3*n + 4):(3*n + 4 + cellNo - 1)]
region_grid[,"y"]<-vectorParam[(3*n + 4 + cellNo):(3*n + 4 + 2 * cellNo - 1)]
region_grid[,"dist"] <- 0
region_grid[,"ffreq"] <- 0
region_grid[,"part.a"] <- 0
region_grid[,"part.b"] <- 0
coordinates(lighttrap)=~x+y 

pts = region_grid[c("x", "y")]
predictiongrid = SpatialPixels(SpatialPoints(pts))
gridded(predictiongrid) = TRUE

v_uk = gstat::variogram(density~x+y, lighttrap)
uk_model = gstat::fit.variogram(v_uk, gstat::vgm(1, "Gau", 30000, 0)) 
zn_uk = gstat::krige(density~x+y, lighttrap, predictiongrid, model = uk_model)
zn = zn_uk
zn[["mekong"]] <- zn_uk[["var1.pred"]] #padayun test for Wadab region
zn[["se_mekong"]] = sqrt(zn_uk[["var1.var"]])
#Adding random noises:
zn[["noise"]]<-zn_uk[["var1.pred"]] 
for(i in 1:length(zn[["noise"]]))
{
	zn[["noise"]][i] = rnorm(1, zn[["noise"]][i], zn[["se_mekong"]][i]) #padayun test for Wadab region
	while(zn[["noise"]][i] < 0)
	{
		zn[["noise"]][i] = 0
	}

}

result<-zn[["noise"]]