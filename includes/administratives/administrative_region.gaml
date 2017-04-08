model AdministrativeRegion

global {
	string SHAPE_ADMINISTRATIVE_PROVINCE        <- '../includes/gis/administratives/VNM_Province.shp' parameter: 'FILE OF PROVINCE AREAS:' category: 'ADMINISTRATIVE REGIONS';
	string SHAPE_ADMINISTRATIVE_DISTRICT        <- '../includes/gis/administratives/VNM_district.shp' parameter: 'FILE OF DISTRICT AREAS:' category: 'ADMINISTRATIVE REGIONS';
	string SHAPE_ADMINISTRATIVE_SMALLTOWN       <- '../includes/gis/administratives/VNM_smalltown.shp' parameter: 'FILE OF SMALLTOWN AREAS:' category: 'ADMINISTRATIVE REGIONS';
	string SHAPE_ADMINISTRATIVE_THREE_PROVINCES <- '../includes/gis/administratives/VNM_Province_3_Provinces.shp' parameter: 'FILE OF PROVINCE AREAS (BL, ST, HG):' category: 'ADMINISTRATIVE REGIONS';
	string SHAPE_SEA_REGION                     <- '../includes/gis/naturals/SeaRegion.shp' parameter: 'SEA REGION:' category: 'SEA REGIONS' ;
	
}

	species province_region {
		string id_1;
		string region_name;
		string id_2;
		string province_name;
		
		// RICE AGE:
		float rice_age <- 0.0;
		
		rgb color <- #white;
		//aspect
		//{
			//draw text: province_name color: rgb('white') size: 100 at: {0, 0};
			//draw text: state color: rgb('white') size: 1 at:my location + {1,1};
		//}
	}
	
	species db skills:[SQLSKILL]{
		
	}
	species district_region skills: [moving] {
		string id_1;
		string region_name;
		string id_2;
		string province_name;
		string id_3;
		string district_name;
		float  transplantation_index <- 0.0;
		float  number_of_BPHs        <- 0.0;
		
		rgb color <- #white;
		float lighttrap_density_min   <- 0.0;
		float lighttrap_density_mean  <- 0.0;
		float lighttrap_density_max   <- 0.0;
		float propagated_density_min  <- 0.0;
		float propagated_density_mean <- 0.0;
		float propagated_density_max  <- 0.0;
		float estimated_density_min   <- 0.0;
		float estimated_density_mean  <- 0.0;
		float estimated_density_max   <- 0.0;
	}

	species smalltown_region skills: [moving] {
		string id_1;
		string region_name;
		string id_2;
		string province_name;
		string id_3;
		string district_name;
		string id_4;
		string smalltown_name;
		rgb color <- #white;
		
		init {
			color <- (id_2 = '38253') ? #blue : #white;
		}
	}
	species administrative_region skills: [moving] {
		string id_1;
		string region_name;
		string id_2;
		string province_name;
		string id_3;
		string district_name;
		string id_4;
		string smalltown_name;
		rgb color <- #white;
		init {
			color <- (id_2 = '38253') ? #blue : #white;
		}
	}
	
	species sea_region{
		string description;
		rgb color <- #blue;
	}
