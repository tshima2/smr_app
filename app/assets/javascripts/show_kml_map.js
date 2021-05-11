jQuery.gmapSearch = function ($, google, conf) {
	var infoWindow,
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
		bounds = new ns.LatLngBounds();

	var center1=0, center2=0, center3=0;	
	points.forEach(function (point) {
		center1 += point[1];
		center2 += point[2];
		center3 += point[3];

		var myLatlng = new ns.LatLng(point[2], point[1]),
			marker = new ns.Marker({
				position: myLatlng,
				map: map
			});

		bounds.extend(myLatlng);
		ns.event.addListener(marker, 'click', function () {
			if (!infoWindow) {
				infoWindow  = new ns.InfoWindow();
			}
			infoWindow.setContent(point[0]);
			infoWindow.open(map, marker);
		});
	});
	center1 /= points.length
	center2 /= points.length
	center3 /= points.length

	map.setCenter(new ns.LatLng(center2, center1));
	map.fitBounds(bounds);

};