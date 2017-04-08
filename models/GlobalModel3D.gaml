/*
 *  Insect Brownplant Hopper Infestation Simulation
 *  Author: -M
 *  Last Modified Date: 17-02-2017
 */
 
model InsectSNM

import "../includes/GlobalParam.gaml"
import "../includes/administratives/administrative_region.gaml"
import "../includes/ecologies/rice_region.gaml"
import "../includes/surveillances/node_network.gaml"
import "../includes/surveillances/edge_network.gaml"
import "../includes/surveillances/graph_network.gaml"
import "../includes/naturals/natural_environment.gaml"
import "../includes/naturals/weather_region.gaml"


global {
	
	//matrix diskgraph_netwo-0rk size: {no_of_sensor, no_of_sensor} ;
	//var lighttrap_data type: matrix value: matrix (file('../datasources/lighttrap_data_mekong_scenario2.csv')) ;
	
	string SHAPE_NODE <- '../includes/gis/surveillances/Three_Provinces_Lighttraps_WGS.shp' parameter: 'Sensors Network - DONG THAP:' category: 'SURVEILLANCE';
	
	int num_of_edges <- 0;
	
	UnitDiskGraph current_udg <- nil;
	edge current_edge <- nil;
	NaturalEnvironment current_natural_environment <- nil; 
	
//	 Light-trap data:
//	var lighttrap_data type: matrix value: matrix (file ('../includes/datasources/lighttrap_data_2010_Correlation_Var.csv'));
//	
//	 Map of standard deviation: 
//	var standard_deviation_data type: matrix value: matrix (file ('../includes/datasources/stdDeviation.csv'));
//	
//	
//	Weather data:
//	var genaral_weather_data type: matrix value: matrix (file ('../includes/datasources/general_weather_data.csv'));
//	
//	Wind data:
//	var station_weather_data type: matrix value: matrix (file ('../includes/datasources/station_weather_data03.csv'));

//	FOR SQL. Maping 1:1
//	Light-trap data:
	matrix lighttrap_data;
	// Map of standard deviation: 
	matrix standard_deviation_data;
	// Weather data:
	matrix genaral_weather_data;
	// Wind data:
	matrix station_weather_data;
	// Autocorrelation data:
	matrix autocorrelation_data;
	
	
	int no_of_nodes <- 48;
	float count_loop_of_inference <- 0.0 ;
	int orthogonal_vector_index <- 0 ;
	float sum_distance <- 0.0 ;
	float sum_beta <- 0.0 ;
	float estimated_value <- 0.0 ;
	int growthToken <- 0;
	
	// Simulation step:
	//var simStep type: int init: 0;
	list vectorX <- nil;
	list vectorY <- nil;
	
	
	float twoDaysCorrelation <- 0.0;
	float twoDaysCorrelationAVG <- 0.0;
	
		
	float edgesCorrelation <- 0.0;
	float edgesCorrelationAVG <- 0.0;
	
	float source_density <- 0.0;
	float destination_density <- 0.0;
	
	// SUM VALUES:
	float sum_attractive_index <- 0.0;	
	float sum_hinder_index <- 0.0;
	
	// ORTHOGONAL VECTOR:
	//var orthogonal_vector type: matrix <- 0 as_matrix({3, no_of_nodes});
	
	matrix orthogonal_vector size: {3, no_of_nodes};
	//var orthogonal_list type: list init: list ([no_of_nodes]);
	
	int orthogonal_vector_index_low <- 0 ;
	float sum_distance_low <- 0.0 ;
	float sum_beta_low <- 0.0 ;
	float estimated_value_low <- 0.0 ;
	
	// Date variables:
	int sim_Month <- 1;
	int sim_Year <- 2010;
	
	// MSE variogram:
	float MSE_VARIOGRAM <- 0.0;
	
	// MSE VARIOGRAM VALUES:
	//var MSE_VARIOGRAM_VALUES type: matrix size: {4, 365};
	list MSE_VARIOGRAM_LIST <- [0.0,0.0,0.0,0.0];
	list MSE_VARIOGRAM_REAL <- nil;
	list MSE_VARIOGRAM_CURRENT_NETWORK <- nil;
	list MSE_VARIOGRAM_OPTIMAL_NETWORK <- nil;
	list MSE_VARIOGRAM_ADDED_NETWORK <- nil;
	 
	float MSE_VARIOGRAM_CURRENT_MODEL <- 0.0;
	float MSE_VARIOGRAM_OPTIMAL_MODEL <- 0.0;

	// Coordinate vector of lighttrap:
	list CURRENT_LIGHTTRAP_COORDINATES_X <- nil;
	list CURRENT_LIGHTTRAP_COORDINATES_Y <- nil;
	list OPTIMAL_LIGHTTRAP_COORDINATES_X <- nil;
	list OPTIMAL_LIGHTTRAP_COORDINATES_Y <- nil;
	
	// Coordinate vector of cellula_automata:
	list CURRENT_CELLS_COORDINATES_X <- nil;
	list CURRENT_CELLS_COORDINATES_Y <- nil;
	
	// Temp variables:
	list temp       <- nil;
	int _month      <- 0;
	string _id_Data <- string(0);
	string _id      <- string(0);
	int _count      <- 0;
	
	
	init{
//		create species: district_region from: SHAPE_ADMINISTRATIVE_DISTRICT with: [id_1 :: read('ID_1'), region_name :: read('NAME_1'), id_2 :: read('ID_2'), province_name :: read('NAME_2'), district_name :: read('NAME_3')];
//	    
//	    /*let SQLDISTRICT type:string <- ' select id_1,id_2,id_3,name_1,name_2,name_3,geom.STAsBinary() as geo from VNM_district';	
//		create species: db{
//			create species:district_region 
//				from: list(self select [params:: PARAMS, select:: LOCATIONS]) 
//				with:
//				[id_1 :: 'ID_1', region_name ::'NAME_1', id_2 :: 'ID_2', province_name :: 'NAME_2', district_name ::'NAME_3',shape::'geo'];	
//		}*/
//		
//		create species: province_region from: SHAPE_ADMINISTRATIVE_PROVINCE with: [id_1 :: read('ID_1'), region_name :: read('NAME_1'), id_2 :: read('ID_2'), province_name :: read('NAME_2')];
//		create species: sea_region from: SHAPE_SEA_REGION with: [description :: read('Description')];
//		create species: WS_rice_region from: WS_SHAPE_LAND_USE with: [id :: read('ID'), description :: read('SDD')];
//		create species: SA_rice_region from: SA_SHAPE_LAND_USE with: [id :: read('ID'), description :: read('SDD')];
//		create species: node from: SHAPE_NODE with: [id :: read('ID'), name :: read('LightTrap'), district_name :: read('District'), province_name :: read('Province'), id_0 :: read('ID_0'), id_1 :: read('ID_1'), id_2 :: read('ID_2')];
//		create species: weather_region from: SHAPE_WEATHER with: [id :: read('ID'), name :: read('NAME')];
//---------------------------------------------------------------------------
	    create species: db number: 1 { 
			create species:district_region from: list(self select [params:: PARAMS, select:: ADMINISTRATIVE_DISTRICT]) with:[ id_1:: "id_1",region_name :: 'NAME_1', id_2 :: 'ID_2', province_name :: 'NAME_2', district_name :: 'NAME_3'];
			create species:province_region from: list(self select [params:: PARAMS, select:: ADMINISTRATIVE_PROVINCE]) with:[ id_1:: "id_1",region_name :: 'NAME_1', id_2 :: 'ID_2', province_name :: 'NAME_2'];
			create species:sea_region from: list(self select [params:: PARAMS, select:: SEA_REGION]) with:[description :: 'Description'];
			create species:WS_rice_region from: list(self select [params:: PARAMS, select:: WS_LAND_USE]) with:[id :: 'ID', description ::'SDD'];
			create species:SA_rice_region from: list(self select [params:: PARAMS, select:: SA_LAND_USE]) with:[id :: 'ID', description ::'SDD'];
			create species:node from: list(self select [params:: PARAMS, select:: NODE]) with:[id :: 'ID', name :: 'LightTrap', district_name :: 'District', province_name :: 'Province', id_0 :: 'ID_0', id_1 :: 'ID_1', id_2 :: 'ID_2'];
			
			
			create species: weather_region from: list(self select [params:: PARAMS, select:: WEATHER]) with: [id :: 'ID', name :: 'NAME'];
			set lighttrap_data <- matrix(self list2Matrix[param::list(self select [params:: PARAMS, select::LIGHTTRAP_DATA])]);
			set standard_deviation_data <- matrix(self list2Matrix[param::list(self select [params:: PARAMS, select::STANDARD_DEVIATION_DATA])]);
			set genaral_weather_data <- matrix(self list2Matrix[param::list(self select [params:: PARAMS, select::GENERAL_WEATHER_DATA])]);
			set station_weather_data <- matrix(self list2Matrix[param::list(self select [params:: PARAMS, select::STATION_WEATHER_DATA])]);
			set autocorrelation_data <- matrix(self list2Matrix[param::list(self select [params:: PARAMS, select::AUTOCORRELATION_DATA])]);

//			matrix genaral_weather_data1 <-matrix (file ('../includes/datasources/general_weather_data.csv'));
//			matrix station_weather_data1 <-matrix value: matrix (file ('../includes/datasources/station_weather_data03.csv'));
//			write "lighttrap data \n"+lighttrap_data;
//			write "standard_deviation_data \n"+standard_deviation_data;
//			write "genaral_weather_data \n"+genaral_weather_data;
//			write "station_weather_data1 \n"+station_weather_data1+ "\n row:" + station_weather_data1.rows+ "\n :";//+station_weather_data1.COLUMNS_NO;
//			write "station_weather_data \n"+station_weather_data+ "\n row:" + station_weather_data.rows+ "\n col:";//+station_weather_data.COLUMNS_NO;
		}
	     
//-----------------------------------------------------------------------------
	
		
		// UDG Species
		create species: UnitDiskGraph number: 1 {
			no_of_nodes update: length(node);
		}
		
		    current_udg update: UnitDiskGraph at 0;
		
		
		// Natural Environment species:
		create species: NaturalEnvironment number: 1;
		current_natural_environment update: NaturalEnvironment at 0;
		
		NUMBER_OF_CURRENT_NODES update: length(node);
		write "No_of_nodes" + NUMBER_OF_CURRENT_NODES;
	}

	reflex main_reflex {
		write updateMonthDayYear2010;
		//do optimizeByCDGAlgorithm;
		//do optimizeByPSOAlgorithm;
		write optimizeByMicroAlgorithm;		
		write dumpLighttrap;
	}

	action getCoordinates {
		
		BOUNDARY_MAX_X update: cellula_automata max_of (cellula_automata(each).location.x);
		BOUNDARY_MIN_X update: cellula_automata min_of (cellula_automata(each).location.x);
		BOUNDARY_MAX_Y update: cellula_automata max_of (cellula_automata(each).location.y);
		BOUNDARY_MIN_Y update: cellula_automata min_of (cellula_automata(each).location.y);
		
		write "BOUNDARY_MAX_X" +  BOUNDARY_MAX_X;
		write "BOUNDARY_MIN_X" +  BOUNDARY_MIN_X;
		write "BOUNDARY_MAX_Y" +  BOUNDARY_MAX_Y;
		write "BOUNDARY_MIN_Y" +  BOUNDARY_MIN_Y;
		
	}
	
	action dumpLighttrap {
		if(SIMULATION_STEP = 65) {
			loop i from: 0 to: length(node) - 1 {
				write "ID:  " + string ((node at i).id) + ", name: " + string ((node at i).name);
				write (node at i).density_matrix;
				write (node at i).simulation_density_matrix;
			}
		}
	}
	
	action optimizeByMicroAlgorithm {
		write "OptimizePSO algorithm - GLOBAL STEP: " + SIMULATION_STEP;
		do action: getCoordinates;
		
		if (SIMULATION_STEP = 0) {
			do action: loadCellsCoordinates;
			do action: loadLighttrapData;
			do action: loadStandardDeviation;
			//do action: loadStandardDeviationR;
			do action: loadGeneralWeatherData;
			do action: loadStationWeatherData;
			do action: loadCurrentTrapCoordinates;
			do action: loadOptimalTrapCoordinates;
			do action: estimate_IDW_Correlation;
			
			// Surface of standard deviation 
			ask cellula_std_deviation as list {		
				list cells_possibles of: cellula_std_deviation <- (self neighbours_at 2) + self;
			
				loop i from: 0 to: length(shape.points) - 1 { 
					geometry geom <- square(1.0);
					geom <- geom translated_to (shape.points at i);
					list myCells of: cellula_std_deviation <- cells_possibles where (each.shape intersects geom);
					//write "z value: " + z;
					let z1 type: float <- mean (myCells collect (each.z));
					set shape <- shape add_z_pt {i, (z1^2)};
				}
			}
		}		
		
		// Calculating the correlation:
		if (SIMULATION_STEP < BPH_LIFE_DURATION) {
			
			do action: getsCorrelationByEdges;
			
			do action: getCorrelationTwoDays;
			
			if(SIMULATION_STEP = 1) {
				
				do action: loadStandardDeviation;
				
				do action: assign_cell_to_node;
				/*do action: add_nodes_to_network
				{
					arg added_number value: NUMBER_OF_ADDED_NODES;
				}
				*/
				
			}
			
			if (SIMULATION_STEP >= 1) {
				do action: update_curent_density {	
					//arg estimated_day value: SIMULATION_STEP;
					arg estimated_day update: SIMULATION_STEP + TIME_OFFSET;
				}
			}
			
			do action: estimate_Kriging_by_day_R_current_network {
				//arg estimated_day value: SIMULATION_STEP;
				arg estimated_day update: SIMULATION_STEP + TIME_OFFSET; 
			}
				
			
			// Surface of environmental hinder:
			ask cellula_automata as list {		
				let cells_possibles type: list of: cellula_automata <- (self neighbours_at 2) + self;
			
				loop i from: 0 to: length(shape.points) - 1 { 
					let geom type: geometry <- square(1.0);
					set geom <- geom translated_to (shape.points at i);
					let myCells type: list of: cellula_automata <- cells_possibles where (each.shape intersects geom);
					//write "z value: " + z;
					let z1 type: float <- mean (myCells collect (each.z));
					set shape <- shape add_z_pt {i, (z1^2)};
				}
			}
			
		}
		else {
			do action: update_curent_density {
					//arg estimated_day value: SIMULATION_STEP;
					arg estimated_day value: SIMULATION_STEP + TIME_OFFSET;
			}
			if (SIMULATION_STEP = BPH_LIFE_DURATION) {
		
				do action: loadOptimalTrapCoordinates;
				do action: dispatchByWind;
			}
			else {	
	
				do action: dispatchByWind;
			}
			do action: MSE_variogram_R {
				//arg estimated_day value: SIMULATION_STEP;
				arg estimated_day value: SIMULATION_STEP + TIME_OFFSET; 
			}
		}

		set SIMULATION_STEP value: SIMULATION_STEP + 1;
	}
		
	action optimizeByPSOAlgorithm {
		write "OptimizePSO algorithm - GLOBAL STEP: " + SIMULATION_STEP;
		do action: getCoordinates;
		
		if (SIMULATION_STEP = 0) {
			do action: loadCellsCoordinates;
			do action: loadLighttrapData;
			do action: loadStandardDeviation;
			//do action: loadStandardDeviationR;
			do action: loadGeneralWeatherData;
			do action: loadStationWeatherData;
			
			do action: loadCurrentTrapCoordinates;
			do action: loadOptimalTrapCoordinates;
			
			do action: estimate_IDW_Correlation;
			
			// Surface of standard deviation 
			ask cellula_std_deviation as list {		
				let cells_possibles type: list of: cellula_std_deviation <- (self neighbours_at 2) + self;
			
				loop i from: 0 to: length(shape.points) - 1 { 
					let geom type: geometry <- square(1.0);
					set geom <- geom translated_to (shape.points at i);
					let myCells type: list of: cellula_std_deviation <- cells_possibles where (each.shape intersects geom);
					//write "z value: " + z;
					let z1 type: float <- mean (myCells collect (each.z));
					set shape <- shape add_z_pt {i, (z1^2)};
				}
			}
		}		
		
		
		// Calculating the correlation:
		if (SIMULATION_STEP < BPH_LIFE_DURATION) {
			do action: getsCorrelationByEdges;
			
			do action: getCorrelationTwoDays;
			
			if(SIMULATION_STEP = 1) {
				do action: assign_cell_to_node;
				do action: add_nodes_to_network {
					arg added_number value: NUMBER_OF_ADDED_NODES;
				}
			}
			
	
			do action: estimate_Kriging_by_day_R_current_network {
				arg estimated_day value: SIMULATION_STEP; 
			}
				
			
			// Surface of environmental hinder:
			ask cellula_automata as list {		
				let cells_possibles type: list of: cellula_automata <- (self neighbours_at 2) + self;
			
				loop i from: 0 to: length(shape.points) - 1 { 
					let geom type: geometry <- square(1.0);
					set geom <- geom translated_to (shape.points at i);
					let myCells type: list of: cellula_automata <- cells_possibles where (each.shape intersects geom);
					//write "z value: " + z;
					let z1 type: float <- mean (myCells collect (each.z));
					set shape <- shape add_z_pt {i, (z1^2)};
				}
			}
			
		}
		else {
			do action: update_curent_density {
					arg estimated_day update: SIMULATION_STEP;
			}
			if (SIMULATION_STEP = BPH_LIFE_DURATION) {
		
				do action: loadOptimalTrapCoordinates;
				do action: dispatchByWind;
			}
			else {	
				do action: dispatchByWind;
			}
			do action: MSE_variogram_R {
				arg estimated_day update: SIMULATION_STEP; 
			}
		}
		
		SIMULATION_STEP update: SIMULATION_STEP + 1;
	}
	

	action optimizeByCDGAlgorithm {
		write "OptimizeCDG algorithm - GLOBAL STEP: " + SIMULATION_STEP;
		
		if condition: (current_udg.setup = 0) {
			do action: loadCellsCoordinates;
			do action: loadLighttrapData;
			do action: loadStandardDeviation;
			//do action: loadStandardDeviationR;
			do action: loadGeneralWeatherData;
			do action: loadStationWeatherData;
			do action: loadCurrentTrapCoordinates;
			do action: loadOptimalTrapCoordinates;
			ask target: current_udg {
				do action: resetEdgesList;
			}
			do action: estimate_IDW_Correlation;
			// Surface of standard deviation 
			ask cellula_std_deviation as list {		
				let cells_possibles type: list of: cellula_std_deviation <- (self neighbours_at 2) + self;
			
				loop i from: 0 to: length(shape.points) - 1 { 
					let geom type: geometry <- square(1.0);
					set geom <- geom translated_to (shape.points at i);
					let myCells type: list of: cellula_std_deviation <- cells_possibles where (each.shape intersects geom);
					//write "z value: " + z;
					let z1 type: float <- mean (myCells collect (each.z));
					set shape <- shape add_z_pt {i, (z1^2)};
				}
			}
		}
		
		// Calculating the correlation:
		if (SIMULATION_STEP < BPH_LIFE_DURATION) {
			do action: getsCorrelationByEdges;
			
			do action: getCorrelationTwoDays;
			//do action: estimate_IDW_Density;
			
			/*do action: estimate_IDW_by_Day
			{
				arg estimated_day value: SIMULATION_STEP; 
			}
			*/
			
			if(SIMULATION_STEP = 0) {
				do action: assign_cell_to_node;
			}
			
			do action: estimate_Kriging_by_day_R {
				arg estimated_day update: SIMULATION_STEP; 
			}
			do action: MSE_variogram_R {
				arg estimated_day value: SIMULATION_STEP; 
			}
			 
			// Surface of environmental hinder:
			ask cellula_automata as list {		
				let cells_possibles type: list of: cellula_automata <- (self neighbours_at 2) + self;
			
				loop i from: 0 to: length(shape.points) - 1 { 
					let geom type: geometry <- square(1.0);
					set geom <- geom translated_to (shape.points at i);
					let myCells type: list of: cellula_automata <- cells_possibles where (each.shape intersects geom);
					//write "z value: " + z;
					let z1 type: float <- mean (myCells collect (each.z));
					set shape <- shape add_z_pt {i, (z1^2)};
				}
			}
		}
		else  {
			do action: update_curent_density {
					arg estimated_day update: SIMULATION_STEP;
			}
			if (SIMULATION_STEP = BPH_LIFE_DURATION) {
		
				do action: optimize_network_by_CDG {
					arg added_number value: NUMBER_OF_ADDED_NODES; 				
				}
				//do action: estimate_IDW_Density;
				//do action: estimate_IDW_Correlation;
				do action: loadOptimalTrapCoordinates;
				do action: dispatchByWind;
			}
			else {	
	
				/*
				ask target: current_udg
				{
					loop i from: 0 to: length(node) - 1 
					{
						let the_node type: node value: node at i; 
						do allocateNewNodeByStdDeviation
						{
							arg center_node value: the_node;
						}
					}
				}
				* 
				*/
				do action: dispatchByWind;
		
				
				//do action: halt;
			}
			
			do action: MSE_variogram_R
			{
				arg estimated_day update: SIMULATION_STEP; 
			}
		}
		
		SIMULATION_STEP update: SIMULATION_STEP + 1;
	} 
	
	// Action: optimize_network_by_PSO
	// Optimizing the surveillance network by PSO
	action add_nodes_to_network
	{
		arg added_number type: int;
		
		ask target: current_udg
		{
			do action: add_new_nodes
			{
				arg name: node_number value: NUMBER_OF_ADDED_NODES;
			}
			
		}
	}
	
	
	// Action: optimize_network_by_CDG
	// Optimizing the surveillance network by CDG
	action optimize_network_by_CDG
	{
		arg added_number type: int;
		
		let min_degree type: int value: (list (node)) min_of (each.degree);
		let max_degree type: int value: (list (node)) max_of (each.degree);
		
		
		// Controlling the placement:  
		let number type: int value: added_number;
		let all_allocated type: bool value: false;
		
		let the_degree type: int value: min_degree;
		loop while: !all_allocated 
		{
			let node_list type: list value: (list (node)) where (each.degree = the_degree);
			
			//write "Degree: " + string(the_degree);
			//write "No of nodes: " + string(length(node_list));
			
			if(number >= length(node_list))
			{
				set number value: number - length(node_list);
				ask target: current_udg
				{
					loop i from: 0 to: length(node_list) - 1
					{
						let the_node value: node at i;
						do allocateNewNodeByStdDeviation
						{
							arg center_node value: the_node;
						}
					}
				}
				
				// The next loop for placing the node:
				if(the_degree = max_degree)
				{
					set min_degree value: (list (node)) min_of (each.degree);
					set max_degree value: (list (node)) max_of (each.degree);
					set the_degree value: min_degree;
				}
				
			}
			else
			{
				if(number != 0)
				{
					
					//write "Degree: " + string(the_degree);
					//write "No of nodes: " + string(number);
					
					ask target: current_udg
					{
						loop i from: 0 to: number - 1
						{
							let the_node value: node at i; 
							do allocateNewNodeByStdDeviation
							{
								arg center_node value: the_node;
							}
						}
					}
				}
				
				// Exit
				set number value: 0;
				set all_allocated value: true;
			}
			
			set the_degree value: the_degree + 1;
		}
	}
	
	
	 	
	// Loading the lighttrap data from the CSV file:
	action loadLighttrapData
	{
		let no_of_rows value: lighttrap_data.rows - 1;
		loop cnt from: 0 to: length (node) - 1 {
			let the_node type: node value: node at cnt;
			 
			ask target: the_node
			{
				loop i from: 1 to: no_of_rows
				{
					if condition: (id = lighttrap_data at {2, i})
					{
						loop j from: TIME_OFFSET2 to: (HISTORICAL_DURATION - 1)
						{
							put item: lighttrap_data at {3 + j, i} at: {0, j} in: density_matrix;
						}
						
						// Choosing the first day for estimation & prediction 
						set number_of_BPHs value: lighttrap_data at {31, i};
						set number_of_BPHs_total value: lighttrap_data at {368, i};
						set correlation_coefficient value: lighttrap_data at {369, i};
						set sample_variance value: lighttrap_data at {374, i};
					}
				}
			}
		}
	}
	
	// Loading the map of standard deviation from the CSV file:
	action loadStandardDeviation
	{
		loop i from: 1 to: GRID_ROW_NO
		{
			loop j from: 1 to: GRID_COLUMN_NO
			{
			
				ask target: cellula_std_deviation at ((j - 1) * GRID_COLUMN_NO + (i - 1))
				{
					set estimation_std_deviation value: standard_deviation_data at {1, ((GRID_COLUMN_NO - j) * GRID_ROW_NO + (i - 1)) + 1};
					write "estimation_std_deviation" + estimation_std_deviation + "- hinder_index: " + (cellula_automata at ((j - 1) * GRID_COLUMN_NO + (i - 1))).hinder_index;
					
					set hydrid_std_deviation value: (estimation_std_deviation / (0.5 + (cellula_automata at ((j - 1) * GRID_COLUMN_NO + (i - 1))).hinder_index)); 
					write "hydrid_std_deviation: " + hydrid_std_deviation;
					
					do aspect_by_hydrid_std_deviation;
					//do aspect_by_std_deviation;
				}
			}
		}
	}
	
	
	action loadCurrentTrapCoordinates
	{
		loop i from: 0 to: length(node as list) - 1
		{
			//let p type: point value: (node at i).location;
			CURRENT_LIGHTTRAP_COORDINATES_X <- CURRENT_LIGHTTRAP_COORDINATES_X + (node at i).location.x;
			CURRENT_LIGHTTRAP_COORDINATES_Y <- CURRENT_LIGHTTRAP_COORDINATES_Y + (node at i).location.y;
		}
	}
	
	
	action loadCellsCoordinates
	{
		CURRENT_CELLS_COORDINATES_X <- nil;
		CURRENT_CELLS_COORDINATES_Y <- nil;
		loop i from: 0 to: length(cellula_automata as list) - 1
		{
			//let p type: point value: (cellula_automata at i).location;
			CURRENT_CELLS_COORDINATES_X <- CURRENT_CELLS_COORDINATES_X + ((cellula_automata at i).location.x with_precision 9);
			CURRENT_CELLS_COORDINATES_Y <- CURRENT_CELLS_COORDINATES_Y + ((cellula_automata at i). location.y with_precision 9);
		}
		
	}
	
	action loadOptimalTrapCoordinates
	{
		loop i from: 0 to: length(node as list) - 1
		{
			let p type: point value: (node at i).location;
			OPTIMAL_LIGHTTRAP_COORDINATES_X <- OPTIMAL_LIGHTTRAP_COORDINATES_X + (node at i).location.x;
			OPTIMAL_LIGHTTRAP_COORDINATES_Y <- OPTIMAL_LIGHTTRAP_COORDINATES_Y + (node at i).location.y;
		}
	}
	
	// Loading the map of standard deviation from the CSV file:
	action loadStandardDeviationR
	{
		map result <- nil;
		list rs <- nil;
		list grid_coordinates <- [GRID_ROW_NO, GRID_COLUMN_NO];
		grid_coordinates <- grid_coordinates + CURRENT_CELLS_COORDINATES_X + CURRENT_CELLS_COORDINATES_Y;
		write "GRID COORDINATES: ";
		write grid_coordinates;
		
		result <- R_compute_param("../includes/RCode/KrigingVariance2010WithGrid.R", grid_coordinates);
		
		
		rs <- result['result'];
		loop i from: 1 to: GRID_ROW_NO
		{
			loop j from: 1 to: GRID_COLUMN_NO
			{
				ask target: cellula_std_deviation at ((j - 1) * GRID_COLUMN_NO + (i - 1))
				{
					set estimation_std_deviation value: rs at (((GRID_COLUMN_NO - j) * GRID_ROW_NO + (i - 1)));
					do aspect_by_std_deviation;
				}
			}
		}
	}
	
	//
	action MSE_variogram_node_list_R
	{
		// MSE OF VARIOGRAM IN THE MODEL 
		arg from_node type: int; // First node in monitored list
		arg to_node type: int; // Last node in monitored list
		arg set_at type: int; // Last node in monitored list
		
		list density_list <- nil;
		list LIGHTTRAP_COORDINATES_X <- nil;
		list LIGHTTRAP_COORDINATES_Y <- nil;
		loop i from: from_node to: to_node
		{
			density_list <- density_list + float((node at i).dominated_cell.number_of_BPHs);
			LIGHTTRAP_COORDINATES_X <- LIGHTTRAP_COORDINATES_X + (node at i).location.x;
			LIGHTTRAP_COORDINATES_Y <- LIGHTTRAP_COORDINATES_Y + (node at i).location.y;
		}
		
		// CALLING R
		map result <- nil;
		list rs <- nil;
		
		 
		density_list <- density_list + LIGHTTRAP_COORDINATES_X + LIGHTTRAP_COORDINATES_Y;
		
		result <- R_file("../includes/RCode/MSE_Variogram_Exponential.R", density_list);
		rs <- result['result'];
		//int _index <- set_at;
		MSE_VARIOGRAM_LIST[set_at] <- float(rs[0]);
	}
	
	// Mean squared root (Calling R):
	action MSE_variogram_R
	{
		// REAL DATA
		arg estimated_day type: int; // The day is standardized as the index!
		
		list density_list <- nil;
		list density_list_current_model <- nil;
		// MODEL
		list density_list_optimal_model <- nil;
		
		
		/*
		loop i from: 0 to: NUMBER_OF_CURRENT_NODES - 1
		{
			density_list <- density_list + float((node at i).density_matrix at {0, estimated_day});
			density_list_current_model <- density_list_current_model + float((node at i).dominated_cell.number_of_BPHs);
			density_list_optimal_model <- density_list_optimal_model + float((node at i).dominated_cell.number_of_BPHs);
		}
		
	
		loop i from: NUMBER_OF_CURRENT_NODES to: length(node as list) - 1
		{
			density_list_optimal_model <- density_list_optimal_model + float((node at i).dominated_cell.number_of_BPHs);
			//density_list_optimal_model2 <- density_list_optimal_model2 + float((node at i).dominated_cell.number_of_BPHs);
		}
		
		
		// REAL DATA (CURRENT NETWORK)
		map result1 <- nil;
		list rs <- nil;
		density_list <- density_list + CURRENT_LIGHTTRAP_COORDINATES_X + CURRENT_LIGHTTRAP_COORDINATES_Y; 
		result1 <- R_compute_param("../includes/RCode/MSE_Variogram_Exponential.R", density_list);
		rs <- result1['result'];
		MSE_VARIOGRAM <- rs[0];
		
		// SIMULATION DATA (CURRENT NETWORK)
		map result2 <- nil;
		list rs2 <- nil;
		*/
		
		

		do action: MSE_variogram_node_list_R 
		{
			arg from_node value: 0;
			arg to_node value: 47;
			arg set_at value: 0;
		}
		let _variogram type: float value: MSE_VARIOGRAM_LIST at 0;
		set MSE_VARIOGRAM_CURRENT_NETWORK value: MSE_VARIOGRAM_CURRENT_NETWORK + _variogram;
		write "MSE VARIOGRAM: ";
		write  MSE_VARIOGRAM_CURRENT_NETWORK;
		//set MSE_VARIOGRAM_OPTIMAL_NETWORK value: MSE_VARIOGRAM_OPTIMAL_NETWORK + _variogram; 
		//set MSE_VARIOGRAM_ADDED_NETWORK value: MSE_VARIOGRAM_ADDED_NETWORK  + _variogram;
		
		if(SIMULATION_STEP > BPH_LIFE_DURATION)
		{
			write "Calculated .... ";
			do action: MSE_variogram_node_list_R 
			{	
				arg from_node value: 0;
				arg to_node value: 99;
				arg set_at value: 1;
			}
			set _variogram value: MSE_VARIOGRAM_LIST at 1;
			set MSE_VARIOGRAM_OPTIMAL_NETWORK value: MSE_VARIOGRAM_OPTIMAL_NETWORK + _variogram;
			write MSE_VARIOGRAM_OPTIMAL_NETWORK;
			/*
			do action: MSE_variogram_node_list_R 
			{
				arg from_node value: 0;
				arg to_node value: 149;
				arg set_at value: 2;
			}
			*  
			*/
			do action: MSE_variogram_node_list_R 
			{	
				arg from_node value: 48;
				arg to_node value: 99;
				arg set_at value: 2;
			}
			set _variogram value: MSE_VARIOGRAM_LIST at 2;
			set MSE_VARIOGRAM_ADDED_NETWORK value: MSE_VARIOGRAM_ADDED_NETWORK + _variogram;
			write MSE_VARIOGRAM_ADDED_NETWORK;
			
			//do MSE_variogram_node_list_R from_node: 0 to_node: 99;
			//do MSE_variogram_node_list_R from_node: 50 to_node: 149;
			//do MSE_variogram_node_list_R from_node: 50 to_node: 149;
		
		}
		/*
		density_list_current_model <- density_list_current_model + CURRENT_LIGHTTRAP_COORDINATES_X + CURRENT_LIGHTTRAP_COORDINATES_Y;
		result2 <- R_compute_param("../includes/RCode/MSE_Variogram_Exponential.R", density_list_current_model);
		rs2 <- result2['result'];
		MSE_VARIOGRAM_CURRENT_MODEL <- rs2[0];
		
		
		// SIMULATION DATA (OPTIMAL NETWORK)
		map result3 <- nil;
		list rs3 <- nil;
		
		density_list_optimal_model <- density_list_optimal_model + OPTIMAL_LIGHTTRAP_COORDINATES_X + OPTIMAL_LIGHTTRAP_COORDINATES_Y;
		result3 <- R_compute_param("../includes/RCode/MSE_Variogram_Exponential.R", density_list_optimal_model);
		rs3 <- result3['result'];
		MSE_VARIOGRAM_OPTIMAL_MODEL <- rs3[0];
		* *
		*/
	}
	
	
	
	// Kriging estimation (Calling R) only on the current network:
	action estimate_Kriging_by_day_R_current_network
	{
		arg estimated_day type: int; // The day is standardized as the index!
		
		// RELATIVE TIME:
		set estimated_day value: estimated_day;// - TIME_OFFSET;
		
		
		list density_list_by_day <- nil;
		list density_list_by_day_with_grid <- nil;
		/*
		loop i from: 0 to: length(node as list) - 1
		{
			density_list_by_day <- density_list_by_day + float((node at i).density_matrix at {0, estimated_day});
		}
		 */
		//write density_list_by_day;
		
		map result <- nil;
		list rs <- nil;
		
		//result <- R_compute_param("../includes/RCode/KrigingEstimated.R", density_list_by_day);
		
		//result <- R_compute_param("../includes/RCode/KrigingGaussianNoises.R", density_list_by_day);
		
		// Preparing the parameters for R calling:
		//////(PARAMS = n | size | density list | grid coordinates)///////
		list LIGHTTRAP_COORDINATES_X <- nil;
		list LIGHTTRAP_COORDINATES_Y <- nil;
		loop i from: 0 to: NUMBER_OF_CURRENT_NODES - 1
		{
			density_list_by_day <- density_list_by_day + float((node at i).density_matrix at {0, estimated_day});
			LIGHTTRAP_COORDINATES_X <- LIGHTTRAP_COORDINATES_X + (node at i).location.x;
			LIGHTTRAP_COORDINATES_Y <- LIGHTTRAP_COORDINATES_Y + (node at i).location.y;
		}
		
		// CALLING R
		map result <- nil;
		list rs <- nil;
		
		list _header <- [length(node as list), GRID_ROW_NO, GRID_COLUMN_NO];
		//density_list_by_day_with_grid <- _header + density_list_by_day + LIGHTTRAP_COORDINATES_X + LIGHTTRAP_COORDINATES_Y + CURRENT_CELLS_COORDINATES_X + CURRENT_CELLS_COORDINATES_Y;
		//result <- R_compute_param("../includes/RCode/KrigingGaussianNoisesWithGrid.R", density_list_by_day_with_grid);
		
		//density_list_by_day <- density_list_by_day;
		
		write density_list_by_day;
		result <- R_compute_param("../includes/RCode/KrigingGaussianNoises.R", density_list_by_day);
		rs <- result['result'];
		
		write "RESULT: ";
		write rs;
		
		loop i from: 1 to: GRID_ROW_NO 
		{
			loop j from: 1 to: GRID_COLUMN_NO
			{
				ask target: cellula_automata at ((j - 1) * GRID_COLUMN_NO + (i - 1))
				{
					set number_of_BPHs value: float(rs at (((GRID_COLUMN_NO - j) * GRID_ROW_NO + (i - 1)))) * attractive_index;
					
					// Mouvable amount in the next simulation step:
					set number_of_movable_BPHs value: (1.0 - attractive_index) * number_of_BPHs;
					
					// Update the density matrix (array) 
					put item: number_of_BPHs at: {0, estimated_day} in: grid_density_matrix;
				}
			}
		}
		
		// Smooth after noises:
		
		loop i from: 0 to: length(cellula_automata)- 1
		{
			/*
			float _density <- 0.0;
			float _sum <- 0.0;
			let cell_list type: list name: cell_list value: nil;
			set cell_list <- ((cellula_automata at i) neighbours_at 1) of_species cellula_automata;
			loop j from: 0 to: length(cell_list)- 1
			{
				let the_neighbour_cell type: cellula_automata value: cellula_automata (cell_list at j);
				_sum <- _sum + the_neighbour_cell.number_of_BPHs;
			}
			_sum <- (cellula_automata at i).number_of_BPHs;
			* 
			set (cellula_automata at i).number_of_BPHs value: _sum/(length(cell_list) + 1);
			*/
			
			ask (cellula_automata at i)
			{
				do action: setcolor;
			}
		}
		/*
		do action: update_curent_density
		{
			arg estimated_day value: estimated_day;   
		}
		* 
		*/
	}
	
	
	// Kriging estimation (Calling R):
	action estimate_Kriging_by_day_R
	{
		arg estimated_day type: int; // The day is standardized as the index!
		
		// RELATIVE TIME:
		set estimated_day value: estimated_day - TIME_OFFSET;
		
		list density_list_by_day <- nil;
		list density_list_by_day_with_grid <- nil;
		/*
		loop i from: 0 to: length(node as list) - 1
		{
			density_list_by_day <- density_list_by_day + float((node at i).density_matrix at {0, estimated_day});
		}
		 */
		//write density_list_by_day;
		
		map result <- nil;
		list rs <- nil;
		
		//result <- R_compute_param("../includes/RCode/KrigingEstimated.R", density_list_by_day);
		
		//result <- R_compute_param("../includes/RCode/KrigingGaussianNoises.R", density_list_by_day);
		
		// Preparing the parameters for R calling:
		//////(PARAMS = n | size | density list | grid coordinates)///////
		list LIGHTTRAP_COORDINATES_X <- nil;
		list LIGHTTRAP_COORDINATES_Y <- nil;
		loop i from: 0 to: length(node as list) - 1
		{
			density_list_by_day <- density_list_by_day + float((node at i).density_matrix at {0, estimated_day});
			LIGHTTRAP_COORDINATES_X <- LIGHTTRAP_COORDINATES_X + (node at i).location.x;
			LIGHTTRAP_COORDINATES_Y <- LIGHTTRAP_COORDINATES_Y + (node at i).location.y;
		}
		
		// CALLING R
		map result <- nil;
		list rs <- nil;
		
		list _header <- [length(node as list), GRID_ROW_NO, GRID_COLUMN_NO];
		//density_list_by_day_with_grid <- _header + density_list_by_day + LIGHTTRAP_COORDINATES_X + LIGHTTRAP_COORDINATES_Y + CURRENT_CELLS_COORDINATES_X + CURRENT_CELLS_COORDINATES_Y;
		//result <- R_compute_param("../includes/RCode/KrigingGaussianNoisesWithGrid.R", density_list_by_day_with_grid);
		
		//density_list_by_day <- density_list_by_day;
		
		write density_list_by_day;
		result <- R_compute_param("../includes/RCode/KrigingGaussianNoises.R", density_list_by_day);
		rs <- result['result'];
		
		write "RESULT: ";
		write rs;
		
		loop i from: 1 to: GRID_ROW_NO
		{
			loop j from: 1 to: GRID_COLUMN_NO
			{
				ask target: cellula_automata at ((j - 1) * GRID_COLUMN_NO + (i - 1))
				{
					set number_of_BPHs value: float(rs at (((GRID_COLUMN_NO - j) * GRID_ROW_NO + (i - 1)))) * attractive_index;
					
					// Mouvable amount in the next simulation step:
					set number_of_movable_BPHs value: (1.0 - attractive_index) * number_of_BPHs;
					
					// Update the density matrix (array) 
					put item: number_of_BPHs at: {0, estimated_day} in: grid_density_matrix;
				}
			}
		}
		
		// Smooth after noises:
		
		loop i from: 0 to: length(cellula_automata)- 1
		{
			/*
			float _density <- 0.0;
			float _sum <- 0.0;
			let cell_list type: list name: cell_list value: nil;
			set cell_list <- ((cellula_automata at i) neighbours_at 1) of_species cellula_automata;
			loop j from: 0 to: length(cell_list)- 1
			{
				let the_neighbour_cell type: cellula_automata value: cellula_automata (cell_list at j);
				_sum <- _sum + the_neighbour_cell.number_of_BPHs;
			}
			_sum <- (cellula_automata at i).number_of_BPHs;
			* 
			set (cellula_automata at i).number_of_BPHs value: _sum/(length(cell_list) + 1);
			*/
			
			ask (cellula_automata at i)
			{
				do action: setcolor;
			}
		}
		
		do action: update_curent_density
		{
			arg estimated_day value: estimated_day;   
		}
	}
	
	
	// Loading the general weather data from the CSV file:
	action loadGeneralWeatherData
	{
		let no_of_months value: 12;
		ask target: current_natural_environment{ 
			loop i from: 0 to: (no_of_months - 1)
			{
				put item: genaral_weather_data at {i + 1, 0} at: i in: Mean_Wind_Speed;
				put item: genaral_weather_data at {i + 1, 1} at: i in: Min_Wind_Speed;
				put item: genaral_weather_data at {i + 1, 2} at: i in: Max_Wind_Speed;
				put item: genaral_weather_data at {i + 1, 3} at: i in: Wind_Direction_From;
				put item: genaral_weather_data at {i + 1, 4} at: i in: Wind_Direction_To;
			}
		}
	}
	
	// Loading the station weather data from the CSV file (Voronoi polygons):
//	action loadStationWeatherData
//	{
//		let no_of_months value: 12;
//		let no_of_stations value: length (weather_region);
//		
//		loop j from: 0 to: no_of_stations - 1 {
//			let the_weather_region type: weather_region value: weather_region at j;
//			ask target: the_weather_region{
//				loop i from: 1 to: (no_of_months * no_of_stations) {
//					if condition: the_weather_region.id = (station_weather_data at {0, i})
//					{
//						set _month  value: int (station_weather_data at {3, i});
//						// Temperature:
//						put item: station_weather_data at {5, i} at: _month - 1 in: Temp_Mean;
//						put item: station_weather_data at {6, i} at: _month - 1 in: Temp_Max;
//						put item: station_weather_data at {7, i} at: _month - 1 in: Temp_Min;
//						
//						// Rainning
//						put item: station_weather_data at {8, i} at: _month - 1 in: Rain_Amount;
//						put item: station_weather_data at {9, i} at: _month - 1 in: Rain_Max;
//						put item: station_weather_data at {10, i} at: _month - 1 in: Rain_No_Days_Max;
//						put item: station_weather_data at {11, i} at: _month - 1 in: Rain_No_Days;
//						put item: station_weather_data at {12, i} at: _month - 1 in: Rain_Mean;
//								
//						// Humidity
//						put item: station_weather_data at {13, i} at: _month - 1 in: Hum_Mean;
//						put item: station_weather_data at {14, i} at: _month - 1 in: Hum_Min;
//						put item: station_weather_data at {15, i} at: _month - 1 in: Hum_No_Days;
//								
//						// Sunning
//						put item: station_weather_data at {16, i} at: _month - 1 in: Sunning_Hours;
//						put item: station_weather_data at {17, i} at: _month - 1 in: Sunning_Hours_Mean;
//					}
//				}
//			}
//		}
//		
//		ask target: weather_region at 0
//		{
//				set temp value: Sunning_Hours_Mean;
//				set _id  value: id;
//				set _id_Data  value: station_weather_data at {0, 1};
//		}
//		
//		
//	}

	// Loading the station weather data from th DBMS file (Voronoi polygons):
	action loadStationWeatherData
	{
		let no_of_months value: 12;
		let no_of_stations value: length (weather_region);
		//write "month:"+ no_of_months + " station:"+no_of_stations;
		loop j from: 0 to: no_of_stations - 1 {
			let the_weather_region type: weather_region value: weather_region at j;
			ask target: the_weather_region{
				loop i from: 1 to: (no_of_months * no_of_stations) {
					if condition: the_weather_region.id = (station_weather_data at {0, i})
					{
						set _month  value: int (station_weather_data at {2, i});
						// Temperature:
						//write ""+ station_weather_data at {5, i} + "month "+(_month - 1) +"in:"+ Temp_Mean;
						put item: station_weather_data at {4, i} at: _month - 1 in: Temp_Mean;
						put item: station_weather_data at {5, i} at: _month - 1 in: Temp_Max;
						put item: station_weather_data at {6, i} at: _month - 1 in: Temp_Min;
						
						// Rainning
						put item: station_weather_data at {7, i} at: _month - 1 in: Rain_Amount;
						put item: station_weather_data at {8, i} at: _month - 1 in: Rain_Max;
						put item: station_weather_data at {9, i} at: _month - 1 in: Rain_No_Days_Max;
						put item: station_weather_data at {10, i} at: _month - 1 in: Rain_No_Days;
						put item: station_weather_data at {11, i} at: _month - 1 in: Rain_Mean;
								
						// Humidity
						put item: station_weather_data at {12, i} at: _month - 1 in: Hum_Mean;
						put item: station_weather_data at {13, i} at: _month - 1 in: Hum_Min;
						put item: station_weather_data at {14, i} at: _month - 1 in: Hum_No_Days;
								
						// Sunning
						put item: station_weather_data at {15, i} at: _month - 1 in: Sunning_Hours;
						put item: station_weather_data at {16, i} at: _month - 1 in: Sunning_Hours_Mean;
					}
				}
			}
		}		
		ask target: weather_region at 0
		{
				set temp value: Sunning_Hours_Mean;
				set _id  value: id;
				set _id_Data  value: station_weather_data at {0, 1};
		}
	}
	
	// INVERSE DISTANCE WEIGHTING ESTIMATION:
	action estimate_IDW_Density 
	{
		let is_sampled_point type: float value: 0.0 ;
		let distance type: float value: 0.0 ;
		set no_of_nodes value: length (node);
		
		let cnt type: int value: 0;
		loop cnt from: 0 to: no_of_nodes - 1 {
			
			put item: 0.0 at: {0, cnt} in: orthogonal_vector;
			put item: 0.0 at: {1, cnt} in: orthogonal_vector;
			put item: 0.0 at: {2, cnt} in: orthogonal_vector;
		}
		

		set cnt value: 0; 
		loop cnt from: 0 to: length (cellula_automata) - 1 {
			let the_cell type: cellula_automata value: cellula_automata at cnt;
			set is_sampled_point value: 0.0 ;
			set distance value: 0.0 ;
			set orthogonal_vector_index value: 0 ;
			set sum_distance value: 0.0 ;
			set estimated_value value: 0.0 ;
			set sum_beta value: 0.0 ;
			
			let the_node type: node value: nil;
			loop i from: 0 to: no_of_nodes - 1 
			{
			 	set the_node value: node at i;
			 				 	
				set distance value: the_cell distance_to the_node ;
				if condition: distance < 1.0 {
					set is_sampled_point value: 1.0 ;
					set estimated_value value: the_node.number_of_BPHs ;
					//set the_node.dominated_cell value: the_cell;
				}
				
				if(the_node intersects the_cell)
				{
					ask target: the_node
					{
						set dominated_cell value: the_cell;
						ask target: dominated_cell
						{
							set is_monitored value: true;
						}
					} 
				}
				
				put item: distance at: {0, orthogonal_vector_index} in: orthogonal_vector;
				put item: the_node.number_of_BPHs at: {1, orthogonal_vector_index} in: orthogonal_vector;
				
				set sum_distance value: sum_distance + float (orthogonal_vector at {0, orthogonal_vector_index}) ;
				set orthogonal_vector_index value: orthogonal_vector_index + 1 ;
			}
			
			let i type: int value: 0;
			loop i from: 0 to: no_of_nodes - 1 {
				put item: (sum_distance/ float ((orthogonal_vector) at {0, i})) at: {2, i} in: orthogonal_vector ;
				set sum_beta value: sum_beta + float (orthogonal_vector at {2, i}) ;
			}
				
			set i value: 0;
			loop i from: 0 to: no_of_nodes - 1 {
				set estimated_value value: estimated_value + (( float (orthogonal_vector at {2, i})/sum_beta) * float (orthogonal_vector at {1, i})) ;
					
				put item: 0.0 at: {0, i} in: orthogonal_vector;
				put item: 0.0 at: {1, i} in: orthogonal_vector;
				put item: 0.0 at: {2, i} in: orthogonal_vector;
				
				ask target: the_cell {
					/*if(hinder_index != 1.0)
					{
						set number_of_BPHs value: estimated_value;
					}
					else
					{
						set number_of_BPHs value: estimated_value * attractive_index;	
					}*/
					set number_of_BPHs value: estimated_value * attractive_index;
					
					// Mouvable amount in the next simulation step:
					set number_of_movable_BPHs value: (1.0 - attractive_index) * number_of_BPHs;
					
					do action: setcolor ;
				}
			}
				
		}
		
	}
	
	
	action assign_cell_to_node
	{
		let cnt value: 0;
		loop cnt from: 0 to: length (cellula_automata) - 1 
		{
			let the_cell type: cellula_automata value: cellula_automata at cnt;
			let the_node type: node value: nil;
			loop i from: 0 to: no_of_nodes - 1 
			{
				set the_node value: node at i;
						
				if(the_node intersects the_cell)
				{
					ask target: the_node
					{
						set dominated_cell value: the_cell;
					} 
				}
			}
		}
	}
	
	action update_curent_density
	{
		arg estimated_day type: int; // The day is standardized as the index!
		
		set no_of_nodes value: length (node);
		loop i from: 0 to: no_of_nodes - 1 {
			ask target: node at i
			{
				set number_of_BPHs_by_day value: float(density_matrix at {0, estimated_day});
				set number_of_BPHs value: float(dominated_cell.number_of_BPHs);
				//set number_of_BPHs value: float(density_matrix at {0, estimated_day});
				
				do action: setcolor; 
			}
		}
	}
	
	//
	// Action: estimate_IDW_by_Day
	// Purpose: Estimating the BPH density from the node's density matrix to the grid's density matrix 
	// Parameters:
	// (1) estimated_day: Estimated day
	// Built date: November 30, 2012
	//
	action estimate_IDW_by_Day
	{
		arg estimated_day type: int; // The day is standardized as the index!
		
		let is_sampled_point type: float value: 0.0 ;
		let distance type: float value: 0.0 ;
		set no_of_nodes value: length (node);
		
		let cnt type: int value: 0;
		loop cnt from: 0 to: no_of_nodes - 1 {
			put item: 0.0 at: {0, cnt} in: orthogonal_vector;
			put item: 0.0 at: {1, cnt} in: orthogonal_vector;
			put item: 0.0 at: {2, cnt} in: orthogonal_vector;
		} 
		
		do action: update_curent_density
		{
			arg estimated_day value: estimated_day;   
		}
		
		//set no_of_nodes value: length (node);
		//let mynode type: node value: nil;
		
		/*loop i from: 0 to: no_of_nodes - 1 {
			ask target: node at i
			{
				set number_of_BPHs_by_day value: float(density_matrix at {0, estimated_day});
				set number_of_BPHs value: float(density_matrix at {0, estimated_day});
				do action: setcolor; 
			}
		}
		* 
		*/
		
		set cnt value: 0;
		loop cnt from: 0 to: length (cellula_automata) - 1 {
			let the_cell type: cellula_automata value: cellula_automata at cnt;
			set is_sampled_point value: 0.0 ;
			set distance value: 0.0 ;
			set orthogonal_vector_index value: 0 ;
			set sum_distance value: 0.0 ;
			set estimated_value value: 0.0 ;
			set sum_beta value: 0.0 ;
			
			let the_node type: node value: nil;
			loop i from: 0 to: no_of_nodes - 1 
			{
				set the_node value: node at i;
				
			 	set distance value: the_cell distance_to the_node;
				if (distance < 1.0) {
					set is_sampled_point value: 1.0 ;

					//set estimated_value value: the_node.number_of_BPHs ;
					set estimated_value value: the_node.number_of_BPHs_by_day;
				}
				
				if(the_node intersects the_cell)
				{
					ask target: the_node
					{
						set dominated_cell value: the_cell;
					} 
				}
				
				put item: distance at: {0, orthogonal_vector_index} in: orthogonal_vector;
				
				//put item: the_node.number_of_BPHs at: {1, orthogonal_vector_index} in: orthogonal_vector;
				put item: the_node.number_of_BPHs_by_day at: {1, orthogonal_vector_index} in: orthogonal_vector;
				
				set sum_distance value: sum_distance + float (orthogonal_vector at {0, orthogonal_vector_index}) ;
				set orthogonal_vector_index value: orthogonal_vector_index + 1 ;
			}
			
			let i type: int value: 0;
			loop i from: 0 to: no_of_nodes - 1 {
				put item: (sum_distance/ float ((orthogonal_vector) at {0, i})) at: {2, i} in: orthogonal_vector ;
				set sum_beta value: sum_beta + float (orthogonal_vector at {2, i}) ;
			}
							
			set i value: 0;
			loop i from: 0 to: no_of_nodes - 1 {
				set estimated_value value: estimated_value + (( float (orthogonal_vector at {2, i})/sum_beta) * float (orthogonal_vector at {1, i})) ;
					
				put item: 0.0 at: {0, i} in: orthogonal_vector;
				put item: 0.0 at: {1, i} in: orthogonal_vector;
				put item: 0.0 at: {2, i} in: orthogonal_vector;
				
				ask target: the_cell {
					set number_of_BPHs value: estimated_value * attractive_index;
					
					put item: number_of_BPHs at: {0, estimated_day} in: grid_density_matrix;  
					
					// Mouvable amount in the next simulation step:
					set number_of_movable_BPHs value: (1.0 - attractive_index) * number_of_BPHs;
					
					do action: setcolor ;
				}
			}
				
		}
		
	}
	
	//
	// Action: get_number_of_BPH_by_Day 
	// Purpose: Getting the BPH density from matrix 
	// Parameters:
	// (1) estimated_day: Monitored day
	// Built date: November 30, 2012
	//

	action get_number_of_BPH_by_Day 
	{
		arg monitored_day type: int; // The day is standardized as the index! 
		
		let the_node type: node value: nil;
		loop cnt from: 0 to: no_of_nodes - 1 {
			set the_node value: node at cnt;
			let number_of_BPHs_by_day value: 0.0;
			ask target: the_node
			{
				set number_of_BPHs_by_day value: float(density_matrix at {0, monitored_day - 1}); 
			}
		}
	}
	
	// LOAD ATTRACTIVE/HINDER INDICES:
	action loadIndices
	{
		loop cnt from: 0 to: length (cellula_automata) - 1 {
			let the_cell type: cellula_automata value: cellula_automata (cellula_automata at cnt);
			let the_correlation_cell type: cellula_correlation value: cellula_correlation (cellula_correlation at cnt);
			set the_correlation_cell.attractive_index value: the_cell.attractive_index;
			set the_correlation_cell.hinder_index value: the_cell.hinder_index;
		}
	}
	
	
	// INVERSE DISTANCE WEIGHTING ESTIMATION (CORRELATION):
	action estimate_IDW_Correlation 
	{
		do loadIndices;
		
		let is_sampled_point type: float value: 0.0 ;
		let distance type: float value: 0.0 ;
		set no_of_nodes value: length (node);
		
		let cnt type: int value: 0;
		loop cnt from: 0 to: no_of_nodes - 1 {
			put item: 0.0 at: {0, cnt} in: orthogonal_vector;
			put item: 0.0 at: {1, cnt} in: orthogonal_vector;
			put item: 0.0 at: {2, cnt} in: orthogonal_vector;
		}
		

		set cnt value: 0; 
		loop cnt from: 0 to: length (cellula_correlation) - 1  {
			let the_cell type: cellula_correlation value: cellula_correlation at cnt;
			set is_sampled_point value: 0.0 ;
			set distance value: 0.0 ;
			set orthogonal_vector_index value: 0 ;
			set sum_distance value: 0.0 ;
			set estimated_value value: 0.0 ;
			set sum_beta value: 0.0 ;
			
			let the_node type: node value: nil;
			loop i from: 0 to: no_of_nodes - 1 
			{
			 	set the_node value: node at i;
			 	
				set distance value: the_cell distance_to the_node ;
				if condition: distance < 1.0 {
					set is_sampled_point value: 1.0 ;
					set estimated_value value: the_node.correlation_coefficient;
				}
				if(the_node intersects the_cell)
				{
					ask target: the_node
					{
						set dominated_cell_correlation value: the_cell;
					} 
				}
				
				put item: distance at: {0, orthogonal_vector_index} in: orthogonal_vector;
				put item: the_node.correlation_coefficient at: {1, orthogonal_vector_index} in: orthogonal_vector;
			
				set sum_distance value: sum_distance + float (orthogonal_vector at {0, orthogonal_vector_index}) ;
				set orthogonal_vector_index value: orthogonal_vector_index + 1 ;
			}
			
			let i type: int value: 0;
			loop i from: 0 to: no_of_nodes - 1 {
				put item: (sum_distance/ float ((orthogonal_vector) at {0, i})) at: {2, i} in: orthogonal_vector ;
				set sum_beta value: sum_beta + float (orthogonal_vector at {2, i}) ;
			}
				
			set i value: 0;
			loop i from: 0 to: no_of_nodes - 1 {
				set estimated_value value: estimated_value + (( float (orthogonal_vector at {2, i})/sum_beta) * float (orthogonal_vector at {1, i})) ;
					
				put item: 0.0 at: {0, i} in: orthogonal_vector;
				put item: 0.0 at: {1, i} in: orthogonal_vector;
				put item: 0.0 at: {2, i} in: orthogonal_vector;
				
				ask target: the_cell {
					
					//set number_of_movable_BPHs value: (1.0 - attractive_index) * number_of_BPHs;
					
					
					set correlation_coefficient value: estimated_value;
					do action: setcolor ;
				}
			}
				
		}
	}
	
	
	action estimate_IDW_Variance 
	{
		do loadIndices;
		
		let is_sampled_point type: float value: 0.0 ;
		let distance type: float value: 0.0 ;
		set no_of_nodes value: length (node);
		
		let cnt type: int value: 0;
		loop cnt from: 0 to: no_of_nodes - 1 {
			put item: 0.0 at: {0, cnt} in: orthogonal_vector;
			put item: 0.0 at: {1, cnt} in: orthogonal_vector;
			put item: 0.0 at: {2, cnt} in: orthogonal_vector;
		}
		
		set cnt value: 0; 
		loop cnt from: 0 to: length (cellula_correlation) - 1 {
			let the_cell type: cellula_correlation value: cellula_correlation at cnt;
			set is_sampled_point value: 0.0 ;
			set distance value: 0.0 ;
			set orthogonal_vector_index value: 0 ;
			set sum_distance value: 0.0 ;
			set estimated_value value: 0.0 ;
			set sum_beta value: 0.0 ;
			
			let the_node type: node value: nil;
			loop i from: 0 to: no_of_nodes - 1 
			{
			 	set the_node value: node at i;
			 	
				set distance value: the_cell distance_to the_node ;
				if condition: distance < 1.0 {
					set is_sampled_point value: 1.0 ;
					set estimated_value value: the_node.sample_variance;
				}
				if(the_node intersects the_cell)
				{
					ask target: the_node
					{
						set dominated_cell_correlation value: the_cell;
					}
				}
				
				
				put item: distance at: {0, orthogonal_vector_index} in: orthogonal_vector;
				put item: the_node.sample_variance at: {1, orthogonal_vector_index} in: orthogonal_vector;
				
				set sum_distance value: sum_distance + float (orthogonal_vector at {0, orthogonal_vector_index}) ;
				set orthogonal_vector_index value: orthogonal_vector_index + 1 ;
			}
			
			let i type: int value: 0;
			loop i from: 0 to: no_of_nodes - 1 {
				put item: (sum_distance/ float ((orthogonal_vector) at {0, i})) at: {2, i} in: orthogonal_vector ;
				set sum_beta value: sum_beta + float (orthogonal_vector at {2, i}) ;
			}
			
			set i value: 0;
			loop i from: 0 to: no_of_nodes - 1 {
				set estimated_value value: estimated_value + (( float (orthogonal_vector at {2, i})/sum_beta) * float (orthogonal_vector at {1, i})) ;
					
				put item: 0.0 at: {0, i} in: orthogonal_vector;
				put item: 0.0 at: {1, i} in: orthogonal_vector;
				put item: 0.0 at: {2, i} in: orthogonal_vector;
				
				ask target: the_cell {
					//set number_of_movable_BPHs value: (1.0 - attractive_index) * number_of_BPHs;
					set sample_variance value: estimated_value;
					do action: setcolor_as_variance;
				}
			}
		}
	}
	
	//
	// ACTION: dispatchByWind
	// Built date: June 05, 2012
	//
	action dispatchByWind
	{
		loop i from: 0 to: (COLUMNS_NO * ROWS_NO) - 1
		{
			// Dispatch by wind:
			if((cellula_automata at i).number_of_BPHs > PROPAGATION_DENSITY_THRESHOLD)
			{
				do action: propagateInSemiRound
				{
					arg source_cell value: cellula_automata at i;
				}
			}
		}
		
		loop i from: 0 to: (COLUMNS_NO * ROWS_NO) - 1
		{
			let _density_rate type: float value: 0.0;
			ask target: cellula_automata at i
			{
				
				let _before_number_of_BPHs type: float value: number_of_BPHs;
				set number_of_BPHs value: (number_of_BPHs + in_number_of_BPHs - out_number_of_BPHs) * (1 - hinder_index);
				
				set in_number_of_BPHs value: 0.0;
				set out_number_of_BPHs value: 0.0;
				set number_of_movable_BPHs value: number_of_BPHs * attractive_index; // for the next step
				
				// Re-update the list of densities:
				if(_before_number_of_BPHs != 0.0)
				{
					set _density_rate value: number_of_BPHs / _before_number_of_BPHs;
				}
				else
				{
					set _density_rate value: 1.0;
				}
				
				do action: updateAdultDensities // Reset the densities of adult BPHs
				{
					arg density_rate value: _density_rate;
				}
				
				do action: setcolor;
			}
		}
	}
	
	action dispatchByFood
	{
		//....		
	}

	
	//
	// Propagation model: Applied for one cell
	// Built date: June 05, 2012
	//
	action propagateInSemiRound
	{
		// ARGUMENTS:
		arg source_cell type: cellula_automata;
		
		
		// INTERNAL VARIABLES:
		let alpha type: float value: current_udg.alpha;
		
		//let cell_list type: list value: (list species cellula_automata)  where ((cellula_automata (each) distance_to source_cell) <= DISK_RADIUS) ;
		let cell_list type: list value: (list (cellula_automata))  where ((cellula_automata (each) distance_to source_cell) <= DISK_RADIUS) ;
		
		
		let cell_list_under_wind type: list value: cell_list; 
		
		// OPERATIONS:
		set sum_attractive_index value: 0.0;
		set sum_hinder_index value: 0.0;
		set _count value: _count + 1;
		
		loop i from: 0 to: length(cell_list) - 1
		{
			let the_neighbour_cell type: cellula_automata value: cellula_automata (cell_list at i);
				
			set x1  value: (float(((source_cell) . location) . x));  
			set y1  value: (float(((source_cell) . location) . y));						
			set x2  value: (float(((the_neighbour_cell) . location) . x));  
			set y2  value: (float(((the_neighbour_cell) . location) . y));
						
			// Calculating the maximum location:
			set x1_to  value: (float (x1 + float(DISK_RADIUS * float(float (cos(alpha))))));
			set y1_to value: (float (y1 + float(DISK_RADIUS * float(float(sin(alpha))))));
										
			let vv12 type: float value:0.0; 
			set vv12 value: (((x1_to - x1) * (x2 - x1)) + ((y1_to - y1) * (y2 - y1))); 
			let length_v1 type: float value: 0.0;
			set length_v1 value: (sqrt(((x1_to - x1) * (x1_to - x1)) + ((y1_to - y1) * (y1_to - y1))));
			let length_v2 type: float value: 0.0;
			set length_v2 value: (sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2))) + 1.0; // + 1.0: Avoide the "Divide by zero" error!
								
			let beta type: float value: acos( ((vv12) / ( length_v1 * length_v2 )));
			if(beta <= 90 )
			{
				// Updating the sum value of attractive/hinder indices:
				set sum_attractive_index value: sum_attractive_index + the_neighbour_cell.attractive_index;
				set sum_hinder_index value: sum_hinder_index + the_neighbour_cell.hinder_index;
			}
			else
			{
				set cell_list_under_wind value: cell_list_under_wind - the_neighbour_cell;
			}
		}
		
		// Reset the densities:
		loop i from: 0 to: length(cell_list_under_wind) - 1
		{
			let the_under_cell type: cellula_automata value: cellula_automata (cell_list_under_wind at i);
			ask target: the_under_cell
			{
				set in_number_of_BPHs value: in_number_of_BPHs + source_cell.number_of_movable_BPHs * (attractive_index / sum_attractive_index);
			}				
		}

		ask target: source_cell
		{
			set out_number_of_BPHs value: number_of_movable_BPHs;
		}			
					
	}
	
	action getCorrelationTwoDays
	{
		let vectorX type: list  value: nil;
		let vectorY type: list  value: nil;
		
		loop i from: 0 to: length (node) - 1
		{ 
			ask node at i
			{
				set vectorX value: vectorX + [float(density_matrix at {0, SIMULATION_STEP})];
				set vectorY value: vectorY + [float(density_matrix at {0, SIMULATION_STEP+1})];
				//put item: float(density_matrix at {0, simStep}) at: i in: vectorX;
				//put item: float(density_matrix at {0, simStep+1}) at: i in: vectorY;
			}
		}
			
		set twoDaysCorrelation value: float(corR(vectorX, vectorY));
		set twoDaysCorrelationAVG value: (twoDaysCorrelationAVG * SIMULATION_STEP + twoDaysCorrelation)  / (SIMULATION_STEP + 1);   
		//set simStep value: simStep + 1;
	}
	
	action getsCorrelationByEdges
	{
		let vectorX type: list value: nil;
		let vectorY type: list value: nil;
		
		
		loop i from: 0 to: length (_edge) - 1
		{ 
			ask _edge at i
			{
				let source_node type: node value: source;
				let destination_node type: node value: destination;
				ask source_node
				{
					set vectorX value: vectorX + [float(density_matrix at {0, SIMULATION_STEP})];
					
					//put item: float(density_matrix at {0, simStep}) at: i in: vectorX;
				}
				ask destination_node
				{
					set vectorY value: vectorY + [float(density_matrix at {0, SIMULATION_STEP})];
					//put item: float(density_matrix at {0, simStep}) at: i in: vectorY;
				}
				
			}
		}
		
		set edgesCorrelation value: float(corR(vectorX, vectorY));
		set edgesCorrelationAVG value: (edgesCorrelationAVG * SIMULATION_STEP + edgesCorrelation)  / (SIMULATION_STEP + 1);   
		//set simStep value: simStep + 1;
	}
}

