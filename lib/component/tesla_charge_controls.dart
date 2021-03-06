library tesla_charge_controls;
import 'package:angular/angular.dart';
import 'package:tesla_extension/service/tesla_service.dart';
import 'dart:async';

@Component(selector: 'tesla-charge-controls', templateUrl:
    'packages/tesla_extension/component/tesla_charge_controls.html', cssUrl:
    'packages/tesla_extension/component/tesla_charge_controls.css', publishAs:
    'ctrl'
)
class TeslaChargeControls {
  List keyList;

  Map<String, num> levels = {
    "50%": 50,
    "60%": 60,
    "70%": 70,
    "80%": 80,
    "90%": 90,
    "MAX": 100
  };
  TeslaService _teslaService;
  TeslaService get teslaService => _teslaService;
  Http _http;
  num id;
  TeslaChargeControls(Http this._http, TeslaService this._teslaService){
     keyList = levels.keys.toList();
   }
  List getChargeLevels() {
    return keyList;
  }

  @NgAttr('vehicle-id')
  void set vehicleID(String vIDs) {
    var vID = int.parse(vIDs, onError: (_) => 0);
    assert(vID is int);
    if (vID > 0) {
      id = vID;
    
    }
  }
  bool settingChargeLevel = false;
  void setChargeLevel(String key) {
    if (id == null || id <= 0 || settingChargeLevel) {
      return;
    }
    num level = levels[key];
    settingChargeLevel = true;
    _teslaService.setChargeLimit(id, level).whenComplete(() {
      new Future.delayed(new Duration(seconds: 5), () {
        _teslaService.chargeState(id, true).whenComplete(() {
          settingChargeLevel = false;
        });
      });
    });
  }

  String chargeButtonClass() {
    if (settingChargeLevel || id == null || id <= 0) {
      return "disabled";
    }
    return "";
  }

}
