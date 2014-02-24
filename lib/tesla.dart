library tesla_controller;

import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:tesla_extension/service/tesla_service.dart';
import 'package:tesla_extension/service/vehicles.dart';
import 'package:tesla_extension/service/gui_settings.dart';
import 'package:tesla_extension/service/vehicle_state.dart';
import 'package:tesla_extension/service/climate_state.dart';
import 'package:tesla_extension/service/charge_state.dart';
import 'package:tesla_extension/service/drive_state.dart';

@NgController(
	selector: '[tesla]',
    publishAs: 'ctrl')
class TeslaController {

	Http _http;
	TeslaService _teslaService;
	TeslaService get teslaService => _teslaService;
	bool showLogin = false;
	bool hideLogo = false;
	bool _showVehicle = false;
	bool _showLoading = false;
	bool _hasSunroof = false;
	Vehicle currentVehicle;
	GUI_Settings guiSettings;
	VehicleState vehiclestate;
	ChargeState chargestate;
	ClimateState climatestate;
	DriveState drivestate;
	String currentAddress ="";
	num _waitTime = 15;
	TeslaController(Http this._http, TeslaService this._teslaService) {
		_teslaService.vehicles()
    	.then((List<Vehicle> vehicles) {
			if (vehicles.length >0){
				currentVehicle = vehicles[0];
				
			}
		},
		onError: (Object obj) { //TODO different Error if no internet
        	window.location.replace('login.html');
      	})
      	.then((_){
      		return _checkMobile();
  		}).then((_){ 
      		_teslaService.GUISettings(currentVehicle.id)
      		.then((GUI_Settings settings){
  				guiSettings = settings;
  			 },
			onError: (Object obj) {
        		print(obj);
      		})
			.then((_){
				_updateCar();
				_updateCharge();
				_updateClimate();
				_updateDrive();
			});
  		});
		
	}
	Future _checkMobile(){
		return _teslaService.mobileEnabled(currentVehicle.id)
      		.then((bool enabled){

  				if (!enabled){
  					throw("Mobile is not enabled");
  				}
  				_showVehicle = true;
  				_showLoading = false;
  			 },
			onError: (Object obj) {
        		_showLoading = true;
        		return new Future.delayed(new Duration(seconds:_waitTime),(){
        					if (_waitTime > 10){
        						_waitTime--;
        					} 
	        				return _checkMobile();
	    				});
      		});
	}

	Future _updateCar(){
		return _teslaService.vehicleState(currentVehicle.id).then((VehicleState vstate){
			vehiclestate = vstate;
			}).then((_){
				_teslaService.vehicleUpdate.listen((VehicleState vstate){
					vehiclestate = vstate;
					});
				});
	}

	Future _updateCharge(){
		return _teslaService.chargeState(currentVehicle.id).then((ChargeState cstate){
				chargestate = cstate;
				}).then((_){
						_teslaService.chargeUpdate.listen((ChargeState cstate){
							chargestate = cstate;
						});
					});		
	}

	Future _updateClimate(){
		return _teslaService.climateState(currentVehicle.id).then((ClimateState cstate){
				climatestate = cstate;
				}).then((_){
						_teslaService.climateUpdate.listen((ClimateState cstate){
							climatestate = cstate;
						});
					});	
	}

	Future _updateDrive(){
		return _teslaService.driveState(currentVehicle.id).then((DriveState dstate){
				drivestate = dstate;
				updateAddress();
				}).then((_){
						_teslaService.driveUpdate.listen((DriveState dstate){
							drivestate = dstate;
							updateAddress();
						});
				});	
	}

	void logout(){
		_teslaService.logout().then((_) => window.location.replace('login.html'));
	}

	String logoClass() {
		return showLogin ? "fade" : "";
	}
	String currentVin(){
		if (currentVehicle != null){
			return currentVehicle.vinSix();
		}
		return "";
	}

	num vehicleID(){
		if (currentVehicle != null){
			return currentVehicle.id;
		}
		return -1; 
	} 

	bool showVehicle(){
	 	return _showVehicle;
	}

