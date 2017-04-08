model GraphNetworkModel


import "../GlobalParam.gaml"
import "node_network.gaml"
import "edge_network.gaml"
import "../../models/GlobalModel3D.gaml"

global {
	//var SHAPE_NODE type: string init: '../includes/gis/surveillances/provinces/DongThap_Lighttraps.shp' parameter: 'Sensors Network - DONG THAP:' category: 'SURVEILLANCE' ;
	int lasted_edge_id <- 0;
	edge current_edge <- nil;
	
	list vectorXX <- nil;
	list vectorYY <- nil;
	float correlationAVG <- 0.0;
	int correlationCount <- 0;
	
	float x1 <- 0.0;  
	float y1 <- 0.0;						
	float x2 <- 0.0;  
	float y2 <- 0.0;
	float x1_to <- 0.0;
	float y1_to <- 0.0;
	
	// TEST
	int testtest <- 0;
	float testcor <- 0.0;
	
	init{
		//create species: node from: SHAPE_NODE with: [id :: read('ID'), name :: read('LightTrap'), district_name :: read('District'), province_name :: read('Province'), id_0 :: read('ID_0'), id_1 :: read('ID_1'), id_2 :: read('ID_2')];
	}
}
	
	species UnitDiskGraph skills: [moving] {
		graph UDgraph <- nil;
		int setup <- 0;
		
		float alpha <- 135.0;
				
		// Tempo variable used in check_simple_connection action:
		bool connected_temp <- false;
		
		bool working_status <- true;
		
		action allocateNewNodeByCorrelation {
			arg center_node type: node;
			let location_found type: bool value: false;
			let center_correlation type: float value: 0.0;
			let cell_correlation type: float value: 0.0;
			let potential_correlation type: float value: 0.0;
			let potential_inverse_distance type: float value: 0.0;
			let potential_condition type: float value: 0.0;			
			let the_potential_cell type: cellula_automata value: nil;
			list cell_list value: (list (cellula_correlation))  where (((cellula_correlation (each) distance_to center_node) <= DISK_RADIUS) and ((cellula_correlation (each) distance_to center_node) > LOWEST_RADIUS)) ;
			
			ask target: center_node {
				set center_correlation value: dominated_cell_correlation.correlation_coefficient;
			}
						
			loop cnt from: 0 to: length(cell_list) - 1 {
				let the_cell type: cellula_automata value: cell_list at cnt; // SAI
				
				ask target: cell_list at cnt {
					set cell_correlation value: correlation_coefficient;
				}
				
				let deviation_correlation value: abs(center_correlation - cell_correlation);
				let distance value: the_cell distance_to center_node;
				
				set potential_inverse_distance value: distance/DISK_RADIUS;
				set potential_correlation value: deviation_correlation;
				
				if ((deviation_correlation >= CORRELATION_THRESHOLD) and (((potential_inverse_distance + potential_correlation) / 2) > potential_condition)) {
					set potential_condition value: (potential_inverse_distance +  potential_correlation) / 2;	
					set the_potential_cell value: the_cell; // SAI
					set location_found value: true;
				}
				
				set testcor value: potential_condition;
			}
			
			if(location_found) {
				create species: node number: 1
				{
					set existing_status value: false;
					set location value: the_potential_cell.location;
					do setcolor;
				}
				
				// CREATE NEW EDGE:
						
				create species: _edge number: 1;
				set current_edge value: _edge at (length(_edge) - 1);
				set current_edge.source value: center_node;	
				let the_destination type: node value: node at (length(node) - 1); 
				set current_edge.destination value: the_destination;
				set current_edge.shape value: polygon([{((center_node) . location) . x, ((center_node) . location) . y }, { ((the_destination) . location) . x, ((the_destination) . location) . y}]);
			}
			
		}
		
		action allocateNewNodeByStdDeviation {
			arg center_node type: node;
			
			let location_found type: bool value: false;
			let maximum_priority type: float value: 0.0;
			let current_priority type: float value: 0.0;
			
			let current_std_deviation type: float value: 0.0;
			let current_attractive_index type: float value: 0.0;
			let current_hinder_index type: float value: 0.0;
			let current_being_monitored type: bool value: false;
			
			let selected_correlation type: float value: 0.0;
			let current_correlation type: float value: 0.0;
			let center_correlation type: float value: 0.0;
			let the_potential_cell type: cellula_automata <- nil;
			
			ask target: center_node
			{
				set center_correlation value: correlation_coefficient; //dominated_cell_correlation.correlation_coefficient;
			}
			
			// Three lists of cells
			list cell_list value: (list (cellula_automata))  where (((cellula_automata (each) distance_to center_node) <= DISK_RADIUS) and ((cellula_automata (each) distance_to center_node) > LOWEST_RADIUS)) ;
			list std_deviation_cell_list value: (list (cellula_std_deviation))  where (((cellula_std_deviation (each) distance_to center_node) <= DISK_RADIUS) and ((cellula_std_deviation (each) distance_to center_node) > LOWEST_RADIUS)) ;
			list correlation_cell_list value: (list (cellula_correlation))  where (((cellula_correlation (each) distance_to center_node) <= DISK_RADIUS) and ((cellula_correlation (each) distance_to center_node) > LOWEST_RADIUS)) ;
			let the_sigma_cell type: cellula_std_deviation value: nil;
			let the_rho_cell type: cellula_correlation value: nil;
			let the_cell type: cellula_automata value: nil;
			
			let the_node type: node value: nil;
			loop cnt from: 0 to: length(cell_list) - 1 
			{
				set the_cell value: cell_list at cnt;
				set the_sigma_cell value: std_deviation_cell_list at cnt;
				set the_rho_cell value: correlation_cell_list at cnt;
				
				ask target: the_sigma_cell
				{	
					set current_std_deviation value: estimation_std_deviation;
				}
				
				ask target: the_rho_cell
				{
					set current_correlation value: correlation_coefficient;
				}
				
				ask target: the_cell
				{
					set current_attractive_index value: attractive_index;
					set current_hinder_index value: hinder_index;
					set current_being_monitored value: is_monitored;
				}
				
				// Calculating the priority (SIGMA(distance) * deviation):
				let node_list type: list value: (list (node))  where (((node (each) distance_to the_cell) <= DISK_RADIUS)) ;
				let max_distance type: float value: 0.0;
				let mean_distance type: float value: 0.0;
				loop count from: 0 to: length(node_list) - 1
				{
					let distance type: float value: (the_cell distance_to (node_list at count));
					if (distance > max_distance)
					{
						set max_distance value: distance;
					}
				}
				
				loop count from: 0 to: length(node_list) - 1
				{
					let distance type: float value: (the_cell distance_to (node_list at count));
					set mean_distance value: mean_distance + (distance/max_distance);
				}
				set mean_distance value: mean_distance/length(node_list);
				
				// DECISION MAKERS: Considered by the attractive/hinder indices
				if(current_hinder_index >= 0.8 or current_being_monitored)
				{
					set current_priority value: -1.0;
				}
				else
				{
					//set current_priority value: (sum_distance/length(node_list)) * current_std_deviation;
					set current_priority value: mean_distance * current_std_deviation;
				}
				
				// Updating the maximum priority: 
				if (current_priority > maximum_priority)
				{
					set the_potential_cell value: the_cell;
					set maximum_priority value: current_priority;
					set selected_correlation value: current_correlation;
					set location_found value: true;
				}
			}
			
			if(location_found)
			{
				create species: node number: 1
				{
					set existing_status value: false;
					set model_status value: "ADDED_BY_OPTIMIZATION";
					
					set location value: the_potential_cell.location;
					//set dominated_cell value: nil;
					//set dominated_cell_correlation value: correlation_automata at 0; //the_rho_cell;
					
					write "Localtion: " + string(location.x) + "," + string(location.y);
					
					set correlation_coefficient value: current_correlation; 
					do setnewcolor;
					
					set dominated_cell value: the_potential_cell;
					ask target: the_potential_cell
					{
						set is_monitored value: true;
					}
					set dominated_cell_correlation value: the_rho_cell;
				}
				
				let new_node type: node value: (node at (length(node) - 1));
				// CREATE NEW EDGE(S) CONNECTED TO NEW NODE:
				let node_list type: list value: (list (node))  where (((node (each) distance_to new_node) <= DISK_RADIUS) /*and ((node (each) distance_to center_node) > LOWEST_RADIUS)*/) ;
				loop i from: 0 to: length(node_list) - 1
				{
					//string _center_id value: center_node.id;
					string _neighbor_id value: (node_list at i).id;
					string _neighbor_model_status value:  (node_list at i).model_status;
					if(_neighbor_model_status = "ESTABLISHED")
					{
						do action: correlation_estimation_for_trap
						{
								arg trap_id value: _neighbor_id;
						}
						ask target: (node at i)
						{
							set selected_correlation value: dominated_cell_correlation.trap_correlation_coefficient;
						}
					}
					
					
					// IF "ADDED_BY_OPTIMIZATION" ....
					
					if(selected_correlation >= CORRELATION_THRESHOLD)
					{
						create species: _edge number: 1;
						set current_edge value: _edge at (length(_edge) - 1);
						set current_edge.source value: center_node;
						ask center_node{
							set degree value: degree + 1;
						}
						
						let the_destination type: node value: node at (length(node) - 1);
						ask the_destination{
							set degree value: degree + 1;
						}
						
						 
						set current_edge.destination value: the_destination;
						set current_edge.shape value: polygon([{((center_node) . location) . x, ((center_node) . location) . y }, { ((the_destination) . location) . x, ((the_destination) . location) . y}]);
					}
					
				} 
					
				 
				/*
				if(abs(center_correlation - selected_correlation) <= CORRELATION_THRESHOLD)
				{
					create species: edge number: 1;
					set current_edge value: edge at (length(edge) - 1);
					set current_edge.source value: center_node;
					ask center_node{
						set degree value: degree + 1;
					}
					
					let the_destination type: node value: node at (length(node) - 1);
					ask the_destination{
						set degree value: degree + 1;
					}
					
					 
					set current_edge.destination value: the_destination;
					set current_edge.shape value: polygon([{((center_node) . location) . x, ((center_node) . location) . y }, { ((the_destination) . location) . x, ((the_destination) . location) . y}]);
				}
				*  
				*/
			}
		}
		
		// Add n nodes into the graph
		action add_new_nodes
		{
			arg node_number type: int;
			create species: node number: node_number
			{
				set existing_status value: false;
				set model_status value: "ADDED_BY_OPTIMIZATION";
			}
			
			//let cell_list type: list value: (list (cellula_automata)) where (each.hinder_index < 0.8);
			
			int cell_count value: length(cellula_automata);
			
			
			loop i from: 0 to: NUMBER_OF_ADDED_NODES - 1
			{
				int _location <- int (rnd(cell_count - 1));
				bool allocated <- false;
				
				loop while: !allocated {
					if(((cellula_automata at _location).hinder_index <= 0.6) and !(cellula_automata at _location).is_monitored)
					{
						set allocated value: true;
						ask target: node at (NUMBER_OF_CURRENT_NODES + i)
						{
							set dominated_cell value: cellula_automata at _location;
							set dominated_cell_correlation value: cellula_correlation at _location;
							set dominated_std_deviation value: cellula_std_deviation at _location;
							set location value: (cellula_automata at _location).location;
							set (cellula_automata at _location).is_monitored value: true;
						}
					}
					else {
						set _location value: int (rnd(cell_count - 1));
					}
				}
			}
		}
		
		
		
		// Correlation estimation for one trap:
		action correlation_estimation_for_trap
		{
			arg trap_id type: string;
			
			list density_list <- nil;
			list LIGHTTRAP_COORDINATES_X <- nil;
			list LIGHTTRAP_COORDINATES_Y <- nil;
			write autocorrelation_data;
			
			loop i from: 1 to: NUMBER_OF_CURRENT_NODES * NUMBER_OF_CURRENT_NODES
			{
				string _id1 <- autocorrelation_data at {0, i};
				
				if(trap_id = _id1)
				{
					write "ENTERED";
					loop j from: 0 to: no_of_nodes - 1
					{
						string _id2 <- (node at j).id;
						if(_id2 = (autocorrelation_data at {1, i}))
						{
							density_list <- density_list + float(autocorrelation_data at {2, i});	
							LIGHTTRAP_COORDINATES_X <- LIGHTTRAP_COORDINATES_X + (node at j).location.x;
							LIGHTTRAP_COORDINATES_Y <- LIGHTTRAP_COORDINATES_Y + (node at j).location.y;
						}
					}
				}
			}
			
			// CALLING R
			map result <- nil;
			list rs <- nil;
			density_list <- density_list + LIGHTTRAP_COORDINATES_X + LIGHTTRAP_COORDINATES_Y;
			write "CORRELATION MAP: ";
			write density_list;
			result <- R_compute_param("../includes/RCode/KrigingInterpolation.R", density_list);
			rs <- result['result'];
			loop i from: 1 to: GRID_ROW_NO 
			{
				loop j from: 1 to: GRID_COLUMN_NO
				{
				
					ask target: cellula_correlation at ((j - 1) * GRID_COLUMN_NO + (i - 1))
					{
						set trap_correlation_coefficient value: float(rs at (((GRID_COLUMN_NO - j) * GRID_ROW_NO + (i - 1))));
					}
				}
			}
		}
		
		
		action resetEdgesList {
			set setup value: 1;
			
			let count type: int value: length (node) - 1;
			let i type: int value: 0;
			loop i from: 0 to: length (node) - 2 {
				
				let the_outside_node value: node at i;  
				
				let j type: int value: 0;
				loop j from: i + 1 to: length (node) - 1 {
					
					node the_inside_node value: node at j;
					
					
					if condition: (the_outside_node distance_to the_inside_node) < DISK_RADIUS
					{
						set x1  value: (float(((the_outside_node) . location) . x));  
						set y1  value: (float(((the_outside_node) . location) . y));						
						set x2  value: (float(((the_inside_node)  . location) . x));  
						set y2  value: (float(((the_inside_node)  . location) . y));
						
						// Calculating the maximum location:
						set x1_to  value: (float (x1 + float(DISK_RADIUS * float(float (cos(alpha))))));
						set y1_to value: (float (y1 + float(DISK_RADIUS * float(float(sin(45))))));
						
						let vv12 type: float value:0.0; 
						set vv12 value: (((x1_to - x1) * (x2 - x1)) + ((y1_to - y1) * (y2 - y1))); 
						let length_v1 type: float value: 0.0;
						set length_v1 value: (sqrt(((x1_to - x1) * (x1_to - x1)) + ((y1_to - y1) * (y1_to - y1))));
						let length_v2 type: float value: 0.0;
						set length_v2 value: (sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2))) + 1.0;
								
							
						let beta type: float value: acos( ((vv12) / ( length_v1 * length_v2 )));
						
				
						if(beta < 90)
						{
							// Correlation weight:
							set vectorXX value: nil;
							set vectorYY value: nil;
							ask target: the_outside_node
							{
								loop i from: 0 to: (HISTORICAL_DURATION - 1)
								{
									set vectorXX value: vectorXX + [float(density_matrix at {0, i})];
									//put item: float(density_matrix at {0, i}) at: i in: vectorXX;
								}
							}
							
							ask target: the_inside_node
							{
								loop i from: 0 to: (HISTORICAL_DURATION - 1)
								{
									set vectorYY value: vectorYY + [float(density_matrix at {0, i})];
									//put item: float(density_matrix at {0, i}) at: i in: vectorYY;
								}
							}
							
							
							let correlationW type: float value: float(corR(vectorXX, vectorYY));
							set current_edge.correlationWeight value: correlationW;
								
							set correlationAVG value: correlationW + correlationAVG;
							if correlationW >= CORRELATION_THRESHOLD
							{
								
								create species: _edge number: 1;
								set current_edge value: _edge at lasted_edge_id;
								set current_edge.source value: the_outside_node;
								
								ask the_outside_node{
									set degree value: degree + 1;
								}
								
								set current_edge.destination value: the_inside_node;
								ask the_inside_node
								{
									set degree value: degree + 1;
								}
								
								set current_edge.shape value: polygon([{((the_outside_node) . location) . x, ((the_outside_node) . location) . y }, { ((the_inside_node) . location) . x, ((the_inside_node) . location) . y}]);
								set lasted_edge_id value: lasted_edge_id + 1;
								
								set correlationCount value: correlationCount + 1;
							}
						}
						else
						{
							// Correlation weight:
							set vectorXX <- nil;
							set vectorYY <- nil;
							ask target: the_inside_node {
								loop i from: 0 to: (HISTORICAL_DURATION - 1) {
									set vectorXX value: vectorXX + [float(density_matrix at {0, i})];
									//put item: float(density_matrix at {0, i}) at: i in: vectorXX;
								}
							}
							
							ask target: the_outside_node {
								loop i from: 0 to: (HISTORICAL_DURATION - 1)
								{
									set vectorYY value: vectorYY + [float(density_matrix at {0, i})];
									//put item: float(density_matrix at {0, i}) at: i in: vectorYY;
								}
								
							}
							let correlationW type: float value: float(corR(vectorXX, vectorYY));
							set current_edge.correlationWeight value: correlationW;
							
							
							set correlationAVG value: correlationW + correlationAVG;
							if correlationW >= CORRELATION_THRESHOLD
							{
								create species: _edge number: 1;
								set current_edge update: _edge at lasted_edge_id;
								set current_edge.source value: the_inside_node;
								set current_edge.destination value: the_outside_node;
								set current_edge.shape value: polygon([{((the_inside_node) . location) . x, ((the_inside_node) . location) . y }, { ((the_outside_node) . location) . x, ((the_outside_node) . location) . y}]);
								set lasted_edge_id value: lasted_edge_id + 1;
							
								
								set correlationCount value: correlationCount + 1;
							}	
						}	
					}	
				}
			}			
		}
	} 

