jQuery.initMap = function ($, google, conf) {
	var clicklat, clicklon;

	//initialize clickmenu
	$("#site_show_clickmenu").menu();
	$("#site_show_clickmenu").hover(function(e) {
	}, function(e) {
		$("#site_show_clickmenu").css('display', 'none');
	});

	//initialize kml-map
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
					animation: ns.Animation.DROP,
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

	//map click-events
	ns.event.addListener(map, 'click', function(event){
		$("#site_show_clickmenu").css('display', 'inline');
		$("#site_show_clickmenu").css('top', event.pixel.y-5+300);
		$("#site_show_clickmenu").css('left', event.pixel.x-5);
		clicklat = event.latLng.lat();
		clicklon = event.latLng.lng();
		
		console.log("lat: "+String(clicklat))
		console.log("lon: "+String(clicklon))
	});

	//click-menu(1) events
	$("#li_show_waitingpoints_u1").click(function(event){
		RetrieveWaitingPoints(1000, event);
	});

	//click-menu(5) events ajax comm
	$("#li_show_waitingpoints_u5").click(function(event){
		RetrieveWaitingPoints(5000, event);
	});

	//waiting-points retrieve request
	function RetrieveWaitingPoints(dist, event)	{
		//$("#comm_result").text("通信中...");
		$.ajax({
			url: 'http://192.168.0.22:3000/api/v1/retrieve_waiting_points',
			type: 'GET',
			dataType: 'json',
			data: 'dist='+String(dist)+'&lat='+String(clicklat)+'&lon='+String(clicklon),
			scriptCharset: 'utf-8',
			timeout: 5000,
			success: function(data){
				console.log(data);
				//$("#comm_result").text(data["status"]+": "+data["message"]);
				drawWaitingPoints(data["data"]);
			},
			error: function(data){
				//$("#comm_result").text(data["status"]+": "+data["message"]);
				alert(data["status"]+": "+data["message"]);
				console.log(data);
			}
		});

		/*
		var request = new XMLHttpRequest();
		var url = 'http://192.168.0.22:3000/api/v1/retrieve_waiting_points';
		url += '?dist=' + String(dist);
		url += '&lat=' + String(clicklat);
		url += '&lon=' + String(clicklon);
		request.open('GET', url);
		request.responseType = 'json';
	 
		request.onload = function () {
		  var data = this.response;
		  console.log(data);
		};

		request.send();
		*/
	}

	//draw waiting-points
	function drawWaitingPoints(datas){
		if(datas.length>0){
			var center_lat=0, center_lon=0, coord_count=0;	
			datas.forEach(function (data, index) {
				center_lat += data["lat"];
				center_lon += data["lon"];
				coord_count++;
	
				var myLatlng;
				var obj_marker;
				myLatlng = new ns.LatLng(data["lon"], data["lat"]),
					obj_marker = new ns.Marker({
						position: myLatlng,
						title: data["name"],
						animation: ns.Animation.DROP,
						map: map
					});
	
				bounds.extend(myLatlng);
				ns.event.addListener(obj_marker, 'click', function () {
					if (!infoWindow) {
						infoWindow  = new ns.InfoWindow();
					}
					infoWindow.setContent(data["name"]);
					infoWindow.open(map, obj_marker);
				});
			});
			center_lat /= coord_count;
			center_lon /= coord_count;
			map.setCenter(new ns.LatLng(center_lat, center_lon));
			map.fitBounds(bounds);
		}
	}
	
};