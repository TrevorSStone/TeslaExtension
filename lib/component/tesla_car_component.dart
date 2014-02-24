library tesla_car_component;
import 'package:angular/angular.dart';
import 'package:tesla_extension/service/tesla_service.dart';
import 'package:tesla_extension/service/vehicle_state.dart';
import 'dart:async';

@NgComponent(
    selector: 'tesla-car',
    templateUrl: 'packages/tesla_extension/component/tesla_car_component.html',
    cssUrl: 'packages/tesla_extension/component/tesla_car_component.css',
    publishAs: 'car',
    map: const{
    	'vehicle-id' : '=>vehicleID',
    	'roof-type' : '=>roofType',
    	'wheel-type' : '=>wheelType',
    	'plugged-in' : '=>pluggedin',
    	'charge-door-open' : '=>chargeDoorOpen',
    	'car-color' : '=>carColor'
    }
)
class TeslaCarComponent {
	VehicleState state;
	TeslaService _teslaService;
	TeslaService get teslaService => _teslaService;
	Http _http;
	num id;
	String carColor = "";
	String roofType;
	String wheelType;
	bool pluggedin = false;
	bool chargeDoorOpen = false;
	TeslaCarComponent(Http this._http, TeslaService this._teslaService){
	}

	set vehicleID(num vID){
		if (vID > 0){
		id = vID;
		_updateCar();
		}
	}

	Future _updateCar(){
		return _teslaService.vehicleState(id).then((VehicleState vstate){
			state = vstate;
			}).then((_){
				_teslaService.vehicleUpdate.listen((VehicleState vstate){
					state = vstate;
					});
				});
	}

	String chargeState(){
		String classes="";
		if (chargeDoorOpen){
			classes = "open";
		}
		if(pluggedin){
			classes = "open pluggedin";
		}

		return classes;
	}

	String roof(){
		if (state != null){
			if(state.sunRoofState == "unknown"){
				if (state.sunRoofPercent > 0 && state.sunRoofPercent < 50){
					return "$roofType vent";
				}
				if (state.sunRoofPercent >= 50){
					return "$roofType open";
				}
			}
			return "$roofType ${state.sunRoofState}";
		}
		return roofType;
	}

	String wheelClass(){
		if (wheelType != null){
			return wheelType;
		}
		return "";
	}

	String leftFront(){
		if (state != null){
			if (state.driverFrontOpen != 0){
				return "open";
			}
		}
		return "";
	}

	String leftRear(){
		if (state != null){
			if (state.driverRearOpen != 0){
				return "open";
			}
		}
		return "";
	}

	String rightFront(){
		if (state != null){
			if (state.passFrontOpen != 0){
				return "open";
			}
		}
		return "";
	}


	String rightRear(){
		if (state != null){
			if (state.passRearOpen != 0){
				return "open";
			}
		}
		return "";
	}

	String frunk(){
		if (state != null){
			if (state.frunkOpen != 0){
				return "open";
			}
		}
		return "";
	}

	String trunk(){
		if (state != null){
			if (state.trunkOpen != 0){
				return "open";
			}
		}
		return "";
	}
}