	bool showLoading(){
		return _showLoading;
	}

	void updateAddress(){
		_teslaService.googleGeocode(drivestate.latitude, drivestate.longitude).then((String add){
				currentAddress = add;
			});
	}

	String currentVehicleColor(){
		if (currentVehicle == null){
			return "";
		}
		var options = currentVehicle.option_codes.split(',');
		if (options.length <7){
			return "";
		}
		switch (options[6]){
			case 'PBSB':
				return "black";
				break;
			case 'PBCW':
				return 'white';
				break;
			case 'PMSS':
				return 'silver';
				break;
			case 'PMTG':
				return 'gray';
				break;
			case 'PMAB':
				return 'brown';
				break;
			case 'PMMB':
				return 'blue';
				break;
			case 'PMSG':
				return 'green';
				break;
			case 'PPSW':
				return 'pearlwhite';
				break;
			case 'PPMR':
				return 'newred';
				break;
			case 'PPSR':
				return 'red';
				break;
			default:
				return "white";
		}
	}

	String currentVehicleRims(){
		if (currentVehicle == null){
			return "";
		}
		var options = currentVehicle.option_codes.split(',');
		if (options.length <9){
			return "";
		}
		switch (options[8]){
			case 'WTSP':
				return "grey";
				break;
			case 'WTSG':
				return 'grey';
				break;
			default:
				return "";
		}
	}

	String currentRoofType(){
		if (currentVehicle == null){
			return "";
		}
		var options = currentVehicle.option_codes.split(',');
		if (options.length <8){
			return "";
		}
		switch (options[7]){
			case 'RFPO':
				_hasSunroof = true;
				return "sunroof";
				break;
			case 'RFBK':
				return 'black';
				break;
			default:
				return "";
		}
	}

	bool showSunroofButton(){
		return _showVehicle && _hasSunroof;
	}

	bool locking = false;
	void lockCar(){
		if (currentVehicle == null){
			return;
		}
		if (vehiclestate != null && !locking){
			if (!vehiclestate.isLocked){
				locking = true;
				_teslaService.lockDoors(currentVehicle.id).then((_){
					new Future.delayed(new Duration(seconds:1),
            			(){ 
            				_teslaService.vehicleState(currentVehicle.id, true).whenComplete((){
            					locking = false;
            					});
        				});
					});
			}
		}
	}

	bool unlocking = false;
	void unlockCar(){
		if (currentVehicle == null){
			return;
		}
		if (vehiclestate != null && !unlocking){
			if (vehiclestate.isLocked){
				unlocking = true;
				_teslaService.unlockDoors(currentVehicle.id).whenComplete((){
					new Future.delayed(new Duration(seconds:1),(){ 
            				_teslaService.vehicleState(currentVehicle.id, true).whenComplete((){
            					unlocking = false;
            					});
        				});
					
					});
			}
		}
	}


	String lockButtonClass(){
		if (vehiclestate != null){
			if (!vehiclestate.isLocked && !locking){
				return "";
			}
		}
		return "disabled";
	}

	String unlockButtonClass(){
		if (vehiclestate != null){
			if (vehiclestate.isLocked && !unlocking){
				return "";
			}
		}
		return "disabled";
	}

	bool honking = false;
	void honkHorn(){
		if (currentVehicle == null){
			return;
		}
		if (vehiclestate != null && !honking){
			
				honking = true;
				_teslaService.honkHorn(currentVehicle.id).whenComplete((){
					honking = false;
					});
		}
	}

	String hornButtonClass(){
		if (vehiclestate != null){
			if (!honking){
				return "";
			}
		}
		return "disabled";
	}

	bool flashing = false;
	void flashLights(){
		if (currentVehicle == null){
			return;
		}
		if (vehiclestate != null && !flashing){
			
				flashing = true;
				_teslaService.flashLights(currentVehicle.id).whenComplete((){
					flashing = false;
					});
		}
	}

	String lightsButtonClass(){
		if (vehiclestate != null){
			if (!flashing){
				return "";
			}
		}
		return "disabled";
	}


