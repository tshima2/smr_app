var clicklat, clicklon;
var retrieved_datas=[];
var drawd_waiting_points=[];

// main function
$(function(){
  var arrJsonPoints=$('.arr_json_points').val();
  var arrJsonLines=$('.arr_json_lines').val();
  var arrJsonPolygons=$('.arr_json_polygons').val();
  var conf={
    points: JSON.parse(arrJsonPoints),
    lines: JSON.parse(arrJsonLines),
    polygons: JSON.parse(arrJsonPolygons)
  };
  $.initMap($, conf);
});

// draw map from kml
jQuery.initMap = function ($, conf) {
  console.log("INFO : initMap() start")

  //initialize clickmenu
  $("#site_show_clickmenu").menu();
  $("#site_show_clickmenu").hover(function(e) {
  }, function(e) {
    $("#site_show_clickmenu").css('display', 'none');
  });

  //initialize map controls
  var infoWindow,
    ns = google.maps,
    mapOptions = {
      zoom: 14,
      mapTypeControl: false,
      panControl: false,
      streetViewControl: true,
      zoomControl: true,
      scaleControl: true,
      overviewMapControl: true
    },
    map = new google.maps.Map($("#mapDiv")[0], mapOptions),
    points = new google.maps.MVCArray(conf.points),
    lines = new google.maps.MVCArray(conf.lines),
    polygons = new google.maps.MVCArray(conf.polygons),
    bounds = new google.maps.LatLngBounds();
  
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
      myLatlng = new google.maps.LatLng(point[3], point[2]),
        obj_marker = new google.maps.Marker({
          position: myLatlng,
          title: String(point[0]),
          animation:google.maps.Animation.DROP,
          icon: `/map_icons/number_${index+1}.png`,
          map: map
        });

      bounds.extend(myLatlng);
      google.maps.event.addListener(obj_marker, 'click', function () {
        if (!infoWindow) {
          infoWindow  = new google.maps.InfoWindow();
        }
        infoWindow.setContent(point[1]);
        infoWindow.open(map, obj_marker);
      });
    });
    center1 /= coord_count;
    center2 /= coord_count;
    center3 /= coord_count;
    map.setCenter(new google.maps.LatLng(center2, center1));
    map.fitBounds(bounds);
  }

  //draw lineStrings
  if(lines.length>0){
    center1=center2=coord_count=0;
    lines.forEach(function (line, index) {
      var myLatlng;
      var obj_polyline;
      var path = new google.maps.MVCArray();
      for(var  i=0; ((3*i)+2)<line.length; i++){
        var j=(3*i)+2;
        path.push ( myLatlng = new google.maps.LatLng( line[j+1], line[j] ));
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
      obj_polyline = new google.maps.Polyline( polylineOptions );  

      google.maps.event.addListener(obj_polyline, 'click', function (event) {
        if (!infoWindow) {
          infoWindow  = new google.maps.InfoWindow();
        }
        infoWindow.setContent(line[1]);
        infoWindow.setPosition(event.latLng);
        infoWindow.open(map, obj_polyline);
      });
    });
    map.setCenter(new google.maps.LatLng(center2, center1));
    map.fitBounds(bounds);
  }

  //draw polygons
  if(polygons.length>0){
    center1=center2=coord_count=0;
    polygons.forEach(function (polygon, index) {
      var myLatlng;
      var obj_polygon;
      var path = new google.maps.MVCArray();
      for(var  i=0; ((3*i)+2)<polygon.length; i++){
        var j=(3*i)+2;
        path.push ( myLatlng = new google.maps.LatLng( polygon[j+1], polygon[j] ) );
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
      obj_polygon = new google.maps.Polygon( polygonOptions );
      google.maps.event.addListener(obj_polygon, 'click', function (event) {
        if (!infoWindow) {
          infoWindow  = new google.maps.InfoWindow();
        }
        infoWindow.setContent(polygon[0]);
        infoWindow.setPosition(event.latLng);
        infoWindow.open(map, obj_polygon);
      });
    });
    center2 /= coord_count; 
    center1 /= coord_count; 
    map.setCenter(new google.maps.LatLng(center2, center1));
    map.fitBounds(bounds);

  }

  //map click-events
  google.maps.event.addListener(map, 'click', function(event){
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
    RetrieveWaitingPoints(1000, map, bounds);
  });

  //click-menu(5) events ajax comm
  $("#li_show_waitingpoints_u5").click(function(event){
    RetrieveWaitingPoints(5000, map, bounds);
  });

  console.log("INFO : initMap() finish")
}

//waiting-points retrieve request
function RetrieveWaitingPoints(dist, map, bounds) {
  console.log("INFO : RetrieveWaitingPoints start", dist);

  $.ajax({
    url: 'http://192.168.0.22:3000/api/v1/retrieve_waiting_points',
    type: 'GET',
    dataType: 'json',
    data: 'dist='+String(dist)+'&lat='+String(clicklat)+'&lon='+String(clicklon),
    scriptCharset: 'utf-8',
    timeout: 5000,
    success: function(data){
      console.log("INFO: ajax.success start", data);
      retrieved_datas.length=0;
      for(var i=0; i<data["data"].length; i++){
        retrieved_datas.push(data["data"][i]);
      }
      if(i>0) 
        DrawWaitingPoints(map, bounds);
      else 
        alert("no waiting_points within specified distance.");
      console.log("INFO : ajax.success");
    },
    error: function(){
      alert("no response from server to retrieve waiting-points.");
      console.log("ERROR: ajax.error");
    }  
  }); 
  console.log("INFO : RetrieveWaitingPoints finish");
}

// draw waiting-points markers
function DrawWaitingPoints(map, bounds){
  console.log("INFO : DrawWaitingPoints start");

  if(retrieved_datas.length>0){
    var center_lat=0, center_lon=0, coord_count=0;  
  
    //clear drawd markers on map
    for(var i=0; i<drawd_waiting_points.length; i++){
      let marker=drawd_waiting_points[i];
      marker.setMap(null);
      marker=null;
    }
    drawd_waiting_points.length=0;

    // fit back to original bounds 
    map.fitBounds(bounds);

    //draw items
    var infoWindow=null;
    var bounds_for_wp = new google.maps.LatLngBounds();
    Object.assign(bounds_for_wp, JSON.parse(JSON.stringify(bounds)));
    retrieved_datas.forEach(function (data, index) {
      center_lat += data["lat"];
      center_lon += data["lon"];
      coord_count++;
    
      var myLatlng;
      var obj_marker;
      myLatlng = new google.maps.LatLng(data["lon"], data["lat"]),
        obj_marker = new google.maps.Marker({
          position: myLatlng,
          title: data["name"],
          animation:google.maps.Animation.DROP,
          map: map
        });
      drawd_waiting_points.push(obj_marker);  
  
      bounds_for_wp.extend(myLatlng);
      google.maps.event.addListener(obj_marker, 'click', function () {
        if (!infoWindow) {
          infoWindow  = new google.maps.InfoWindow();
        }
        infoWindow.setContent(data["name"]);
        infoWindow.open(map, obj_marker);
      });
    });
    center_lat /= coord_count;
    center_lon /= coord_count;
    map.setCenter(new google.maps.LatLng(center_lat, center_lon));
    map.fitBounds(bounds_for_wp);
  }
  console.log("INFO : DrawWaitingPoints finish");
}