environment bounds: SHAPE_ADMINISTRATIVE_THREE_PROVINCES //SHAPE_ADMINISTRATIVE_PROVINCE  
{
	grid cellula_std_deviation width: 60 height: 60 neighbours: 8
	{
		// Kriging estimation:
		var estimation_std_deviation type: float init: 0.001;
		
		// Adding the hinder index:
		var hydrid_std_deviation type: float init: 0.001;
		
		// Tabu search support:
		var isTabu type: bool init: false;
		
		var color type: rgb init: rgb('white') ;
		var maximum_std_deviation type: float init: 2200.0;
		
		var z type: float init: 0.0;
		
		aspect elevation{
			draw shape: geometry color: color;
		}
		
		
		action aspect_by_std_deviation {
					set color value: (estimation_std_deviation > 0.80 * maximum_std_deviation)?rgb([255,0,0]):        
					((estimation_std_deviation > 0.75 * maximum_std_deviation)?rgb([255,30,17]):        
					((estimation_std_deviation > 0.60 * maximum_std_deviation)?rgb([255,55,29]):        
					((estimation_std_deviation > 0.55 * maximum_std_deviation)?rgb([255,80,41]):        
					((estimation_std_deviation > 0.50 * maximum_std_deviation)?rgb([255,105,53]):        
					((estimation_std_deviation > 0.45 * maximum_std_deviation)?rgb([255,130,65]):        
					((estimation_std_deviation > 0.40 * maximum_std_deviation)?rgb([255,155,77]):        
					((estimation_std_deviation > 0.38 * maximum_std_deviation)?rgb([255,180,89]):        
					((estimation_std_deviation > 0.36 * maximum_std_deviation)?rgb([255,205,101]):        
					((estimation_std_deviation > 0.34 * maximum_std_deviation)?rgb([255,230,113]):        
					((estimation_std_deviation > 0.32 * maximum_std_deviation)?rgb([255,255,125]):        
					((estimation_std_deviation > 0.30 * maximum_std_deviation)?rgb([230,230,137]):        
					((estimation_std_deviation > 0.28 * maximum_std_deviation)?rgb([205,205,149]):        
					((estimation_std_deviation > 0.26 * maximum_std_deviation)?rgb([180,180,161]):        
					((estimation_std_deviation > 0.24 * maximum_std_deviation)?rgb([155,155,173]):        
					((estimation_std_deviation > 0.22 * maximum_std_deviation)?rgb([130,130,185]):        
					((estimation_std_deviation > 0.20 * maximum_std_deviation)?rgb([105,105,197]):        
					((estimation_std_deviation > 0.15 * maximum_std_deviation)?rgb([80,80,209]):        
					((estimation_std_deviation > 0.10 * maximum_std_deviation)?rgb([55,55,221]):        
					((estimation_std_deviation > 0.05 * maximum_std_deviation)?rgb([30,30,233]):
					rgb([0, 0,255])))))))))))))))))))) ;
					
					// 3D model
					set z value: (estimation_std_deviation/maximum_std_deviation) * 300;
					//set z value: (maximum_std_deviation*estimation_std_deviation) * 300;
		}
		
		action aspect_by_hydrid_std_deviation {
					set maximum_std_deviation value: maximum_std_deviation * 1.5;
					
					set color value: (hydrid_std_deviation > 0.80 * maximum_std_deviation)?rgb([255,0,0]):        
					((hydrid_std_deviation > 0.75 * maximum_std_deviation)?rgb([255,30,17]):        
					((hydrid_std_deviation > 0.60 * maximum_std_deviation)?rgb([255,55,29]):        
					((hydrid_std_deviation > 0.55 * maximum_std_deviation)?rgb([255,80,41]):        
					((hydrid_std_deviation > 0.50 * maximum_std_deviation)?rgb([255,105,53]):        
					((hydrid_std_deviation > 0.45 * maximum_std_deviation)?rgb([255,130,65]):        
					((hydrid_std_deviation > 0.40 * maximum_std_deviation)?rgb([255,155,77]):        
					((hydrid_std_deviation > 0.38 * maximum_std_deviation)?rgb([255,180,89]):        
					((hydrid_std_deviation > 0.36 * maximum_std_deviation)?rgb([255,205,101]):        
					((hydrid_std_deviation > 0.34 * maximum_std_deviation)?rgb([255,230,113]):        
					((hydrid_std_deviation > 0.32 * maximum_std_deviation)?rgb([255,255,125]):        
					((hydrid_std_deviation > 0.30 * maximum_std_deviation)?rgb([230,230,137]):        
					((hydrid_std_deviation > 0.28 * maximum_std_deviation)?rgb([205,205,149]):        
					((hydrid_std_deviation > 0.26 * maximum_std_deviation)?rgb([180,180,161]):        
					((hydrid_std_deviation > 0.24 * maximum_std_deviation)?rgb([155,155,173]):        
					((hydrid_std_deviation > 0.22 * maximum_std_deviation)?rgb([130,130,185]):        
					((hydrid_std_deviation > 0.20 * maximum_std_deviation)?rgb([105,105,197]):        
					((hydrid_std_deviation > 0.15 * maximum_std_deviation)?rgb([80,80,209]):        
					((hydrid_std_deviation > 0.10 * maximum_std_deviation)?rgb([55,55,221]):        
					((hydrid_std_deviation > 0.05 * maximum_std_deviation)?rgb([30,30,233]):
					rgb([0, 0,255])))))))))))))))))))) ;
					
					// 3D model
					set z value: (hydrid_std_deviation/maximum_std_deviation) * 300 * 1.5;
					//set z value: (estimation_std_deviation/maximum_std_deviation) * 300;
		}
		
	}
	
	grid cellula_correlation width: 60 height: 60 neighbours: 8
	{
		const id type: string ;
		const name type: string ;
							
		float correlation_coefficient <- 0.001;
		var sample_variance type: float init: 0.001;
		// FOR TRAP (Temp)
		var trap_correlation_coefficient type: float init: 0.001;
		
		var color type: rgb init: rgb('white') ;
		
		
		// TWO PRINCIPAL INDICES 			
		var attractive_index type: float init: 0.001 ;
		var hinder_index type: float init: 1.0 ;
		
		
		action setcolor {
					set color value: (correlation_coefficient > 0.80)?rgb([255,0,0]):        
					((correlation_coefficient > 0.75)?rgb([255,30,17]):        
					((correlation_coefficient > 0.60)?rgb([255,55,29]):        
					((correlation_coefficient > 0.55)?rgb([255,80,41]):        
					((correlation_coefficient > 0.50)?rgb([255,105,53]):        
					((correlation_coefficient > 0.45)?rgb([255,130,65]):        
					((correlation_coefficient > 0.40)?rgb([255,155,77]):        
					((correlation_coefficient > 0.38)?rgb([255,180,89]):        
					((correlation_coefficient > 0.36)?rgb([255,205,101]):        
					((correlation_coefficient > 0.34)?rgb([255,230,113]):        
					((correlation_coefficient > 0.32)?rgb([255,255,125]):        
					((correlation_coefficient > 0.30)?rgb([230,230,137]):        
					((correlation_coefficient > 0.28)?rgb([205,205,149]):        
					((correlation_coefficient > 0.26)?rgb([180,180,161]):        
					((correlation_coefficient > 0.24)?rgb([155,155,173]):        
					((correlation_coefficient > 0.22)?rgb([130,130,185]):        
					((correlation_coefficient > 0.20)?rgb([105,105,197]):        
					((correlation_coefficient > 0.15)?rgb([80,80,209]):        
					((correlation_coefficient > 0.10)?rgb([55,55,221]):        
					((correlation_coefficient > 0.05)?rgb([30,30,233]):
					rgb([0, 0,255])))))))))))))))))))) ;
		}
		
		action setcolor_as_variance {
					set color value: (sample_variance > (0.80 * 24))?rgb([255,0,0]):        
					((sample_variance > (0.75 * 24))?rgb([255,30,17]):        
					((sample_variance > (0.60 * 24))?rgb([255,55,29]):        
					((sample_variance > (0.55 * 24))?rgb([255,80,41]):        
					((sample_variance > (0.50 * 24))?rgb([255,105,53]):        
					((sample_variance > (0.45 * 24))?rgb([255,130,65]):        
					((sample_variance > (0.40 * 24))?rgb([255,155,77]):        
					((sample_variance > (0.38 * 24))?rgb([255,180,89]):        
					((sample_variance > (0.36 * 24))?rgb([255,205,101]):        
					((sample_variance > (0.34 * 24))?rgb([255,230,113]):        
					((sample_variance > (0.32 * 24))?rgb([255,255,125]):        
					((sample_variance > (0.30 * 24))?rgb([230,230,137]):        
					((sample_variance > (0.28 * 24))?rgb([205,205,149]):        
					((sample_variance > (0.26 * 24))?rgb([180,180,161]):        
					((sample_variance > (0.24 * 24))?rgb([155,155,173]):        
					((sample_variance > (0.22 * 24))?rgb([130,130,185]):        
					((sample_variance > (0.20 * 24))?rgb([105,105,197]):        
					((sample_variance > (0.15 * 24))?rgb([80,80,209]):        
					((sample_variance > (0.10 * 24))?rgb([55,55,221]):        
					((sample_variance > (0.05 * 24))?rgb([30,30,233]):
					rgb([0, 0,255])))))))))))))))))))) ;
					
					set shape <- shape add_z sample_variance;
		}
	}
	
	grid cellula_automata width: 60 height: 60 neighbours: 8
	{
		const id type: string ;
		const name type: string ;
		var square_area type: float ;
		
		// TWO PRINCIPAL INDICES 			
		var attractive_index type: float init: 0.001 ;
		var hinder_index type: float init: 1.0 ;
				
		
		// Transplantation indices:
		var based_transplantation_index type: float init: 0.0 ; // By default: grass, other plants ...
		var WS_transplantation_index type: float init: 0.0;
		var SA_transplantation_index type: float init: 0.0;
		
		// Weather indices:
		var humidity_index type: float init: 0.0;
		var temperature_index type: float init: 0.0;
		var weather_index type: float init: 0.0;
		//var raining_index type: float init: 0.0;
				
		// Sea & river region:
		var is_sea_region type: bool init: false;
		var is_monitored type: bool init: false;
		var is_in_land_planted type: bool value: false;
		
			
		// Brown Plant Hopper:
		var number_of_BPHs type: float init: 0.0 ;
		var regression_count type: int init: 0 ;
		matrix grid_density_matrix size: {1, 32}; // Containing density of BPHs for all stages of life cycle
		
		// PROPAGATION VARIABLES
		var number_of_movable_BPHs type: float init: 0.0 ; // Depending on the local conditions (Determined by the attractive and hinder indices)
		var out_number_of_BPHs type: float init: 0.0 ;
		var in_number_of_BPHs type: float init: 0.0 ;
		
		var color type: rgb init: rgb('white') ;
		var _discretized type: int init: 0;
		var _month_changed type: int init: 0;
		
		var z type: float init: 0.0;
		
		aspect ThreeDirections
		{
			//let shape_to_display type: geometry <- (shape + 1.0) add_z hinder_index * 100;
			//draw geometry: shape_to_display color: rgb('red');
			draw shape: geometry color: color;
		} 
						
		reflex Step
		{
			//write "CELLULA_AUTOMATA: " + SIMULATION_STEP;
			if(_discretized = 0) // Hinder and Attractive indixes are not updated! 
			{
				write "WHY WHY WHY?";
				
				
				do action: initializeHinderAndAttractiveIndices;
				do action: updateHinderAndAttractiveIndices;
				set _discretized value: 1; 
			}
			
			set _month_changed value: MONTH_CHANGED;
			
			if(_month_changed = 0) // Hinder and Attractive indixes are not updated! 
			{
				write "MONTH_CHANGED " + MONTH_CHANGED + " AT " + SIMULATION_STEP;
				
				do action: updateHinderAndAttractiveIndices;
				set _month_changed value: 1; 
			}

			
			if(SIMULATION_STEP > BPH_LIFE_DURATION)
			{
				do action: growthCycle;
				do action: setcolor;
			}
			else if(SIMULATION_STEP = BPH_LIFE_DURATION)
			{
				do action: updateDensityCycle2;
			}
		}

		action initializeHinderAndAttractiveIndices{
			
			// Overlapping with transplantation area (From transplantation map):
			//let is_in_land_planted type: bool value: false;
			
			loop i from: 0 to: length(province_region) - 1
			{
				let the_province_region type: province_region value: province_region (province_region at i);
				if self intersects the_province_region
				{
					set is_in_land_planted value: true;
				}
			}
			
			
			loop i from: 0 to: length(WS_rice_region) - 1
			{
				let the_rice_region type: WS_rice_region value: WS_rice_region (WS_rice_region at i);
				
				if self intersects the_rice_region
				{
					//set rice_area value: rice_area + 0.4;
					set WS_transplantation_index value: WINTER_SPRING_SEASON_COEF;
				}
			}
			
			loop i from: 0 to: length(SA_rice_region) - 1
			{
				let the_rice_region type: SA_rice_region value: SA_rice_region (SA_rice_region at i);
				
				if self intersects the_rice_region
				{
					//set rice_area value: rice_area + 0.4;
					set SA_transplantation_index value: SUMMER_AUTUMN_SEASON_COEF;
				}
			}
			
			// SEA REGION
			loop i from: 0 to: length(sea_region) - 1
			{
				let the_sea_region type: sea_region value: sea_region (sea_region at i);
				
				if self intersects the_sea_region																																															
				{
					//set rice_area value: rice_area + 0.4;
					set is_sea_region value: true;
				}
			}
			
			
			
			// Temperature:
			let Temp_Mean type: float value: 0.0; 
			let Temp_Max type: float value: 0.0; 
			let Temp_Min type: float value: 0.0; 
			
			// Rainning
			let Rain_Amount type: float value: 0.0; 
			let Rain_Max type: float value: 0.0; 
			let Rain_No_Days_Max type: float value: 0.0; 
			let Rain_No_Days type: float value: 0.0; 
			let Rain_Mean type: float value: 0.0; 
			
			// Humidity
			let Hum_Mean type: float value: 0.0; 
			let Hum_Min type: float value: 0.0; 
			let Hum_No_Days type: float value: 0.0; 
			
			// Sunning
			let Sunning_Hours type: float value: 0.0; 
			let Sunning_Hours_Mean type: float value: 0.0; 
			
			// Wind velocity:
			let Mean_Wind_Velocity type: float value: 0.0; 
			let Min_Wind_Velocity type: float value: 0.0; 
			let Max_Wind_Velocity type: float value: 0.0; 
			
			// Wind direction:
			let Wind_Direction_From type: float value: 0.0; 
			let Wind_Direction_To type: float value: 0.0;
			
			// Weather index:
			//let weather_index type: float value: 0.0;

			/*
			loop i from: 0 to: length(weather_region) - 1
			{
				let the_weather_region type: weather_region value: weather_region at i;
				if self intersects the_weather_region
				{
					
					// Temperature:
					set Temp_Mean  value: the_weather_region.Temp_Mean at (sim_Month - 1); 
					set Temp_Max  value: the_weather_region.Temp_Max at (sim_Month - 1); 
					set Temp_Min  value: the_weather_region.Temp_Min at (sim_Month - 1); 
							
					// Rainning
					set Rain_Amount  value: the_weather_region.Rain_Amount at (sim_Month - 1); 
					set Rain_Max  value: the_weather_region.Rain_Max at (sim_Month - 1); 
					set Rain_No_Days_Max  value: the_weather_region.Rain_No_Days_Max at (sim_Month - 1); 
					set Rain_No_Days  value: the_weather_region.Rain_No_Days at (sim_Month - 1); 
					set Rain_Mean  value: the_weather_region.Rain_Mean  at (sim_Month - 1); 
							
					// Humidity
					set Hum_Mean  value: the_weather_region.Hum_Mean  at (sim_Month - 1); 
					set Hum_Min  value: the_weather_region.Hum_Min  at (sim_Month - 1); 
					set Hum_No_Days  value: the_weather_region.Hum_No_Days  at (sim_Month - 1); 
							
					// Sunning
					set Sunning_Hours  value: the_weather_region.Sunning_Hours  at (sim_Month - 1); 
					set Sunning_Hours_Mean  value: the_weather_region.Sunning_Hours_Mean  at (sim_Month - 1);
					* 
					* 
 
					
					set weather_index  value: the_weather_region.general_weather_index  at (sim_Month - 1);
				}
			}
			*/			
			
			// Set up the general weather parameters (homogeneous):
			let Mean_Wind_Speed type: float value: current_natural_environment.Mean_Wind_Speed;
			let Min_Wind_Speed type: float value: current_natural_environment.Min_Wind_Speed;
			let Max_Wind_Speed type: float value: current_natural_environment.Max_Wind_Speed;
			let Wind_Direction_From type: float value: current_natural_environment.Wind_Direction_From;
			let Wind_Direction_To type: float value: current_natural_environment.Wind_Direction_To;
			
			if(is_in_land_planted)
			{
				set based_transplantation_index value: BASED_SEASON_COEF;
				set attractive_index value: based_transplantation_index + WS_transplantation_index + SA_transplantation_index;
				set hinder_index value: 1.0 - attractive_index;
			}
			
			if condition: (is_sea_region) //(!in_land)
			{
				set hinder_index value: 1.0;
			}
			
		}
		//
		// Action: updateHinderAndAttractiveIndices
		// Built date: June 24, 2013
		//
		action updateHinderAndAttractiveIndices{
			loop i from: 0 to: length(weather_region) - 1
			{
				let the_weather_region type: weather_region value: weather_region at i;
				if self intersects the_weather_region
				{
					set weather_index  value: the_weather_region.general_weather_index  at (sim_Month - 1);
				}
			}
			
			/* 
			
			if(is_in_land_planted)
			{
				set based_transplantation_index value: BASED_SEASON_COEF;
				let local_index value: based_transplantation_index + WS_transplantation_index + SA_transplantation_index;
				set attractive_index value: (local_index + weather_index)/2;
				set hinder_index value: 1.0 - attractive_index;
			}
			
			if condition: (is_sea_region) //(!in_land)
			{
				set hinder_index value: 1.0;
			}
			*/
			
			write "updateHinderAndAttractiveIndices() IS CALLED! at " + SIMULATION_STEP ;
		}
		//
		// Action: updateRiceAge (or RiceGrowthModel)
		// Built date: June 06, 2013
		//
		action updateRiceAge{
			
		}
		//
		// Action: updateWeatherIndex (or ClimateChangedModel)
		// Built date: June 06, 2013
		//
		action updateWeatherIndex{
			
		}
		
		//
		// Action: updateDensityCycle
		// Built date: December 04, 2012
		//
		action updateDensityCycle
		{
			loop i from: 0 to: BPH_LIFE_DURATION - 1
			{
				let _duration type: int value: BPH_LIFE_DURATION - (i + 1);
				let _density type: float value: grid_density_matrix at {0, i};
				let egg_duration type: int value: 0; 
				let nymph_duration type: int value: 0;  
				let adult_duration type: int value: 0;
				
				let egg_number type: float value: _density * ADULT_EGG_RATE;
				
				// Update the duration of each stage: 
				let age type: int value: _duration;
				if(age > (EGG_DURATION + NYMPH_DURATION))
				{
					set adult_duration value: age - (EGG_DURATION + NYMPH_DURATION);
					set age value: (EGG_DURATION + NYMPH_DURATION);
				}
					
				if (age > EGG_DURATION)
				{
					set nymph_duration value: age - EGG_DURATION;
					set age value: EGG_DURATION;
				}
					
				set egg_duration value: age;
					
				// Update the real density:
				set _density value: egg_number * (EGG_NYMPH_RATE ^ egg_duration);
				set _density value: _density * (NYMPH_ADULT_RATE ^ nymph_duration);
				
				// Kiem tra lai:
				
				set _density value: _density - _density * adult_duration * NATURAL_MORTALITY_RATE;
				
				put item: _density at: {0, i} in: grid_density_matrix;
			}
		}
		
		action updateDensityCycle2
		{
			let _mortality_rate  type: float value: NATURAL_MORTALITY_RATE + MORTALITY_RATE_BY_PREDACTORS;
			let _last_date_density type: float value: grid_density_matrix at {0, (BPH_LIFE_DURATION - 1)};
			
			loop i from: 0 to: BPH_LIFE_DURATION - 1
			{
				let _duration type: int value: BPH_LIFE_DURATION - (i + 1);
				let _density type: float value: grid_density_matrix at {0, i};
				let egg_duration type: int value: 0; 
				let nymph_duration type: int value: 0;  
				let adult_duration type: int value: 0;
				
				set _density value: _density * ADULT_EGG_RATE;
				
				// Update the duration of each stage: 
				let age type: int value: _duration;
				
				if(age > (EGG_DURATION + NYMPH_DURATION))
				{
					set adult_duration value: age - (EGG_DURATION + NYMPH_DURATION);
					set age value: (EGG_DURATION + NYMPH_DURATION);
					//set _density value: _density * NYMPH_ADULT_RATE;
				}
					
				if (age > EGG_DURATION)
				{
					set nymph_duration value: age - EGG_DURATION;
					set age value: EGG_DURATION;
					//set _density value: egg_number * EGG_NYMPH_RATE;
				}
				
				set egg_duration value: age;


				// Update the real density:
				set _density value: _density * ((1 - _mortality_rate) ^ egg_duration);
				set _density value: _density * EGG_NYMPH_RATE;
				
				set _density value: _density * ((1 - _mortality_rate) ^ nymph_duration);
				set _density value: _density * NYMPH_ADULT_RATE;
				set _density value: _density * ((1 - _mortality_rate) ^ adult_duration);
				put item: _density at: {0, i} in: grid_density_matrix;
				
				/** 
				set _density value: _density * (( 1 - _mortality_rate)^_duration);
				*/
				
				if(i <= ADULT_DURATION - 1)
				{
					set _density value:  _last_date_density / ADULT_DURATION;
					put item: _density at: {0, i} in: grid_density_matrix;
				}
				else
				{
					put item: _density at: {0, i} in: grid_density_matrix;
				}
				
			}
			
		}
		
		action updateAdultDensities // Reset the densities of adult BPHs (CALLED in Dispatch by Wind)
		{
			arg density_rate type: float; 
			loop i from: 0 to: ADULT_DURATION - 1
			{
				let _density type: float value: grid_density_matrix at {0, i};
				put item: (_density * density_rate) at: {0, i} in: grid_density_matrix;
			}
		}
		//
		// Growth model: Applied for one cell
		// Built date: December 04, 2012
		//
 		action growthCycle {
			let _mortality_rate  type: float value: NATURAL_MORTALITY_RATE + MORTALITY_RATE_BY_PREDACTORS;
			let _density_sum type: float value: 0.0;
			let _density_born type: float value: 0.0;
			let _density_born_sum type: float value: 0.0;
			
			loop i from: 0 to: BPH_LIFE_DURATION - 2 {
				//let _density type: float value: float(grid_density_matrix at {0, i});
				let _density_previous type: float value: float(grid_density_matrix at {0, (i + 1)});
				let _density type: float value: _density_previous - (_density_previous * _mortality_rate);
				put item: _density at: {0, i} in: grid_density_matrix;
				
				// Sum all densities of adult satges (11 days):
				
				if((i >= 0) and (i <= (ADULT_DURATION - 1))) {
					set _density_sum value: _density_sum + _density;
					
					// EGGS BORN
					if((i >= (ADULT_DURATION - ADULT_DURATION_GIVING_BIRTH_DURATION - 1))) {
						set _density_born_sum value: _density_born_sum + _density * ADULT_EGG_RATE;
					} 
				}
			}
			
			// UPDATE THE EGG NUMBER OF FIRST DAY   
			put item: _density_born_sum at: {0, BPH_LIFE_DURATION - 1} in: grid_density_matrix;
			
			set number_of_BPHs value: _density_sum;
		}
		
		action setcolor {
			set color value: (number_of_BPHs > 10000)?rgb([255,0,0]):        
					((number_of_BPHs > 7500)?rgb([255,30,17]):        
					((number_of_BPHs > 5000)?rgb([255,55,29]):        
					((number_of_BPHs > 2500)?rgb([255,80,41]):        
					((number_of_BPHs > 1000)?rgb([255,105,53]):        
					((number_of_BPHs > 750)?rgb([255,130,65]):        
					((number_of_BPHs > 500)?rgb([255,155,77]):        
					((number_of_BPHs > 250)?rgb([255,180,89]):        
					((number_of_BPHs > 200)?rgb([255,205,101]):        
					((number_of_BPHs > 150)?rgb([255,230,113]):        
					((number_of_BPHs > 100)?rgb([255,255,125]):        
					((number_of_BPHs > 90)?rgb([230,230,137]):        
					((number_of_BPHs > 80)?rgb([205,205,149]):        
					((number_of_BPHs > 70)?rgb([180,180,161]):        
					((number_of_BPHs > 60)?rgb([155,155,173]):        
					((number_of_BPHs > 50)?rgb([130,130,185]):        
					((number_of_BPHs > 40)?rgb([105,105,197]):        
					((number_of_BPHs > 30)?rgb([80,80,209]):        
					((number_of_BPHs > 20)?rgb([55,55,221]):        
					((number_of_BPHs > 10)?rgb([30,30,233]):
					rgb([0, 0,255])))))))))))))))))))) ;

					// 3D model
					set z value: (hinder_index) * 100;
		}
	}
}
experiment RunModel type:gui{
	

output {
	display GlobalView {
		grid cellula_automata transparency: 0;
		species WS_rice_region transparency: 0.7;
		species district_region transparency: 0.8 ;
		species province_region transparency: 0.8 ;
		//species UnitDiskGraph transparency: 0.5 ;
		species sea_region transparency: 0 ;
		species node  aspect: default transparency: 0;
		species _edge aspect: default  transparency: 0 ;
		
		//species weather_region aspect: default  transparency: 0.5 ;
		
	}
	
	display GlobalView3D type:opengl{
		species cellula_automata aspect: ThreeDirections;
		species node  aspect: ThreeDirections transparency: 0;
		species _edge aspect: default  transparency: 0 ;
	}
	
	display GlobalCorrelation {
		grid cellula_correlation transparency: 0;
		species node  aspect: default transparency: 0;
		species _edge aspect: default  transparency: 0 ;
		species sea_region transparency: 0.7;
	}
	
	display StandardErrors type:opengl {
		species cellula_std_deviation aspect: elevation;
		species node  aspect: ThreeDirections transparency: 0;
		species _edge aspect: default  transparency: 0 ;
	}
	
	display Weather{
		species weather_region;
	}
	
	
	
	display MovingCorrelationChart_Graph {
		chart name: "BPHs density via days (from dd/mm/yyyy)" type: "series" {
			data "Correlation between all two consecutive days" value: twoDaysCorrelation color:#blue;
			data "Accumulative average of correlation" value: twoDaysCorrelationAVG color:#red;
		}
	}
	
	display EdgesCorrelationChart_Graph {
		chart name: "BPHs density via days (from dd/mm/yyyy)" type: series {
			data "Correlation between all edges" value: edgesCorrelation color:#blue;
			data "Accumulative average of correlation" value: edgesCorrelationAVG color:#red;
		}
	}
//	
//	display chart_display_real_trap_density {
//  		chart  "Trapped-Desnity" type: series {
//  		data T1 value: (node at 0).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T2 value: (node at 1).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T3 value: (node at 2).number_of_BPHs_by_day color: rgb('red') ;
//  		data T4 value: (node at 3).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T5 value: (node at 4).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T6 value: (node at 5).number_of_BPHs_by_day color: rgb('red') ;
//  		data T7 value: (node at 6).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T8 value: (node at 7).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T9 value: (node at 8).number_of_BPHs_by_day color: rgb('red') ;
//  		data T10 value: (node at 9).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T11 value: (node at 10).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T12 value: (node at 11).number_of_BPHs_by_day color: rgb('red') ;
//  		data T13 value: (node at 12).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T14 value: (node at 13).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T15 value: (node at 14).number_of_BPHs_by_day color: rgb('red') ;
//  		data T16 value: (node at 15).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T17 value: (node at 16).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T18 value: (node at 17).number_of_BPHs_by_day color: rgb('red') ;
//  		data T19 value: (node at 18).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T20 value: (node at 19).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T21 value: (node at 20).number_of_BPHs_by_day color: rgb('red') ;
//  		data T22 value: (node at 21).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T23 value: (node at 22).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T24 value: (node at 23).number_of_BPHs_by_day color: rgb('red') ;
//  		data T25 value: (node at 24).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T26 value: (node at 25).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T27 value: (node at 26).number_of_BPHs_by_day color: rgb('red') ;
//  		data T28 value: (node at 27).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T29 value: (node at 28).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T30 value: (node at 29).number_of_BPHs_by_day color: rgb('red') ;
//  		data T31 value: (node at 30).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T32 value: (node at 31).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T33 value: (node at 32).number_of_BPHs_by_day color: rgb('red') ;
//  		data T34 value: (node at 33).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T35 value: (node at 34).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T36 value: (node at 35).number_of_BPHs_by_day color: rgb('red') ;
//  		data T37 value: (node at 36).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T38 value: (node at 37).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T39 value: (node at 38).number_of_BPHs_by_day color: rgb('red') ;
//  		data T40 value: (node at 39).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T41 value: (node at 40).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T42 value: (node at 41).number_of_BPHs_by_day color: rgb('red') ;
//  		data T43 value: (node at 42).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T44 value: (node at 43).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T45 value: (node at 44).number_of_BPHs_by_day color: rgb('red') ;
//  		data T46 value: (node at 45).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		data T47 value: (node at 46).number_of_BPHs_by_day color: rgb('blue') ;
//  		data T48 value: (node at 47).number_of_BPHs_by_day color: rgb('red') ;
//  		//data T49 value: (node at 48).number_of_BPHs_by_day color: rgb([0,255,0]);
//  		//data T50 value: (node at 49).number_of_BPHs_by_day color: rgb('blue') ;
//  		//data T51 value: (node at 2).number_of_BPHs color: rgb('red') ;
//	}
//	}
	
	
//	display chart_display_model_trap_density {
//  		chart  "Trapped-Desnity" type: series {
//	  		data T1 value: (node at 0).number_of_BPHs color: rgb([0,255,0]);
//	  		data T2 value: (node at 1).number_of_BPHs color: rgb('blue') ;
//	  		data T3 value: (node at 2).number_of_BPHs color: rgb('red') ;
//	  		data T4 value: (node at 3).number_of_BPHs color: rgb([0,255,0]);
//	  		data T5 value: (node at 4).number_of_BPHs color: rgb('blue') ;
//	  		data T6 value: (node at 5).number_of_BPHs color: rgb('red') ;
//	  		data T7 value: (node at 6).number_of_BPHs color: rgb([0,255,0]);
//	  		data T8 value: (node at 7).number_of_BPHs color: rgb('blue') ;
//	  		data T9 value: (node at 8).number_of_BPHs color: rgb('red') ;
//	  		data T10 value: (node at 9).number_of_BPHs color: rgb([0,255,0]);
//	  		data T11 value: (node at 10).number_of_BPHs color: rgb('blue') ;
//	  		data T12 value: (node at 11).number_of_BPHs color: rgb('red') ;
//	  		data T13 value: (node at 12).number_of_BPHs color: rgb([0,255,0]);
//	  		data T14 value: (node at 13).number_of_BPHs color: rgb('blue') ;
//	  		data T15 value: (node at 14).number_of_BPHs color: rgb('red') ;
//	  		data T16 value: (node at 15).number_of_BPHs color: rgb([0,255,0]);
//	  		data T17 value: (node at 16).number_of_BPHs color: rgb('blue') ;
//	  		data T18 value: (node at 17).number_of_BPHs color: rgb('red') ;
//	  		data T19 value: (node at 18).number_of_BPHs color: rgb([0,255,0]);
//	  		data T20 value: (node at 19).number_of_BPHs color: rgb('blue') ;
//	  		data T21 value: (node at 20).number_of_BPHs color: rgb('red') ;
//	  		data T22 value: (node at 21).number_of_BPHs color: rgb([0,255,0]);
//	  		data T23 value: (node at 22).number_of_BPHs color: rgb('blue') ;
//	  		data T24 value: (node at 23).number_of_BPHs color: rgb('red') ;
//	  		data T25 value: (node at 24).number_of_BPHs color: rgb([0,255,0]);
//	  		data T26 value: (node at 25).number_of_BPHs color: rgb('blue') ;
//	  		data T27 value: (node at 26).number_of_BPHs color: rgb('red') ;
//	  		data T28 value: (node at 27).number_of_BPHs color: rgb([0,255,0]);
//	  		data T29 value: (node at 28).number_of_BPHs color: rgb('blue') ;
//	  		data T30 value: (node at 29).number_of_BPHs color: rgb('red') ;
//	  		data T31 value: (node at 30).number_of_BPHs color: rgb([0,255,0]);
//	  		data T32 value: (node at 31).number_of_BPHs color: rgb('blue') ;
//	  		data T33 value: (node at 32).number_of_BPHs color: rgb('red') ;
//	  		data T34 value: (node at 33).number_of_BPHs color: rgb([0,255,0]);
//	  		data T35 value: (node at 34).number_of_BPHs color: rgb('blue') ;
//	  		data T36 value: (node at 35).number_of_BPHs color: rgb('red') ;
//	  		data T37 value: (node at 36).number_of_BPHs color: rgb([0,255,0]);
//	  		data T38 value: (node at 37).number_of_BPHs color: rgb('blue') ;
//	  		data T39 value: (node at 38).number_of_BPHs color: rgb('red') ;
//	  		data T40 value: (node at 39).number_of_BPHs color: rgb([0,255,0]);
//	  		data T41 value: (node at 40).number_of_BPHs color: rgb('blue') ;
//	  		data T42 value: (node at 41).number_of_BPHs color: rgb('red') ;
//	  		data T43 value: (node at 42).number_of_BPHs color: rgb([0,255,0]);
//	  		data T44 value: (node at 43).number_of_BPHs color: rgb('blue') ;
//	  		data T45 value: (node at 44).number_of_BPHs color: rgb('red') ;
//	  		data T46 value: (node at 45).number_of_BPHs color: rgb([0,255,0]);
//	  		data T47 value: (node at 46).number_of_BPHs color: rgb('blue') ;
//	  		data T48 value: (node at 47).number_of_BPHs color: rgb('red') ;
//	  		//data T49 value: (node at 48).number_of_BPHs color: rgb([0,255,0]);
//	  		//data T50 value: (node at 49).number_of_BPHs color: rgb('blue') ;
//	  		//data T51 value: (node at 2).number_of_BPHs color: rgb('red') ;
//		}
//	}
	
	display MSE_Variogram {
  		chart  "MSE of variogram model" type: series {
	  		//data MSE_REAL value: MSE_VARIOGRAM color: rgb('blue') ;
	  		data "MSE_CURRENT_NETWORK" value: MSE_VARIOGRAM_LIST at 0 color:#red;
	  		data "MSE_OPTIMAL_NETWORK" value: MSE_VARIOGRAM_LIST at 1 color:#green;
	  		data "MSE_ADDED_NETWORK" value: MSE_VARIOGRAM_LIST at 2 color:#black;
	  	}
  	}
 	
	monitor NUMBER_OF_EDGES value: length(_edge as list) refresh: every(1);
	monitor NUMBER_OF_NODES value: length(node as list) refresh: every(1);
	monitor Simulation_Step value: SIMULATION_STEP refresh: every(1);


}

}