	String roofButtonText(){
		if (vehiclestate != null){
			if (vehiclestate.sunRoofPercent > 0){
				return "CLOSE ROOF";
			}
		}
			return "VENT ROOF";
	}
	bool togglingRoof = false;
	void toggleRoof(){
		if (currentVehicle == null){
			return;
		}
		if (vehiclestate != null && !togglingRoof){
			String newRoofState ="vent";
			if (vehiclestate.sunRoofPercent > 0){
				newRoofState = "close";
			}
			togglingRoof = true;
			_teslaService.setSunRoof(currentVehicle.id, newRoofState).then((_){
				new Future.delayed(new Duration(seconds:1),(){ 
        				_teslaService.vehicleState(currentVehicle.id, true).then((_){
        					togglingRoof = false;
        					});
    				});
				
				});
		}
	}

	String roofButtonClass(){
		if (vehiclestate != null){
			if (!togglingRoof){
				return "";
			}
		}
		return "disabled";
	}
	
	bool togglingCharging = false;
	void toggleCharging(){
		if (currentVehicle == null){
			return;
		}
		if (chargestate == null || togglingCharging){
			return;
		}
		togglingCharging = true;
		if (!chargestate.chargePortDoorOpen || chargestate.chargingState == "Disconnected"){
			_teslaService.openChargePort(currentVehicle.id).whenComplete((){
				new Future.delayed(new Duration(seconds:1),(){ 
        				_teslaService.vehicleState(currentVehicle.id, true);
        				_teslaService.chargeState(currentVehicle.id, true).whenComplete((){
	        					togglingCharging = false;
	        					});
    				});
				});
		} else{
			switch (chargestate.chargingState){
				case 'Stopped':
					_teslaService.startCharging(currentVehicle.id).whenComplete((){
						new Future.delayed(new Duration(seconds:8),(){ 
	        				_teslaService.chargeState(currentVehicle.id, true).whenComplete((){
	        					togglingCharging = false;
	        					});
	    				});
					});
					break;
				default:
					_teslaService.stopCharging(currentVehicle.id).whenComplete((){
						new Future.delayed(new Duration(seconds:8),(){ 
		        				_teslaService.chargeState(currentVehicle.id, true).whenComplete((){
	        					togglingCharging = false;
	        					});
		    				});
						});
			}
		}
	}

	String chargeButtonClass(){
		if (chargestate != null){
			if (!togglingCharging){
				return "";
			}
		}
		return "disabled";
	}

	String chargingButtonText(){
		if (chargestate == null){
			return "";
		}
		if (!chargestate.chargePortDoorOpen || chargestate.chargingState == "Disconnected"){
			return "Open Charge Port";
		}
		switch (chargestate.chargingState){
			case 'Stopped':
				return "Start Charging";
				break;
			default:
				return "Stop Charging";
		}
		return "";
	}

	bool showChargingButton(){
		if (chargestate == null || drivestate == null){
			return false;
		}
		if (drivestate.shiftState != null && drivestate.shiftState != "P"){
			return false;
		}
		if (!chargestate.chargePortDoorOpen && chargestate.chargingState == "Disconnected"){
			return true;
		}
		if (chargestate.chargingState != "Complete" && chargestate.chargeLimitSoc > chargestate.batteryLevel){ //TODO: or when not in park or when charging complete
			return true;
		}
		return false;
	}

	String climateButtonText(){
		if (climatestate == null){
			return "";
		}
		if ((climatestate.autoConditioningOn != null && climatestate.autoConditioningOn) || (climatestate.fanStatus != null && climatestate.fanStatus > 0)){
			return "Turn Off";
		}
		return "Turn On";
	}

	bool showClimateButton(){
		if (climatestate==null){
			return false;
		}
		return true;
	}



