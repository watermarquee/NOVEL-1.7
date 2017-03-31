model RiceRegionLandUse

global {
	string WS_SHAPE_LAND_USE <- '../includes/gis/ecologies/LandUse_WS_Region.shp' parameter: 'Land Use File:' category: 'RICE_REGION';
	string SA_SHAPE_LAND_USE <- '../includes/gis/ecologies/LandUse_SA_Region.shp' parameter: 'Land Use File:' category: 'RICE_REGION';
	
}

	species WS_rice_region{
		string id;
		string description;
		rgb color <- rgb([64, 255, 64]);
	}
	
	species SA_rice_region{
		string id;
		string description;
		rgb color <- rgb([180, 0, 0]);
	}	


