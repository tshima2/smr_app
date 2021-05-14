jQuery.gmapSearch = function ($, google, conf) {
	var infoWindow,
		infoWindow2,
		ns = google.maps,
		mapOptions = {
			zoom: 14,
			center: new ns.LatLng(35.6773166,139.8212672, 0),
			mapTypeControl: false,
			panControl: false,
			streetViewControl: true,
			zoomControl: true,
			scaleControl: true,
			overviewMapControl: true
		},
		map = new ns.Map($("#mapDiv")[0], mapOptions),
		points = new ns.MVCArray(conf.points),
		lines = new ns.MVCArray(conf.lines),
		polygons = new ns.MVCArray(conf.polygons),
		bounds = new ns.LatLngBounds();

	//draw points
	var center1=0, center2=0, center3=0, coord_count=0;	
	var myLatlng;
	points.forEach(function (point, index) {
		center1 += point[2];
		center2 += point[3];
		center3 += point[4];
		coord_count++;

		myLatlng = new ns.LatLng(point[3], point[2]),
			marker = new ns.Marker({
				position: myLatlng,
				title: String(point[0]),
				icon: `/map_icons/number_${index+1}.png`,
				map: map
			});

		bounds.extend(myLatlng);
		ns.event.addListener(marker, 'click', function () {
			if (!infoWindow) {
				infoWindow  = new ns.InfoWindow();
			}
			infoWindow.setContent(point[1]);
			infoWindow.open(map, marker);
		});
	});
	center1 /= coord_count;
	center2 /= coord_count;
	center3 /= coord_count;
	map.setCenter(new ns.LatLng(center2, center1));
	map.fitBounds(bounds);

	//draw lineStrings
	POLY_COLORS=['#006400', '#8b0000', '#00008b', '#8B008B', '#FF8C00', '#556b2f', '#483D8B', '#00ced1'];
	center1=center2=coord_count=0;
	lines.forEach(function (line, index) {
		var path = new ns.MVCArray();
		for(var  i=0; ((3*i)+2)<line.length; i++){
			var j=(3*i)+2;
			path.push ( myLatlng = new ns.LatLng( line[j+1], line[j] ));
			bounds.extend(myLatlng);
			center1 += line[j];
			center2 += line[j+1];
			coord_count++;
		}
		center2 /= coord_count; 
		center1 /= coord_count; 

		polylineOptions = { 
			path: path, 
			strokeColor: POLY_COLORS[index % 8],
			strokeOpacity: 0.7,
			strokeWeight: 8,
			map: map 
		}
		polyline = new ns.Polyline( polylineOptions );	

		ns.event.addListener(polyline, 'click', function (event) {
			if (!infoWindow2) {
				infoWindow2  = new ns.InfoWindow();
			}
			infoWindow2.setContent(line[1]);
			infoWindow2.setPosition(event.latLng);
			infoWindow2.open(map, polyline);
		});
	});
	map.setCenter(new ns.LatLng(center2, center1));
	map.fitBounds(bounds);

	//draw polygons
	var paths = new ns.MVCArray();
	center1=center2=coord_count=0;
	polygons.forEach(function (polygon, index) {
		var path = new ns.MVCArray();
		for(var  i=0; ((3*i)+2)<polygon.length; i++){
			var j=(3*i)+2;
			path.push ( myLatlng = new ns.LatLng( polygon[j+1], polygon[j] ) );
			bounds.extend(myLatlng);
			center1 += polygon[j];
			center2 += polygon[j+1];
			coord_count++;
		}
		paths.push(path);
	});
	center2 /= coord_count; 
	center1 /= coord_count; 
	polygonOptions = { 
		paths: paths, 
		map: map, 
		strokeColor: '#FF0000', 
		strokeOpacity: 0.7, 
		strokeWeight: 3, 
		fillColor: '#FF0000', 
		fillOpacity: 0.35 
	}
	polygon = new ns.Polygon( polygonOptions );
	map.setCenter(new ns.LatLng(center2, center1));
	map.fitBounds(bounds);
};