/*
 *  Insect Brownplant Hopper Infestation Simulation
 *  Author: -M
 *  Last Modified Date: 17-02-2017
 */

model GlobalParam
//import "platform:/plugin/msi.gama.gui.application/generated/std.gaml"

global {
	// Sensor number:
	int no_of_sensor <- 100 ;
	
	// Simulation step:
	int SIMULATION_STEP <- 0;
	int INITIALIZED <- 0;
	int MONTH_CHANGED <- 0;
	
	int DAY <- 1;
	int MONTH <- 1;
	int YEAR <- 2010;
	int TIME_OFFSET <- 0;
	int TIME_OFFSET2 <- 64;
	
		
	
	// Simulation step:
	int GRID_COLUMN_NO <- 60;
	int GRID_ROW_NO <- 60;
	
	// Thresholds:
	float MAX_DENSITY update: 1000000.0 ;
	float MIN_DENSITY update: 0.0;
	
	// COORDINATES
	float BOUNDARY_MAX_X update: 0.0;
	float BOUNDARY_MIN_X update: 0.0;
	float BOUNDARY_MAX_Y update: 0.0;
	float BOUNDARY_MIN_Y update: 0.0;
	
	// Disk graph radius:
	float DISK_RADIUS update: 15000.0;
	float LOWEST_RADIUS update: 5000.0;
	float CORRELATION_THRESHOLD update: 0.3;
	
	// IDW_RANGE:
	float IDW_RANGE update: 40000.0;
	
	// Density data
	int HISTORICAL_DURATION update: 365;
	
	// LIFE CYCLE OF BROWN PLANT HOPPER
	int BPH_LIFE_DURATION <- 32 parameter: 'BPH LIFE DURATION:' category: 'BROWN PLANT HOPPER';
	//ADULT_EGG_RATE type: float <- 500.0 parameter: 'ADULT-EGG RATE:' category: 'BROWN PLANT HOPPER'; // Long wing: 100; Short wing: 400
	float ADULT_EGG_RATE <- 350.0 parameter: 'ADULT-EGG RATE:' category: 'BROWN PLANT HOPPER'; // Long wing: 100; Short wing: 400
	float EGG_NYMPH_RATE <- 0.4 /*Default: 0.4*/ parameter: 'EGG-NYMPH RATE:' category: 'BROWN PLANT HOPPER';
	float NYMPH_ADULT_RATE <- 0.4 /*Default: 0.4*/ parameter: 'NYMPH-ADULT RATE:' category: 'BROWN PLANT HOPPER';
	float NATURAL_MORTALITY_RATE <- /* Default: 0.35*/0.15 parameter: 'NATURAL MORTALITY RATE:' category: 'BROWN PLANT HOPPER'; //0.035 (per day);
	float MORTALITY_RATE_BY_PREDACTORS <- 0.0 /* 0.215*/ parameter: 'MORTALITY RATE BY PREDACTORS:' category: 'BROWN PLANT HOPPER'; // Can be calculated by density of other insect 
	float EGG_DURATION <- 7.0 parameter: 'EGG DURATION:' category: 'BROWN PLANT HOPPER';
	float NYMPH_DURATION <- 13.0 parameter: 'NYMPH DURATION:' category: 'BROWN PLANT HOPPER';
	float ADULT_DURATION <- 12.0 parameter: 'ADULT DURATION:' category: 'BROWN PLANT HOPPER';
	float ADULT_DURATION_GIVING_BIRTH_DURATION <- 6.0 parameter: 'GIVING BIRTH DURATION:' category: 'BROWN PLANT HOPPER'; // Default: 6.0
	
	// Propagation parameters:
	float PROPAGATION_DENSITY_THRESHOLD <- 50.0 parameter: 'PROPAGATION DENSITY THRESHOLD:' category: 'PROPAGATION';
		
		
	// GRID ABLES:
	int COLUMNS_NO update: 60;
	int ROWS_NO update: 60;
	
	// MANAGEMENT PARAMETERS FOR SURVEILLANCE NETWORK
	int NUMBER_OF_CURRENT_NODES update: 48;
	int LIMIT_NUMBER_OF_NODES update: 48;//100;
	int NUMBER_OF_ADDED_NODES update: 0;//52;
	
	// TRANSPLANTATION (Used for the optimization model):
	float WINTER_SPRING_SEASON_COEF update: 0.4;
	float SUMMER_AUTUMN_SEASON_COEF update: 0.4;
	float BASED_SEASON_COEF update: 0.2;
	
	// TRANSPLANTATION (Used for the migration model):
	float RICE_AGE update: 60.0; // WINTER_SPRING: 11th month, DATA: 1st month
	
	// RDBMS PARAMETERS
//	PARAMS type:map <- ['host'::'localhost','dbtype'::'sqlserver','database'::'SurveillanceDB','port'::'1433','user'::'sa','passwd'::'25111978*']; 
//---------------------------------------------------------------------------------------
// MAPING 1:1 from shp file
//	BOUNDS type:map <- ['host'::'localhost','dbtype'::'Postgres','database'::'udg','port'::'5432','user'::'postgres','passwd'::'tmt'
//								,"select"::	"select ST_AsBinary(geom) as geo from VNM_Province_3_Provinces"
//								,'crs'::'GEOGCS["WGS84(DD)",DATUM["WGS84", SPHEROID["WGS84", 6378137.0, 298.257223563]], PRIMEM["Greenwich", 0.0], UNIT["degree", 0.017453292519943295], AXIS["Geodetic longitude", EAST], AXIS["Geodetic latitude", NORTH]]'
//								//,'srid'::'4326'
//								//,'longitudeFirst'::'false'
//								];
//
//	PARAMS type:map <- ['host'::'localhost','dbtype'::'Postgres','database'::'udg','port'::'5432','user'::'postgres','passwd'::'tmt'];
//
//	ADMINISTRATIVE_DISTRICT type:string <- "SELECT id_1,id_2,name_1,name_2,name_3, ST_AsBinary(geom) as geo  FROM VNM_district" ;
//	ADMINISTRATIVE_PROVINCE type:string <- "SELECT id_1,id_2,name_1,name_2, ST_AsBinary(geom) as geo  FROM VNM_Province ";

// Using SELECT FROM WHERE condition 
map BOUNDS <- ['host'::'localhost','dbtype'::'postgres','database'::'SurveillanceNetDB','port'::'5432','user'::'postgres','passwd'::'root'
								//,"select"::	"select ST_AsBinary(geom) as geo from VNM_ADM2 WHERE ID_1 = 3291" //Dong Thap, Soc Trang, Bac Lieu
								,"select"::	"select ST_AsBinary(geom) as geo from VNM_ADM2 WHERE ID_2 in (38254,38257,38249)" //Dong Thap, Soc Trang, Bac Lieu
								//,'crs'::'GEOGCS["WGS84(DD)",DATUM["WGS84", SPHEROID["WGS84", 6378137.0, 298.257223563]], PRIMEM["Greenwich", 0.0], UNIT["degree", 0.017453292519943295], AXIS["Geodetic longitude", EAST], AXIS["Geodetic latitude", NORTH]]'
								,'srid'::'4326'
								//,'longitudeFirst'::'false'
								];
 
	map PARAMS <- ['host'::'localhost','dbtype'::'postgis','database'::'SurveillanceNetDB','port'::'5432','user'::'postgres','passwd'::'root'];

	string ADMINISTRATIVE_DISTRICT <- "SELECT id_1,id_2,name_1,name_2,name_3, ST_AsBinary(geom) as geo FROM VNM_ADM3 " 
	     + " WHERE ID_1 = 3291" ;// 13 provinces of Mekong Delta Rivers
	     //+ "WHERE ID_1=3291"; //All Provinces of Mekong Delta Rivers
	string ADMINISTRATIVE_PROVINCE <- "SELECT id_1,id_2,name_1,name_2, ST_AsBinary(geom) as geo FROM VNM_ADM2 WHERE ID_1 = 3291" ;

//MAPING 1:1 from shp file
	string SEA_REGION <- "SELECT Description, ST_AsBinary(geom) as geo FROM SeaRegion" ;
	string WS_LAND_USE <- "SELECT id,sdd, ST_AsBinary(geom) as geo FROM LandUse_WS_Region" ;	
	string SA_LAND_USE <- "SELECT id,sdd, ST_AsBinary(geom) as geo FROM LandUse_SA_Region" ;	
	string NODE <- "SELECT id , LightTrap, District, x, y, Province, id_0 , id_1, id_2,id_3, ST_AsBinary(geom) as geo FROM Three_Provinces_Lighttraps_WGS WHERE remarks != 'unused'";	
	string WEATHER <- "SELECT id,name, ST_AsBinary(geom) as geo FROM WeatherRegion";	
	// Maping CSV to SQL 1:1
	string LIGHTTRAP_DATA <- "SELECT *  FROM lighttrap_data_2010_Correlation_WHERE remarks <> 'unused'";	
	string STANDARD_DEVIATION_DATA <- "SELECT * FROM stdDeviation" ;
	string GENERAL_WEATHER_DATA <- "SELECT * FROM general_weather_data";
	string STATION_WEATHER_DATA <- "SELECT * FROM station_weather_data03";
	string AUTOCORRELATION_DATA <- "SELECT * FROM auto_correlation_between_traps";	
	string RCODES_PATH <- "C:/Users/Pring/Documents/GAMA Projects/1.7.0/3D_SurveillanceNetMeta/includes/RCode";

	//---------------------------------------------------------------------------------------
	//---------------------------------------------------------------------------------------
	
	action increaseSimulationStep {
		SIMULATION_STEP <-SIMULATION_STEP + 1;
	}
	
	action updateMonthDayYear2010 {

		if(SIMULATION_STEP = 0) {

			 MONTH <- 1; 
			 MONTH_CHANGED <- 0;

		}
		else if(SIMULATION_STEP = 31) {
			
				 MONTH <- 2;
				 MONTH_CHANGED <- 0; 

		}
		else if(SIMULATION_STEP = 59) {
		
				 MONTH <- 3;
				 MONTH_CHANGED <- 0; 

		}
		else if(SIMULATION_STEP = 90) {
				 
				 MONTH <- 4; 
				 MONTH_CHANGED <- 0;

		}
		else if(SIMULATION_STEP = 120) {
		
				 MONTH <- 5; 
				 MONTH_CHANGED <- 0;

		}
		else if(SIMULATION_STEP = 151) {
				 
				 MONTH <- 6; 
				 MONTH_CHANGED <- 0;

		}
		else if(SIMULATION_STEP = 181) {
				 
				 MONTH <- 7; 
				 MONTH_CHANGED <- 0;

		}
		else if(SIMULATION_STEP = 212) {
				
				 MONTH <- 8; 
				 MONTH_CHANGED <- 0;

		}
		else if(SIMULATION_STEP = 243) {

				 MONTH <- 9; 
				 MONTH_CHANGED <- 0;

		}
		else if(SIMULATION_STEP = 273) {

				 MONTH <- 10; 
				 MONTH_CHANGED <- 0;

		}
		else if(SIMULATION_STEP = 304) {

				 MONTH <- 11; 
				 MONTH_CHANGED <- 0;

		}
		else if(SIMULATION_STEP = 334) {

				 MONTH <- 12; 
				 MONTH_CHANGED <- 0;

		}
		else {
				// SET MONTH <- 1; 
				 MONTH_CHANGED <- 1;
		}
	}
}