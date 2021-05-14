jQuery.gmapSearch = function ($, google, conf) {
	var infoWindow,
		ns = google.maps,
		mapOptions = {
			zoom: 14,
			//center: new ns.LatLng(lat, lng, alt),
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
	
	POLY_COLORS=['#006400', '#8b0000', '#00008b', '#8B008B', '#FF8C00', '#556b2f', '#483D8B', '#00ced1'];

	//draw points
	if(points.length>0){
		var center1=0, center2=0, center3=0, coord_count=0;	
		points.forEach(function (point, index) {
			center1 += point[2];
			center2 += point[3];
			center3 += point[4];
			coord_count++;

			var myLatlng;
			var obj_marker;
			myLatlng = new ns.LatLng(point[3], point[2]),
				obj_marker = new ns.Marker({
					position: myLatlng,
					title: String(point[0]),
					icon: `/map_icons/number_${index+1}.png`,
					map: map
				});

			bounds.extend(myLatlng);
			ns.event.addListener(obj_marker, 'click', function () {
				if (!infoWindow) {
					infoWindow  = new ns.InfoWindow();
				}
				infoWindow.setContent(point[1]);
				infoWindow.open(map, obj_marker);
			});
		});
		center1 /= coord_count;
		center2 /= coord_count;
		center3 /= coord_count;
		map.setCenter(new ns.LatLng(center2, center1));
		map.fitBounds(bounds);
	}

	//draw lineStrings
	if(lines.length>0){
		center1=center2=coord_count=0;
		lines.forEach(function (line, index) {
			var myLatlng;
			var obj_polyline;
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
			obj_polyline = new ns.Polyline( polylineOptions );	

			ns.event.addListener(obj_polyline, 'click', function (event) {
				if (!infoWindow) {
					infoWindow  = new ns.InfoWindow();
				}
				infoWindow.setContent(line[1]);
				infoWindow.setPosition(event.latLng);
				infoWindow.open(map, obj_polyline);
			});
		});
		map.setCenter(new ns.LatLng(center2, center1));
		map.fitBounds(bounds);
	}

	//draw polygons
	if(polygons.length>0){
		center1=center2=coord_count=0;
		polygons.forEach(function (polygon, index) {
			var myLatlng;
			var obj_polygon;
			var path = new ns.MVCArray();
			for(var  i=0; ((3*i)+2)<polygon.length; i++){
				var j=(3*i)+2;
				path.push ( myLatlng = new ns.LatLng( polygon[j+1], polygon[j] ) );
				bounds.extend(myLatlng);
				center1 += polygon[j];
				center2 += polygon[j+1];
				coord_count++;
			}
			polygonOptions = { 
				paths: path, 
				map: map, 
				strokeColor: POLY_COLORS[index % 8], 
				strokeOpacity: 0.7, 
				strokeWeight: 3, 
				fillColor: POLY_COLORS[index % 8], 
				fillOpacity: 0.35 
			}
			obj_polygon = new ns.Polygon( polygonOptions );
			ns.event.addListener(obj_polygon, 'click', function (event) {
				if (!infoWindow) {
					infoWindow  = new ns.InfoWindow();
				}
				infoWindow.setContent(polygon[0]);
				infoWindow.setPosition(event.latLng);
				infoWindow.open(map, obj_polygon);
			});
		});
		center2 /= coord_count; 
		center1 /= coord_count; 
		map.setCenter(new ns.LatLng(center2, center1));
		map.fitBounds(bounds);
	}
};