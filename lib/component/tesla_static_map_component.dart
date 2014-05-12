library tesla_static_map_component;
import 'package:angular/angular.dart';
import 'package:tesla_extension/service/tesla_service.dart';
import 'package:tesla_extension/service/drive_state.dart';
import 'dart:async';
import 'dart:html';

@Component(selector: 'tesla-map', templateUrl:
    'packages/tesla_extension/component/tesla_static_map_component.html', cssUrl:
    'packages/tesla_extension/component/tesla_static_map_component.css', publishAs: 'map')
class TeslaMapComponent   {
  TeslaService _teslaService;
  TeslaService get teslaService => _teslaService;
  Http _http;
  DriveState drivestate;
  num id;
  String address = "";
 String center = "";

  TeslaMapComponent(Http this._http, TeslaService this._teslaService);
 

@NgAttr('vehicle-id')
  void set vehicleID(String vIDs) {
    var vID = int.parse(vIDs, onError: (_) => 0);
    assert(vID is int);
    if (vID > 0) {
      id = vID;
      _updateDrive();
    }
  }

  Future _updateDrive() {
    return _teslaService.driveState(id).then((DriveState dstate) {
      drivestate = dstate;
      updateAddress().then((_) {
          _placeMarker();
        }
      );

    }).then((_) {
      _teslaService.driveUpdate.listen((DriveState dstate) {
        drivestate = dstate;
        updateAddress().then((_) { 
            _updateMap();
        });
      });

    });
  }

  Future updateAddress() {
    return _teslaService.googleGeocode(drivestate.latitude, drivestate.longitude
        ).then((String add) {
      address = add;
    });
  }

  void _placeMarker() {
   

    center = "${drivestate.latitude}, ${drivestate.longitude}";
  }

  void _updateMap() {
  	 center = "${drivestate.latitude}, ${drivestate.longitude}";
  	 
    // marker.position = new LatLng(drivestate.latitude, drivestate.longitude);
    // arrow.rotation = drivestate.heading;
    // marker.icon = arrow;
    // infowindow.content = formatAddress();
  }

  String formatAddress() {
    return "<pre style='max-width:50%'>$address</pre>";
  }

}
