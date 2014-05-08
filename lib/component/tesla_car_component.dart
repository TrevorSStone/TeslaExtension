library tesla_car_component;
import 'package:angular/angular.dart';
import 'package:tesla_extension/service/tesla_service.dart';
import 'package:tesla_extension/service/vehicle_state.dart';
import 'dart:html';
import 'dart:async';

@Component(selector: 'tesla-car', templateUrl:
    'packages/tesla_extension/component/tesla_car_component.html', cssUrl:
    'packages/tesla_extension/component/tesla_car_component.css', publishAs: 'car')
class TeslaCarComponent extends ShadowRootAware {
  VehicleState state;
  TeslaService _teslaService;
  TeslaService get teslaService => _teslaService;
  Http _http;
  num id;
  
   @NgTwoWay('car-color')
  String carColor;
   
   @NgTwoWay('roof-type')
  String roofType;
   
   @NgTwoWay('wheel-type')
  String wheelType;
   
 @NgTwoWay('plugged-in')
  bool pluggedin = false;
   
  void set plugged(String pi) {
    pluggedin = (pi == "true");
  }


  @NgTwoWay('charge-door-open')
  bool chargeDoorOpen = false;
    void set chargeOpen(String co) {
    chargeDoorOpen = (co == "true");
  }

  TeslaCarComponent(Http this._http, TeslaService this._teslaService);
  
  void onShadowRoot(ShadowRoot shadowRoot) {

     
     HttpRequest.getString('../svg/car/body.svg').then((text) {
       var inner = shadowRoot.querySelector("#car");
       inner.setInnerHtml(text);    
       
     });  
   }
  
  @NgTwoWay('vehicle-id')
  void set vehicleID(num vID) {
    // var vID = int.parse(vIDs, onError: (_) => 0);
    // assert(vID is int);
    if (vID > 0) {
      id = vID;
      _updateCar();
    
    }
  }

  Future _updateCar() {
    return _teslaService.vehicleState(id).then((VehicleState vstate) {
      state = vstate;
    }).then((_) {
      _teslaService.vehicleUpdate.listen((VehicleState vstate) {
        state = vstate;
      });
    });
  }

  String chargeState() {
    String classes = "";
    if (chargeDoorOpen) {
      classes = "chargeopen";
    }
    if (pluggedin) {
      classes = "chargeopen pluggedin";
    }

    return classes;
  }

  String roof() {
    if (state != null) {
      if (state.sunRoofState == "unknown") {
        if (state.sunRoofPercent == 0){
          return "$roofType";
        }
        if (state.sunRoofPercent > 0 && state.sunRoofPercent < 50) {
          return "$roofType vent";
        }
        if (state.sunRoofPercent >= 50) {
          return "$roofType open";
        }
      }
      return "$roofType ${state.sunRoofState}";
    }
    return roofType;
  }

  String wheelClass() {
    if (wheelType != null) {
      return wheelType;
    }
    return "";
  }

  String leftFront() {
    if (state != null) {
      if (state.driverFrontOpen != 0) {
        return "fdopen";
      }
    }
    return "";
  }

  String leftRear() {
    if (state != null) {
      if (state.driverRearOpen != 0) {
        return "rdopen";
      }
    }
    return "";
  }

  String rightFront() {
    if (state != null) {
      if (state.passFrontOpen != 0) {
        return "fpopen";
      }
    }
    return "";
  }


  String rightRear() {
    if (state != null) {
      if (state.passRearOpen != 0) {
        return "rpopen";
      }
    }
    return "";
  }

  String frunk() {
    if (state != null) {
      if (state.frunkOpen != 0) {
        return "open";
      }
    }
    return "";
  }

  String trunk() {
    if (state != null) {
      if (state.trunkOpen != 0) {
        return "open";
      }
    }
    return "";
  }
}
