/*
 * 
 * 
 *  Node species
 *  Author: Truong Xuan Viet
 *  Last Modified Date: 01-11-2012 
 */

 
model NodeNetworkModel
import "../GlobalParam.gaml"
import "../../models/GlobalModel3D.gaml"
//import "../../includes/ecologies/rice_region.gaml"

global {
	//var SHAPE_NODE type: string init: '../includes/gis/surveillances/provinces/DongThap_Lighttraps.shp' parameter: 'Sensors Network - DONG THAP:' category: 'SURVEILLANCE' ;
}
	
		species node {
		string id;
		string name;
		string id_0;
		string id_1;
		string id_2;
		string province_name;
		string id_3;
		string district_name;
		matrix density_matrix size: {1, 365};
		matrix simulation_density_matrix size: {1, 365};
		
		float number_of_BPHs <- 0.0;
		//var number_of_BPHs_by_day_model type: float init: 0.0;
		float number_of_BPHs_by_day <- 0.0;
		
		float number_of_BPHs_total <- 0.0 ;
		
		// WORKING STATUS: TRUE/FALSE
		bool working_status  <- true;
		bool existing_status <- true;
		string model_status <- "ESTABLISHED";
				
		// Dominated cell:
		cellula_automata dominated_cell;
		cellula_correlation dominated_cell_correlation;
		cellula_std_deviation dominated_std_deviation;
		
		// OPTIMIZATION SUPPORTS
		float correlation_coefficient <- 0.0;
		float sample_variance <- 0.0;
		int degree <- 0;
		
		// For PSO:
		float velocity_x <- 0.0;
		float velocity_y <- 0.0;
			
		// For Tabu search:
		list Tabu_List <- nil;
		int TABU_LIST_MAXLENGHT <- 24;
		int Tabu_List_lenght <- 0;
	
		rgb nodecolor <- rgb([0, 0, 255]); //(existing_status)?rgb([0,255,0]):rgb([255, 255,0]);
		
		float z <- 0.0;
				
		init{
			set location value: self.location;
			set nodecolor value: rgb([0,255,0]);
		}
		
		reflex run_simulation
		{
			if((SIMULATION_STEP > 1) and (SIMULATION_STEP <= 32) and (model_status = "ADDED_BY_OPTIMIZATION"))
			{
				write "Tabu";
				//do action: run_particle_swarm_optimization;
				//do action: run_greedy_on_gaussian_entropy;
				//do action: run_greedy_on_combinational_index;
				do action: run_Tabu_search_on_combinational_index;
			}
			
			do updateToSimulationVector; 
		}
		
		/*
		var color type: rgb value: (number_of_BPHs > 1000000)?rgb([0,0,0]):        
		
					((number_of_BPHs > 750000)?rgb([20,0,0]):        
					((number_of_BPHs > 500000)?rgb([38,0,0]):        
					((number_of_BPHs > 250000)?rgb([58,0,0]):        
					((number_of_BPHs > 100000)?rgb([76,0,0]):        
					((number_of_BPHs > 75000)?rgb([96,0,0]):        
					((number_of_BPHs > 50000)?rgb([102,0,0]):        
					((number_of_BPHs > 25000)?rgb([130,0,0]):        
					((number_of_BPHs > 10000)?rgb([160,0,0]):        
					((number_of_BPHs > 7500)?rgb([208,0,0]):        
					((number_of_BPHs > 5000)?rgb([178,0,0]):        
					((number_of_BPHs > 2500)?rgb([255,7,7]):        
					((number_of_BPHs > 1000)?rgb([255,37,37]):        
					((number_of_BPHs > 750)?rgb([255,65,65]):        
					((number_of_BPHs > 500)?rgb([255,93,93]):        
					((number_of_BPHs > 250)?rgb([255,123,123]):        
					((number_of_BPHs > 100)?rgb([255,151,151]):        
					((number_of_BPHs > 75)?rgb([255,181,181]):        
					((number_of_BPHs > 50)?rgb([255,209,209]):        
					((number_of_BPHs > 25)?rgb([255,237,237]):
					rgb([255,255,255])))))))))))))))))))) ;
					* 
					*/
		aspect default {
			//draw shape: circle color: rgb([255, 0, 255]) size: 1500 ;
			draw circle(500) color: nodecolor;
		}
		
		aspect ThreeDirections {
			//draw shape: circle color: rgb([255, 0, 255]) size: 1500 ;
			draw circle(500) color: nodecolor;
			set z value: float(50);
		}
		
		action setnewcolor {
			set nodecolor value: rgb([255,0,0]);
		}
		
		action setcolor {
			//set nodecolor value: (existing_status)?rgb([0,255,0]):rgb([255, 0, 0]);
			set nodecolor value: (number_of_BPHs > 1000000)?rgb([0,0,0]):        
					((number_of_BPHs > 750000)?rgb([20,0,0]):        
					((number_of_BPHs > 500000)?rgb([38,0,0]):        
					((number_of_BPHs > 250000)?rgb([58,0,0]):        
					((number_of_BPHs > 100000)?rgb([76,0,0]):        
					((number_of_BPHs > 75000)?rgb([96,0,0]):        
					((number_of_BPHs > 50000)?rgb([102,0,0]):        
					((number_of_BPHs > 25000)?rgb([130,0,0]):        
					((number_of_BPHs > 10000)?rgb([160,0,0]):        
					((number_of_BPHs > 7500)?rgb([208,0,0]):        
					((number_of_BPHs > 5000)?rgb([178,0,0]):        
					((number_of_BPHs > 2500)?rgb([255,7,7]):        
					((number_of_BPHs > 1000)?rgb([255,37,37]):        
					((number_of_BPHs > 750)?rgb([255,65,65]):        
					((number_of_BPHs > 500)?rgb([255,93,93]):        
					((number_of_BPHs > 250)?rgb([255,123,123]):        
					((number_of_BPHs > 100)?rgb([255,151,151]):        
					((number_of_BPHs > 75)?rgb([255,181,181]):        
					((number_of_BPHs > 50)?rgb([255,209,209]):        
					((number_of_BPHs > 25)?rgb([255,237,237]):
					rgb([255,255,255])))))))))))))))))))) ;
		}
		
		action run_greedy_on_gaussian_entropy
		{
			let _the_std_deviation type: cellula_std_deviation value: dominated_std_deviation;
			let _current_std_deviation type: float value: _the_std_deviation.estimation_std_deviation;
			let std_deviation_list type: list value: (dominated_std_deviation neighbours_at 1) of_species cellula_std_deviation;
			let node_list type: list value:  (list (node))  where ((node (each) distance_to self) <= DISK_RADIUS);
			
			
			// Calculating the minimal distance to the current node
			let _current_min_distance type: float value: DISK_RADIUS + 0.001;
			loop i from: 0 to: length(node_list) - 1
			{
				if((node_list at i) != self)
				{
					let _distance type: float value: (node_list at i) distance_to self;
					if(_distance  < _current_min_distance)
					{
						set _current_min_distance <- _distance;
					}
				}
			}			
			
//			let _maximum_std_deviationL type: float value: 0.0;
//			let _maximum_cell_std_deviationL type: cellula_std_deviation value: nil;
			float _maximum_std_deviationL <- 0.0;
			cellula_std_deviation _maximum_cell_std_deviationL <- nil;
			
//			let _maximum_std_deviationG type: float value: 0.0;
//			let _maximum_cell_std_deviationG type: cellula_std_deviation value: nil;
			float _maximum_std_deviationG <- 0.0;
			cellula_std_deviation _maximum_cell_std_deviationG <- nil;
			
			// Local best
			loop i from: 0 to: length(std_deviation_list) - 1
			{
				let _neighbour_std_deviation type: float value: 0.0;
				ask target: std_deviation_list at i
				{
					set _neighbour_std_deviation value: estimation_std_deviation;
				}
				
				if(_neighbour_std_deviation > _maximum_std_deviationL)
				{
					set _maximum_std_deviationL value: _neighbour_std_deviation;
					set _maximum_cell_std_deviationL value: std_deviation_list at i;
				}
			}
			
			// Global best
			loop i from: 0 to: length(node_list) - 1
			{
				let _neighbour_std_deviation type: float value: 0.0;
				ask target: node_list at i
				{
					ask dominated_std_deviation
					{
						set _neighbour_std_deviation value: estimation_std_deviation;	
					}
					
				}

				if(_neighbour_std_deviation > _maximum_std_deviationG)
				{
					set _maximum_std_deviationG value: _neighbour_std_deviation;
					set _maximum_cell_std_deviationG value: (node_list at i).dominated_std_deviation;
				}
			}
			// Next location:
			let _vx type: float value: 0;
			let _vy type: float value: 0;
			let _c1 type: float value: 2;
			let _c2 type: float value: 2;
			let _w type: float value: 1;
			//set _vx value: velocity_x * _w + _c1 * rnd(1) *  (_maximum_cell_std_deviationL.location.x - location.x)
			//							+ _c2 * rnd(1) *  (_maximum_cell_std_deviationG.location.x - location.x);
			//set _vy value: velocity_y * _w + _c1 * rnd(1) *  (_maximum_cell_std_deviationL.location.y - location.y)
			//							+ _c2 * rnd(1) *  (_maximum_cell_std_deviationG.location.y - location.y);
						
			set _vx value: velocity_x * _w + _maximum_cell_std_deviationL.location.x - location.x;
			set _vy value: velocity_y * _w + _maximum_cell_std_deviationL.location.y - location.y;
			let _x type: float value: location.x +_vx;
			if(location.x +_vx > BOUNDARY_MAX_X)
			{
				set _x <- BOUNDARY_MAX_X;
				write "MAX_X" + BOUNDARY_MAX_X;
				//set _vx <- 0.0;
			}
			else if(location.x +_vx < BOUNDARY_MIN_X)
			{
				write "MIN_X" + BOUNDARY_MIN_X;
				set _x <- BOUNDARY_MIN_X;
				//set _vx <- 0.0;
			}

			let _y type: float value: location.y +_vy;
			if(location.y +_vy > BOUNDARY_MAX_Y)
			{
				set _y <- BOUNDARY_MAX_Y;
				write "MAX_Y" + BOUNDARY_MAX_Y;
				//set _vy <- 0.0;
			}
			else if(location.y +_vy < BOUNDARY_MIN_Y)
			{
				set _y <- BOUNDARY_MAX_Y;
				write "MIN_Y" +  BOUNDARY_MAX_Y;
				//set _vy <- 0.0;
			}
			
			
			// Decision of movement:
			let _current_location_x type: float value: location.x;
			let _current_location_y type: float value: location.y;
			let _current_std_deviation type: float value: 0.0;
			ask dominated_std_deviation
			{
				set _current_std_deviation value: estimation_std_deviation;	
			}
			
			set location value: {_x, _y, 0.0};
			//set velocity_x value: _vx;
			//set velocity_y value: _vy;
			
			set node_list value:  (list (node))  where ((node (each) distance_to self) <= DISK_RADIUS);
						
			// Calculating the minimal distance to the current node
			let _moved_min_distance type: float value: DISK_RADIUS + 0.001;
			loop i from: 0 to: length(node_list) - 1
			{
				if((node_list at i) != self)
				{
					let _distance type: float value: (node_list at i) distance_to self;
					if(_distance  < _moved_min_distance)
					{
						set _moved_min_distance <- _distance;
					}
				}
				
			}
			
			// Decision of movement:	
			let std_deviation_list type: list value: (list (cellula_std_deviation)) where (each overlaps(self));
			let cell_list type: list value: (list (cellula_automata)) where (each overlaps(self));
			//if((((std_deviation_list at 0).estimation_std_deviation * (_moved_min_distance)) < (_current_std_deviation * (_current_min_distance))) or ((cell_list at 0).hinder_index > 0.6) or ((cell_list at 0).is_monitored))
			if((((std_deviation_list at 0).estimation_std_deviation /*  * (_moved_min_distance)*/) < (_current_std_deviation /*  * (_current_min_distance) */)) or ((cell_list at 0).hinder_index > 0.6) or ((cell_list at 0).is_monitored))
			{
				set location value: {_current_location_x, _current_location_y, 0.0};
			}
			
			else
			{
				// Re-updating the last location to NOT MONITORED
				set dominated_cell.is_monitored value: false;
				set dominated_std_deviation value: std_deviation_list at 0;
				set dominated_cell value: cell_list at 0;
				// Re-updating the new location to MONITORED
				set dominated_cell.is_monitored value: true;
			}
			
			
			//write "INDEX OF: " + cellula_std_deviation index_of(dominated_std_deviation);
			//set location value: _maximum_cell_std_deviationL.location;
			
			//set dominated_std_deviation value: _maximum_cell_std_deviationL;
			
			do setcolor;
		}
		
		// Greedy with the combinational index:
		
		action run_greedy_on_combinational_index
		{
			let _the_std_deviation type: cellula_std_deviation value: dominated_std_deviation;
			let _current_std_deviation type: float value: _the_std_deviation.hydrid_std_deviation;
			let std_deviation_list type: list value:  (dominated_std_deviation neighbours_at 1) of_species cellula_std_deviation;
					
			
			let _maximum_std_deviationL type: float value: 0.0;
			let _maximum_cell_std_deviationL type: cellula_std_deviation value: nil;
			
			// Local best
			loop i from: 0 to: length(std_deviation_list) - 1
			{
				let _neighbour_std_deviation type: float value: 0.0;
				ask target: std_deviation_list at i
				{
					set _neighbour_std_deviation value: hydrid_std_deviation;
				}
				
				if(_neighbour_std_deviation > _maximum_std_deviationL)
				{
					set _maximum_std_deviationL value: _neighbour_std_deviation;
					set _maximum_cell_std_deviationL value: std_deviation_list at i;
				}
			}
			
			// Next location:
			let _vx type: float value: 0;
			let _vy type: float value: 0;
			let _c1 type: float value: 2;
			let _c2 type: float value: 2;
			let _w type: float value: 1;
						
			set _vx value: velocity_x * _w + _maximum_cell_std_deviationL.location.x - location.x;
			set _vy value: velocity_y * _w + _maximum_cell_std_deviationL.location.y - location.y;
			let _x type: float value: location.x +_vx;
			if(location.x +_vx > BOUNDARY_MAX_X)
			{
				set _x <- BOUNDARY_MAX_X;
				write "MAX_X" + BOUNDARY_MAX_X;
				//set _vx <- 0.0;
			}
			else if(location.x +_vx < BOUNDARY_MIN_X)
			{
				write "MIN_X" + BOUNDARY_MIN_X;
				set _x <- BOUNDARY_MIN_X;
				//set _vx <- 0.0;
			}

			let _y type: float value: location.y +_vy;
			if(location.y +_vy > BOUNDARY_MAX_Y)
			{
				set _y <- BOUNDARY_MAX_Y;
				write "MAX_Y" + BOUNDARY_MAX_Y;
				//set _vy <- 0.0;
			}
			else if(location.y +_vy < BOUNDARY_MIN_Y)
			{
				set _y <- BOUNDARY_MAX_Y;
				write "MIN_Y" +  BOUNDARY_MAX_Y;
				//set _vy <- 0.0;
			}
			
			
			// Decision of movement:
			let _current_location_x type: float value: location.x;
			let _current_location_y type: float value: location.y;
			let _current_std_deviation type: float value: 0.0;
			ask dominated_std_deviation
			{
				set _current_std_deviation value: hydrid_std_deviation;	
			}
			
			set location value: {_x, _y, 0.0};
			
			// Calculating the minimal distance to the current node
			let _moved_min_distance type: float value: DISK_RADIUS + 0.001;
			
			// Decision of movement:	
			let std_deviation_list type: list value: (list (cellula_std_deviation)) where (each overlaps(self));
			let cell_list type: list value: (list (cellula_automata)) where (each overlaps(self));
			//if((((std_deviation_list at 0).estimation_std_deviation * (_moved_min_distance)) < (_current_std_deviation * (_current_min_distance))) or ((cell_list at 0).hinder_index > 0.6) or ((cell_list at 0).is_monitored))
			if((((std_deviation_list at 0).hydrid_std_deviation /*  * (_moved_min_distance)*/) < (_current_std_deviation /*  * (_current_min_distance) */)) or ((cell_list at 0).hinder_index > 0.6) or ((cell_list at 0).is_monitored))
			{
				set location value: {_current_location_x, _current_location_y, 0.0};
			}
			
			else
			{
				// Re-updating the last location to NOT MONITORED
				set dominated_cell.is_monitored value: false;
				set dominated_std_deviation value: std_deviation_list at 0;
				set dominated_cell value: cell_list at 0;
				// Re-updating the new location to MONITORED
				set dominated_cell.is_monitored value: true;
			}
			
		
			do setcolor;
		}
		
		// Tabu Search
		action run_Tabu_search_on_combinational_index
		{
			let _the_std_deviation type: cellula_std_deviation value: dominated_std_deviation;
			let _current_std_deviation type: float value: _the_std_deviation.hydrid_std_deviation;
			let cell_list type: list value:  (self.dominated_cell neighbours_at 1) of_species cellula_automata where (each.is_monitored = true);
			if(length(cell_list) > 1)
			{
				write "Entering";
				
				let cell_count type: int value: length(cellula_automata);
			
				int _location value: int (rnd(cell_count - 1));
				bool allocated value: false;
				loop while: !allocated
				{
					if(((cellula_automata at _location).hinder_index <= 0.6) and !(cellula_automata at _location).is_monitored)
					{
						set allocated value: true;
						set dominated_cell.is_monitored value: false;
						
						set dominated_cell value: cellula_automata at _location;
						set dominated_cell_correlation value: cellula_correlation at _location;
						set dominated_std_deviation value: cellula_std_deviation at _location;
						set location value: (cellula_automata at _location).location;
						
						set (cellula_automata at _location).is_monitored value: true;
					}
					else
					{
						set _location value: int (rnd(cell_count - 1));
					}
				}
				loop i from: 0 to: length(Tabu_List) - 1
				{
					ask cellula_std_deviation(Tabu_List at i)
					{
						set isTabu value: false;
					}
				}
				set Tabu_List value: nil;
				set Tabu_List_lenght value: 0;
			}
			else
			{
				let std_deviation_list type: list value:  (dominated_std_deviation neighbours_at 1) of_species cellula_std_deviation where (dominated_std_deviation.isTabu = false);
				write "STEP: " + SIMULATION_STEP + " LENGTH: " + length(std_deviation_list); 
						
				if(length(std_deviation_list) != 0)
				{
					let _maximum_std_deviationL type: float value: 0.0;
					let _maximum_cell_std_deviationL type: cellula_std_deviation value: nil;
					
					// Local best
					loop i from: 0 to: length(std_deviation_list) - 1
					{
						let _neighbour_std_deviation type: float value: 0.0;
						ask target: std_deviation_list at i
						{
							set _neighbour_std_deviation value: hydrid_std_deviation;
						}
						
						if(_neighbour_std_deviation > _maximum_std_deviationL)
						{
							set _maximum_std_deviationL value: _neighbour_std_deviation;
							set _maximum_cell_std_deviationL value: std_deviation_list at i;
						}
					}
					// Next location:
					let _vx type: float value: 0;
					let _vy type: float value: 0;
					let _c1 type: float value: 2;
					let _c2 type: float value: 2;
					let _w type: float value: 1;
								
					set _vx value: _maximum_cell_std_deviationL.location.x - location.x;
					set _vy value: _maximum_cell_std_deviationL.location.y - location.y;
					let _x type: float value: location.x +_vx;
					let _y type: float value: location.y +_vy;
								
					// Decision of movement:
					let _current_location_x type: float value: location.x;
					let _current_location_y type: float value: location.y;
					
					ask dominated_std_deviation
					{
						set isTabu value: true;
					}
					
					set location value: {_x, _y, 0.0};
					
					// 
					//let std_deviation_list type: list value: (list (cellula_std_deviation)) where (each overlaps(self));
					let cell_list type: list value: (list (cellula_automata)) where (each overlaps(self));
					if((cell_list at 0).is_monitored)
					{
						set location value: {_current_location_x, _current_location_y, 0.0};
					}
					else
					{
						// Re-updating the last location to NOT MONITORED
						set dominated_cell.is_monitored value: false;
						set dominated_std_deviation value: _maximum_cell_std_deviationL; //std_deviation_list at 0;// SAI
						
						set dominated_cell value: cell_list at 0;
						// Re-updating the new location to MONITORED
						set dominated_cell.is_monitored value: true;
						
						// Update Tabu list:
						if(Tabu_List_lenght < TABU_LIST_MAXLENGHT)
						{
							set Tabu_List value: Tabu_List + dominated_std_deviation;
							set Tabu_List_lenght value: Tabu_List_lenght + 1;
						}
						else
						{
							let removeDevCell value: cellula_std_deviation(Tabu_List[0]);
							set removeDevCell.isTabu value: false;
							set Tabu_List value: Tabu_List - Tabu_List[0];
							
							set Tabu_List value: Tabu_List + dominated_std_deviation;
						}
					}
					
					do setcolor;
				}
			}
			
		}
		
		
		
		// Appying the PSO
		action run_particle_swarm_optimization
		{
			let _the_std_deviation type: cellula_std_deviation value: dominated_std_deviation;
			let _current_std_deviation type: float value: _the_std_deviation.estimation_std_deviation;
			let std_deviation_list type: list value:  (dominated_std_deviation neighbours_at 1) of_species cellula_std_deviation;
			let node_list type: list value:  (list (node))  where ((node (each) distance_to self) <= DISK_RADIUS);
			
			
			// Calculating the minimal distance to the current node
			let _current_min_distance type: float value: DISK_RADIUS + 0.001;
			loop i from: 0 to: length(node_list) - 1
			{
				if((node_list at i) != self)
				{
					let _distance type: float value: (node_list at i) distance_to self;
					if(_distance  < _current_min_distance)
					{
						set _current_min_distance <- _distance;
					}
				}
			}
			
			
			
			let _maximum_std_deviationL type: float value: 0.0;
			let _maximum_cell_std_deviationL type: cellula_std_deviation value: nil;
			
			let _maximum_std_deviationG type: float value: 0.0;
			let _maximum_cell_std_deviationG type: cellula_std_deviation value: nil;
			
			// Local best
			loop i from: 0 to: length(std_deviation_list) - 1
			{
				let _neighbour_std_deviation type: float value: 0.0;
				ask target: std_deviation_list at i
				{
					set _neighbour_std_deviation value: estimation_std_deviation;
				}
				
				if(_neighbour_std_deviation > _maximum_std_deviationL)
				{
					set _maximum_std_deviationL value: _neighbour_std_deviation;
					set _maximum_cell_std_deviationL value: std_deviation_list at i;
				}
			}
			
			// Global best
			loop i from: 0 to: length(node_list) - 1
			{
				let _neighbour_std_deviation type: float value: 0.0;
				ask target: node_list at i
				{
					ask dominated_std_deviation
					{
						set _neighbour_std_deviation value: estimation_std_deviation;	
					}
					
				}

				if(_neighbour_std_deviation > _maximum_std_deviationG)
				{
					set _maximum_std_deviationG value: _neighbour_std_deviation;
					set _maximum_cell_std_deviationG value:  (node_list at i).dominated_std_deviation;
				}
			}
			// Next location:
			let _vx type: float value: 0;
			let _vy type: float value: 0;
			let _c1 type: float value: 2;
			let _c2 type: float value: 2;
			let _w type: float value: 1;
			set _vx value: velocity_x * _w + _c1 * rnd(1) *  (_maximum_cell_std_deviationL.location.x - location.x)
										+ _c2 * rnd(1) *  (_maximum_cell_std_deviationG.location.x - location.x);
			set _vy value: velocity_y * _w + _c1 * rnd(1) *  (_maximum_cell_std_deviationL.location.y - location.y)
										+ _c2 * rnd(1) *  (_maximum_cell_std_deviationG.location.y - location.y);
			
			
			let _x type: float value: location.x +_vx;
			if(location.x +_vx > BOUNDARY_MAX_X)
			{
				set _x <- BOUNDARY_MAX_X;
				write "MAX_X" + BOUNDARY_MAX_X;
				//set _vx <- 0.0;
			}
			else if(location.x +_vx < BOUNDARY_MIN_X)
			{
				write "MIN_X" + BOUNDARY_MIN_X;
				set _x <- BOUNDARY_MIN_X;
				//set _vx <- 0.0;
			}

			let _y type: float value: location.y +_vy;
			if(location.y +_vy > BOUNDARY_MAX_Y)
			{
				set _y <- BOUNDARY_MAX_Y;
				write "MAX_Y" + BOUNDARY_MAX_Y;
				//set _vy <- 0.0;
			}
			else if(location.y +_vy < BOUNDARY_MIN_Y)
			{
				set _y <- BOUNDARY_MAX_Y;
				write "MIN_Y" +  BOUNDARY_MAX_Y;
				//set _vy <- 0.0;
			}
			
			
			// Decision of movement:
			let _current_location_x type: float value: location.x;
			let _current_location_y type: float value: location.y;
			let _current_std_deviation type: float value: 0.0;
			ask dominated_std_deviation
			{
				set _current_std_deviation value: estimation_std_deviation;	
			}
			
			set location value: {_x, _y, 0.0};
			//set velocity_x value: _vx;
			//set velocity_y value: _vy;
			
			set node_list value:  (list (node))  where ((node (each) distance_to self) <= DISK_RADIUS);
						
			// Calculating the minimal distance to the current node
			let _moved_min_distance type: float value: DISK_RADIUS + 0.001;
			loop i from: 0 to: length(node_list) - 1
			{
				if((node_list at i) != self)
				{
					let _distance type: float value: (node_list at i) distance_to self;
					if(_distance  < _moved_min_distance)
					{
						set _moved_min_distance <- _distance;
					}
				}
				
			}
			
			// Decision of movement:	
			let std_deviation_list type: list value: (list (cellula_std_deviation)) where (each overlaps(self));
			let cell_list type: list value: (list (cellula_automata)) where (each overlaps(self));
			if((((std_deviation_list at 0).estimation_std_deviation * (_moved_min_distance)) < (_current_std_deviation * (_current_min_distance))) or ((cell_list at 0).hinder_index > 0.6) or ((cell_list at 0).is_monitored))
			{
				set location value: {_current_location_x, _current_location_y, 0.0};
			}
			else 
			{
				// Re-updating the last location to NOT MONITORED
				set dominated_cell.is_monitored value: false;
				set dominated_std_deviation value: std_deviation_list at 0;
				set dominated_cell value: cell_list at 0;
				// Re-updating the new location to MONITORED
				set dominated_cell.is_monitored value: true;
			}
			
			
			//write "INDEX OF: " + cellula_std_deviation index_of(dominated_std_deviation);
			//set location value: _maximum_cell_std_deviationL.location;
			
			//set dominated_std_deviation value: _maximum_cell_std_deviationL;
			
			do setcolor;
		}
		
		// Not verified:
		action getCorrelationCoefficient
		{
			list list_neighbors value: (list (cellula_correlation)) where (each overlaps(self));
			loop i from: 0 to: length(list_neighbors) - 1
			{
				let the_cell type: cellula_correlation value: list_neighbors at i;
				if self intersects the_cell
				{
					set correlation_coefficient value: the_cell.correlation_coefficient;
				}
			}
		}
		
		action updateToSimulationVector
		{
			put item: number_of_BPHs at: {0, SIMULATION_STEP} in: simulation_density_matrix;
		}
	}


