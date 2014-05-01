library tesla_battery_component;
import 'package:angular/angular.dart';
import 'package:tesla_extension/service/tesla_service.dart';
import 'package:tesla_extension/service/charge_state.dart';
import 'package:tesla_extension/service/gui_settings.dart';
import 'dart:async';

@Component(selector: 'tesla-battery', templateUrl:
    'packages/tesla_extension/component/tesla_battery_component.html', cssUrl:
    'packages/tesla_extension/component/tesla_battery_component.css', publishAs:
    'battery')
class TeslaBatteryComponent {
  ChargeState chargestate;

  TeslaService _teslaService;
  TeslaService get teslaService => _teslaService;
  Http _http;
  num id;
  GUI_Settings guiSettings;
    @NgTwoWay('show-limit')
  bool showlimit = false;

  void set slimit(String sl) {
    showlimit = (sl == "true");
  }

  TeslaBatteryComponent(Http this._http, TeslaService this._teslaService);
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

  String currentRange() {
    if (chargestate != null && guiSettings != null) {
      if (guiSettings.rangeDisplay == "Ideal") {
        if (guiSettings.distanceUnits == "km/hr") {
          return _mitok(chargestate.idealBatteryRange).toStringAsFixed(0);
        }
        return chargestate.idealBatteryRange.toStringAsFixed(0);
      }

      if (guiSettings.distanceUnits == "km/hr") {
        return _mitok(chargestate.batteryRange).toStringAsFixed(0);
      }
      return chargestate.batteryRange.toStringAsFixed(0);
    }
    return "";
  }

  String batteryLevel() {
    if (chargestate != null) {
      return "width" + chargestate.batteryLevel.toStringAsFixed(0);
    }
    return "";
  }

  String batteryChargeLimit() {
    if (chargestate != null && (showlimit || chargestate.chargingState ==
        "Charging")) {
      return "width" + chargestate.chargeLimitSoc.toStringAsFixed(0);
    }
    return "none";
  }

  String distanceUnit() {
    if (chargestate != null && guiSettings != null) {
      return guiSettings.distanceUnits.split('/')[0];
    }
    return "";
  }

  String rangeType() {
    if (chargestate != null && guiSettings != null) {
      return guiSettings.rangeDisplay + " Range";
    }
    return "";
  }

  bool showMaxRange() {
    if (chargestate != null && (showlimit || chargestate.chargingState ==
        "Charging")) {
      return chargestate.chargeLimitSoc == 100;
    }
    return false;
  }

  num _mitok(num mi) {
    return mi * 1.609;
  }
}
