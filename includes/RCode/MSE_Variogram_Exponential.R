library(sp)
library(maptools)
library(lattice)

# PARAMETERS
n<-length(vectorParam)/3
lighttrap <- data.frame(x=c(1:n), y=c(1:n), density=c(1:n))

lighttrap[,3]<-vectorParam[1:n]
lighttrap[,1]<-vectorParam[(n+1):(2*n)]
lighttrap[,2]<-vectorParam[(2*n+1):(3*n)]

# PROCESSING
coordinates(lighttrap)=~x+y
v_uk = gstat::variogram(density~x+y, lighttrap)
uk_model = gstat::fit.variogram(v_uk, gstat::vgm(1, "Exp", 40000, 0)) 

##### GET MODEL PARAMETERS#######
model_nugget <- data.frame(uk_model)[1,2]
model_sil <- data.frame(uk_model)[2,2]
model_range <- data.frame(uk_model)[2,3]
model_kappa <- data.frame(uk_model)[2,4]
estimated_vectors <- NULL
sampled_vectors <- NULL
mse <- 0
for(cnt in 1:length(v_uk[,1]))
{
	distance <- v_uk[cnt, 2]
	estimated_value <- model_sil * (1 - exp(-(distance)/(model_range))) + model_nugget
	gamma_value <- v_uk[cnt, 3]
	estimated_vectors <- c(estimated_vectors, estimated_value)
	sampled_vectors <- c(sampled_vectors, gamma_value)
	mse <- mse + (estimated_value - gamma_value) ^ 2
}
result<-mse