	bool togglingHVAC = false;
	void toggleHVAC(){
		if (currentVehicle == null){
			return;
		}
		if (climatestate != null && !togglingHVAC){
			togglingHVAC = true;
			if((climatestate.autoConditioningOn != null && climatestate.autoConditioningOn) || (climatestate.fanStatus != null && climatestate.fanStatus > 0)){
				_teslaService.stopHVAC(currentVehicle.id).whenComplete((){
				new Future.delayed(new Duration(seconds:5),(){ 
        				_teslaService.climateState(currentVehicle.id, true).whenComplete((){
        					togglingHVAC = false;
        					});
    				});
				
				});
			}else{
				_teslaService.startHVAC(currentVehicle.id).whenComplete((){
					new Future.delayed(new Duration(seconds:5),(){ 
        				_teslaService.climateState(currentVehicle.id, true).whenComplete((){
        					togglingHVAC = false;
        					});
    				});
				
				});
			}
		}
	}

	String climateButtonClass(){
		if (climatestate != null){
			if (!togglingHVAC){
				return "";
			}
		}
		return "disabled";
	}

	String padlockClass(){
		if (vehiclestate == null){
			return "";
		}
		if (vehiclestate.isLocked){
			return "locked";
		}
		return "unlocked";
	}

	String homeStatus(){
		if (chargestate == null || drivestate == null || guiSettings == null){
			return "";
		}
		if (chargestate.chargingState == "Charging"){
			String firstline="Charging";
			String secondline = "";
			if (chargestate.timeToFullCharge.floor() > 0 ){
				secondline = "${chargestate.timeToFullCharge.floor()} hr ";
			}
			secondline += "${timeToChargeMinutes(chargestate.timeToFullCharge).toStringAsFixed(0)} min remaining";
			return "$firstline\n$secondline";
		}

		if (drivestate.shiftState != null){
			String firstline="";
			switch (drivestate.shiftState){
				case 'P':
					firstline = "Parked";
					break;
				case 'R':
					firstline = 'In Reverse';
					break;
				case 'N':
					firstline = 'In Neutral';
					break;
				case 'D':
					if (drivestate.speed != null && drivestate.speed > 0){
						firstline = 'Driving';
					}else{
					firstline = 'In Drive';
					}
					break;
				default:
					firstline = "Parked";
			}
			String secondline = "";
			if (drivestate.speed != null && drivestate.speed > 0){
				if(guiSettings.distanceUnits == "km/hr"){
					secondline = _mitok(drivestate.speed).toStringAsFixed(0) + " " 
						+ "kph";
				} else{
					secondline = drivestate.speed.toStringAsFixed(0) + " " 
						+ "mph";
				}
			}
			return "$firstline\n$secondline";
		}

		return "Parked";
	}

	String chargeStatus(){
		if (chargestate == null || drivestate == null || guiSettings == null){
			return "";
		}
		if (chargestate.chargingState == "Charging" || chargestate.chargingState == "Starting"){
			String firstline="Charging";
			String secondline = "";
			if (chargestate.timeToFullCharge.floor() > 0 ){
				secondline = "${chargestate.timeToFullCharge.floor()} hr ";
			}
			secondline += "${timeToChargeMinutes(chargestate.timeToFullCharge).toStringAsFixed(0)} min remaining";
			return "$firstline\n$secondline";
		}

		if(chargestate.chargingState == "Stopped"){
			return "Charging Stopped";
		}

		if (chargestate.chargingState == "Complete"){
			return "Charging Complete";
		}

		if(chargestate.chargingState == "NoPower"){
			return "No Power To Charger";
		}

		if (chargestate.chargingState == "Disconnected" && chargestate.chargePortDoorOpen){
			return "Charge Port Open\nConnect charge cable";
		}

		if (drivestate.shiftState != null && drivestate.shiftState != "P"){
			return "Car is in motion";
		}

		return "Charge Port Closed";
	}

	bool isPluggedIn(){
		if (chargestate == null){
			return false;
		}
		return chargestate.chargingState != "Disconnected";
	}

	bool isChargeDoorOpen(){
		if (chargestate == null){
			return false;
		}
		return chargestate.chargePortDoorOpen;
	}

	num timeToChargeMinutes(num hours){
		hours = hours - hours.floor();
		return 60*hours;
	}
	
	num _mitok(num mi){
		return mi * 1.609;
	}
}
