library tesla_climate_component;
import 'package:angular/angular.dart';
import 'package:tesla_extension/service/tesla_service.dart';
import 'package:tesla_extension/service/climate_state.dart';
import 'package:tesla_extension/service/gui_settings.dart';
import 'dart:async';

@NgComponent(
    selector: 'tesla-climate',
    templateUrl: 'packages/tesla_extension/component/tesla_climate_component.html',
    cssUrl: 'packages/tesla_extension/component/tesla_climate_component.css',
    publishAs: 'climate',
    map: const{
     	'vehicle-id' : '=>vehicleID'
    }
)
class TeslaClimateComponent {
	ClimateState climatestate;

	TeslaService _teslaService;
	TeslaService get teslaService => _teslaService;
	Http _http;
	num id;
	GUI_Settings guiSettings;
	num currentTemp;
	num counter = 0;
	bool isFarenheit = false;
	TeslaClimateComponent(Http this._http, TeslaService this._teslaService){
		
	}

	set vehicleID(num vID){
		if (vID > 0){
			id = vID;
			_updateClimate();
			_teslaService.GUISettings(id)
      		.then((GUI_Settings settings){
  				guiSettings = settings;
  				if (guiSettings.temperatureUnits == "F"){
  					isFarenheit = true;
  				}
  			 },
			onError: (Object obj) {
        		print(obj);
      		});
		}
	}

	Future _updateClimate(){
		return _teslaService.climateState(id).then((ClimateState cstate){
				climatestate = cstate;
				if (counter == 0){
					if(isFarenheit){
						currentTemp = _CtoF(climatestate.driverTempSet);
					}else{
						currentTemp = climatestate.driverTempSet;
					}
				}
				}).then((_){
						_teslaService.climateUpdate.listen((ClimateState cstate){
							climatestate = cstate;
							if (counter == 0){
								if(isFarenheit){
									currentTemp = _CtoF(climatestate.driverTempSet);
								}else{
									currentTemp = climatestate.driverTempSet;
								}
							}
						});
					});
	}


	void setTemp(num diff){
		counter++;
		currentTemp+=diff;
		if(isFarenheit){
			if (currentTemp < 63){
				currentTemp = 63;
			}
			if (currentTemp > 90){
				currentTemp = 90;
			}
		}else{
			if (currentTemp < 17){
				currentTemp = 17;
			}
			if (currentTemp > 32){
				currentTemp = 32;
			}
		}
		void setTempFuture(){
			num testing2 = counter;
			new Future.delayed(new Duration(seconds:2), (){
				if (testing2 == counter){
					num temp = currentTemp;
					if (isFarenheit){
						temp = _FtoC(temp);
					}
					_teslaService.setTemps(id, temp).then((_){
						new Future.delayed(new Duration(seconds:3),(){ 
			    				_teslaService.climateState(id, true);
						});
					});
					counter = 0;
				}
				});
		}
		setTempFuture();
	}

	String driverTemp(){
		if (climatestate == null || guiSettings == null){
			return "";
		}
		if(isFarenheit){
			if (currentTemp <= 63){
				return "LO";
			}
			if (currentTemp > 89){
				return "HI";
			}
			return currentTemp.toStringAsFixed(0);
		}
		if (currentTemp <= 17){
			return "LO";
		}
		if (currentTemp >= 32){
			return "HI";
		}
		return currentTemp.toStringAsFixed(1);
	}

	String driverTempClass(){
		if (climatestate == null || guiSettings == null){
			return "";
		}
		if (isFarenheit){
			if(currentTemp <= 63 || currentTemp > 89){
				return "text";
			}
		}else{
			if(currentTemp <= 17 || currentTemp >= 32){
				return "text";
			}
		}
		return "";
	}

	String buttonClass(){
		if (!isFarenheit){
			return "c";
		}
		return "";
	}

	num _CtoF(num C){
		return C*1.8+32;
	}

	num _FtoC(num F){
		return (F-32)/1.8;
	}

	String climateClass(){
		if (climatestate != null){
			if((climatestate.autoConditioningOn != null && climatestate.autoConditioningOn) || (climatestate.fanStatus != null && climatestate.fanStatus > 0)){
				if(climatestate.insideTemp > climatestate.driverTempSet){
					return "cool";
				} else{
					return "hot";
				}
			}
		}
		return "";
	}

	String temperatureUnits(){
		if(guiSettings != null){
			return guiSettings.temperatureUnits;
		}
		return "";
	}

	

	String interiorTemp(){
		if(climatestate == null || guiSettings == null || climatestate.insideTemp == null){
			return "";
		}
		if (isFarenheit){
			return _CtoF(climatestate.insideTemp).toStringAsFixed(0);
		}
		return climatestate.insideTemp.toStringAsFixed(1);
	}
	bool showInteriorTemp(){
		if(climatestate == null || guiSettings == null || climatestate.insideTemp == null){
			return false;
		}
		return true;
	}

	String exteriorTemp(){
		if(climatestate == null || guiSettings == null || climatestate.outsideTemp == null){
			return "";
		}
		if (isFarenheit){
			return _CtoF(climatestate.outsideTemp).toStringAsFixed(0);
		}
		return climatestate.outsideTemp.toStringAsFixed(1);
	}
	bool showExteriorTemp(){
		if(climatestate == null || guiSettings == null || climatestate.outsideTemp == null){
			return false;
		}
		return true;
	}

	bool rearHeater(){
		if (climatestate != null){
			return climatestate.rearDefroster;
		}
		return false;
	}

	bool frontDefrost(){
		if (climatestate != null){
			return climatestate.frontDefroster != 0;
		}
		return false;
	}

	num diffAmount(){
		if (isFarenheit){
			return 1;
		}
		return .5;
	}
}