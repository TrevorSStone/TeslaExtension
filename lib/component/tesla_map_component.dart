library tesla_map_component;
import 'package:angular/angular.dart';
import 'package:tesla_extension/service/tesla_service.dart';
import 'package:tesla_extension/service/drive_state.dart';
import 'package:google_maps/google_maps.dart';
import 'dart:async';
import 'dart:html';

@NgComponent(
    selector: 'tesla-map',
    templateUrl: 'packages/tesla_extension/component/tesla_map_component.html',
    cssUrl: 'packages/tesla_extension/component/tesla_map_component.css',
    publishAs: 'map',
    map: const{
     	'vehicle-id' : '=>vehicleID'
    }
)
class TeslaMapComponent extends NgShadowRootAware{
	TeslaService _teslaService;
	TeslaService get teslaService => _teslaService;
	Http _http;
	DriveState drivestate;
	GMap map;
	Marker marker;
	InfoWindow infowindow;
	num id;
	bool mapInitialized = false;
	String address = "";
	StreamController _mapInitializeStream = new StreamController();
	Stream get _mapInitialize => _mapInitializeStream.stream;

	 GSymbol arrow = new GSymbol()
    	..path = SymbolPath.FORWARD_CLOSED_ARROW
		..fillColor = "#F00"
		..fillOpacity = 1
		..strokeColor = "#000"
		..scale= 6
		..strokeWeight = 3
    ;

	TeslaMapComponent(Http this._http, TeslaService this._teslaService){
	}

	void onShadowRoot(ShadowRoot shadowRoot) {

		final mapOptions = new MapOptions()
		    ..zoom = 16
		    ..center = new LatLng(33.7550, 84.3900)
		    ..mapTypeId = MapTypeId.ROADMAP
		    ;
		   map = new GMap(shadowRoot.querySelector("#map_canvas"), mapOptions);

		   mapInitialized = true;
		   _mapInitializeStream.add(true);
	}

	set vehicleID(num vID){
		if (vID > 0){
			id = vID;
			_updateDrive();
		}
	}

	Future _updateDrive(){
		return _teslaService.driveState(id).then((DriveState dstate){
				drivestate = dstate;
				updateAddress().then((_){
					if(mapInitialized){
			  			_placeMarker();
					}else{
						_mapInitialize.listen((_){
					  		_placeMarker();
						});
					}
				});
				
			}).then((_){
				_teslaService.driveUpdate.listen((DriveState dstate){
					drivestate = dstate;
					updateAddress().then((_){
						if(mapInitialized){
							_updateMap();
						}
					});
				});
						
			});	
	}

	Future updateAddress(){
		return _teslaService.googleGeocode(drivestate.latitude, drivestate.longitude).then((String add){
				address = add;
			});
	}

	void _placeMarker(){
	  arrow.rotation = drivestate.heading;
    marker = new Marker(new MarkerOptions()
    ..map = map
    ..draggable = false
    ..icon = arrow
    ..position = new LatLng(drivestate.latitude, drivestate.longitude)
    ..title = "Current Location"
    );
    infowindow = new InfoWindow(new InfoWindowOptions()
    	..content = formatAddress()
  	);
  	marker.onClick.listen((e) {
  		if (infowindow != null && address != ""){
    		infowindow.open(map, marker);
    	}
  	});

    map.center = new LatLng(drivestate.latitude, drivestate.longitude);
	}
	
	void _updateMap(){
		 marker.position = new LatLng(drivestate.latitude, drivestate.longitude);
		 arrow.rotation = drivestate.heading;
		 marker.icon = arrow;
		 infowindow.content = formatAddress();
	}

	String formatAddress(){
		return "<pre style='max-width:50%'>$address</pre>";
	}

}