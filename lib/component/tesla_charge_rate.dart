library tesla_charge_rate;
import 'package:angular/angular.dart';
import 'package:tesla_extension/service/tesla_service.dart';
import 'package:tesla_extension/service/charge_state.dart';
import 'package:tesla_extension/service/gui_settings.dart';
import 'dart:async';

@Component(selector: 'tesla-charge-rate', templateUrl:
    'packages/tesla_extension/component/tesla_charge_rate.html', cssUrl:
    'packages/tesla_extension/component/tesla_charge_rate.css', publishAs: 'ctrl')
class TeslaChargeRate {
  ChargeState chargestate;
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
  GUI_Settings guiSettings;
  TeslaChargeRate(Http this._http, TeslaService this._teslaService);

  @NgTwoWay('vehicle-id')
  void set vehicleID(num vID) {
    if (vID > 0) {
      id = vID;
      _updateCharge();

      _teslaService.GUISettings(id).then((GUI_Settings settings) {
        guiSettings = settings;
      }, onError: (Object obj) {
        print(obj);
      });
    }
  }


  Future _updateCharge() {
    return _teslaService.chargeState(id).then((ChargeState cstate) {
      chargestate = cstate;
    }).then((_) {
      _teslaService.chargeUpdate.listen((ChargeState cstate) {
        chargestate = cstate;
      });
    });
  }

  String chargeRate() {
    if (chargestate != null && guiSettings != null) {
      if (guiSettings.chargeUnits == "kW") {
        return chargestate.chargerPower.toStringAsFixed(0);
      }
      if (guiSettings.chargeUnits == "km/hr") {
        return _mitok(chargestate.chargeRate).toStringAsFixed(0);
      }
      return chargestate.chargeRate.toStringAsFixed(0);
    }
    return "";
  }

  String guiChargeUnits() {
    if (guiSettings != null) {
      return guiSettings.chargeUnits;
    }
    return "";
  }

  String voltage() {
    if (chargestate != null) {
      return chargestate.chargerVoltage.toStringAsFixed(0);
    }
    return "";
  }
  String maxCurrent() {
    if (chargestate != null) {
      return chargestate.chargerPilotCurrent.toStringAsFixed(0);
    }
    return "";
  }

  String current() {
    if (chargestate != null) {
      return chargestate.chargerActualCurrent.toStringAsFixed(0);
    }
    return "";
  }
  bool showRate() {
    if (chargestate != null) {
      return chargestate.chargingState == "Charging";
    }
    return false;
  }

  num _mitok(num mi) {
    return mi * 1.609;
  }
}
