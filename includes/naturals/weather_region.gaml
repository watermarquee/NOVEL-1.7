
/**
 *  WeatherRegion
 *  Author: Truong Xuan Viet
 *  Description: 
 */

model WeatherRegion
import "../../includes/GlobalParam.gaml"

/* Insert your model definition here */

global {
	string SHAPE_WEATHER <- '../includes/gis/naturals/WeatherRegion.shp' parameter: 'Voronoi-polygon Weather File:' category: 'WEATHER_REGION';
	
}	
	// Containing the weather data for 12 months (matrix of 12 elements):
	species weather_region{
		string id;
		string name;
		
		// Temperature
		list Temp_Mean <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		list Temp_Max  <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		list Temp_Min  <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		
		// Rainning
		list Rain_Amount      <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		list Rain_Max         <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		list Rain_No_Days_Max <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		list Rain_No_Days     <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		list Rain_Mean        <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		
		// Humidity
		list Hum_Mean    <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] ;
		list Hum_Min     <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] ;
		list Hum_No_Days <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] ;
		
		// Sunning
		list Sunning_Hours      <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		list Sunning_Hours_Mean <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		
		// Wind velocity:
		list Mean_Wind_Velocity <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		list Min_Wind_Velocity  <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		list Max_Wind_Velocity  <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		
		// Wind direction:
		list Wind_Direction_From <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		list Wind_Direction_To   <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		

		// Aggregation index:
		list general_weather_index  <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];	
		list simulation_temperature <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		list temperature_index      <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		list simulation_humidity    <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		list humidity_index         <- [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
		
		
		rgb color <- rgb([0, 255, 255]);
		
		init
		{
			do calculateAggregationIndices;
		}
		
		reflex WeatherReflex{
			
			if(SIMULATION_STEP = 1)
			{
				//do calculateAggregationIndices;
			}
			
		}
		
		action calculateAggregationIndices
		{
			write "Weather index is calculated!";
			
			// Temperature variables:
			let tempMean type: float value: 0.0;
			let tempMax type: float value: 0.0;
			let tempMin type: float value: 0.0;
			
			// Humidity variables:			
			let humMean type: float value: 0.0;
			let humMax type: float value: 0.0;
			let humMin type: float value: 0.0;
			
			
			let GOOD_MIN_TEMP type: float value: 20.0;
			let GOOD_MAX_TEMP type: float value: 30.0;
			
			let GOOD_MIN_HUM type: float value: 70.0; // Dyck et al. (1979)
			let GOOD_MAX_HUM type: float value: 85.0; // Dyck et al. (1979)
			
			// Indices:
			//let weatherIndex type: float value: 0.0;
			let temperatureIndex type: float value: 0.0;
			let humidityIndex type: float value: 0.0;
			
			loop i from: 0 to: 11
			{
				// Temperature:
				
				set tempMin value: Temp_Min[i];
				set tempMean value: Temp_Mean[i];
				
				let two_deviation value: abs(tempMean - tempMin) * 2; // abs(): Tolerance!!! Data can have some errors 
				put item: (tempMin + rnd(two_deviation)) at: i in: simulation_temperature;
				
				// Calculate the temperature index:
				let goodMeanTemp value: (GOOD_MAX_TEMP + GOOD_MIN_TEMP) / 2;
				let goodTempDeviation value: 2; //(GOOD_MAX_TEMP + GOOD_MIN_TEMP) / 2;
				set temperatureIndex value: exp(-((simulation_temperature[i] - goodMeanTemp)^2/(2*(goodTempDeviation^2))));
				put item: temperatureIndex at: i in: temperature_index;
				
				// Humidity:
				set humMin value: Hum_Min[i];
				set humMean value: Hum_Mean[i];
								
				set two_deviation value: abs(humMean - humMin) * 2; // abs(): Tolerance!!! Data can have some errors 
				put item: (humMin + rnd(two_deviation)) at: i in: simulation_humidity;
				
				// Calculate the humidity index:
				let goodMeanHum value: (GOOD_MAX_HUM + GOOD_MIN_HUM) / 2;
				let goodHumDeviation value: (GOOD_MAX_HUM + GOOD_MIN_HUM) / 2;
				set humidityIndex value: exp(-((simulation_humidity[i] - goodMeanHum)^2/(2*(goodHumDeviation^2))));
				put item: humidityIndex at: i in: humidity_index;
				
				
				// Aggregated index using two factors:
				put item: (humidity_index[i] + temperature_index[i])/2 at: i in: general_weather_index;
				
				write general_weather_index;
			}
			
		}
	}