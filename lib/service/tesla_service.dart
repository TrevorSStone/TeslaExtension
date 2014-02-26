library tesla_service;
import 'dart:async';
import 'package:angular/angular.dart';
import 'package:tesla_extension/service/vehicles.dart';
import 'package:tesla_extension/service/gui_settings.dart';
import 'package:tesla_extension/service/vehicle_state.dart';
import 'package:tesla_extension/service/charge_state.dart';
import 'package:tesla_extension/service/climate_state.dart';
import 'package:tesla_extension/service/drive_state.dart';


class TeslaService {
  static const String _baseUrl = 'https://portal.vn.teslamotors.com';
  static const String _loginUrl = '$_baseUrl/login';
  static const String _logoutUrl = '$_baseUrl/logout';
  static const String _apiVehiclesUrl = '$_baseUrl/vehicles';
  static const String _apiEnabledUrl = 'mobile_enabled';
  static const String _apiGuiInfoUrl = 'command/gui_settings';
  static const String _apiVehicleStateUrl = 'command/vehicle_state';
  static const String _apiChargeStateUrl = 'command/charge_state';
  static const String _apiClimateStateUrl = 'command/climate_state';
  static const String _apiDriveStateUrl = 'command/drive_state';
  static const String _apiLockDoorUrl = 'command/door_lock';
  static const String _apiUnlockDoorUrl = 'command/door_unlock';
  static const String _apiFlashLightsUrl = 'command/flash_lights';
  static const String _apiHonkHornUrl = 'command/honk_horn';
  static const String _apiSunRoofUrl = 'command/sun_roof_control?state=';
  static const String _apiChargeLimitUrl = 'command/set_charge_limit?percent=';
  static const String _apiOpenChargePortUrl = 'command/charge_port_door_open';
  static const String _apiStartChargingUrl = 'command/charge_start';
  static const String _apiStopChargingUrl = 'command/charge_stop';
  static const String _apiSetTempsUrl = 'command/set_temps';
  static const String _apiStartHVACUrl = 'command/auto_conditioning_start';
  static const String _apiStopHVACUrl = 'command/auto_conditioning_stop';
  static const String _googleGeocode =
      'http://maps.googleapis.com/maps/api/geocode/json?latlng=';

  Http _http;
  Map<num, GUI_Settings> _settingscache = {};
  List<Vehicle> _vehicleListcache;
  Map<num, VehicleState> _vehicleStateCache = {};
  Map<num, ChargeState> _chargeStateCache = {};
  Map<num, ClimateState> _climateStateCache = {};
  Map<num, DriveState> _driveStateCache = {};
  Map<String, String> _geocacheCache = {};

  StreamController _vehicleUpdateController = new StreamController.broadcast(
      sync: true);
  Stream get vehicleUpdate => _vehicleUpdateController.stream;
  StreamController _chargeUpdateController = new StreamController.broadcast(
      sync: true);
  Stream get chargeUpdate => _chargeUpdateController.stream;
  bool _chargeUpdated = false;
  StreamController _climateUpdateController = new StreamController.broadcast(
      sync: true);
  Stream get climateUpdate => _climateUpdateController.stream;
  bool _climateUpdated = false;
  StreamController _driveUpdateController = new StreamController.broadcast(sync:
      true);
  Stream get driveUpdate => _driveUpdateController.stream;
  bool _driveUpdated = false;
  TeslaService(Http this._http);
  Future login() {
    return _http.get(_loginUrl);
  }

  Future logout() {
    return _http.get(_baseUrl).then((HttpResponse response) {
      String authToken = response.data.substring(226, 226 + 44);
      String uri = '_method=delete&authenticity_token=$authToken';
      Map<String, String> headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      return _http.post(_logoutUrl, uri, headers: headers);
    });



  }

  Future postLogin(String username, String password) {
    String uri =
        'user_session[email]=$username&user_session[password]=$password';
    String encoded = Uri.encodeFull(uri);
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    return _http.post(_loginUrl, encoded, headers: headers);
  }

  Future vehicles() {
    if (_vehicleListcache != null) {
      return new Future.value(_vehicleListcache);
    }
    return _http.get(_apiVehiclesUrl).then((HttpResponse response) {
      _vehicleListcache = [];
      if (response.data is String) {
        throw ("Response Data Not JSON");
      }
      for (Map vehicles in response.data) {
        Vehicle v = new Vehicle.fromJsonMap(vehicles);
        _vehicleListcache.add(v);
      }
      new Future.delayed(new Duration(minutes: 30), () => _vehicleListcache =
          null);
      return _vehicleListcache;
    });
  }

  Future mobileEnabled(num id) {
    String url = "$_apiVehiclesUrl/$id/$_apiEnabledUrl";
    return _http.get(url).then((HttpResponse response) {
      if (response.data is String) {
        throw ("Response Data Not JSON");
      }
      if (response.data['result']) {
        return true;
      } else {
        throw (response.data['reason']);
      }
    });
  }

  Future GUISettings(num id) {
    if (_settingscache.containsKey(id)) {
      return new Future.value(_settingscache[id]);
    }
    String url = "$_apiVehiclesUrl/$id/$_apiGuiInfoUrl";
    return _http.get(url).then((HttpResponse response) {
      if (response.data is String) {
        throw ("Response Data Not JSON");
      }
      _settingscache[id] = new GUI_Settings.fromJsonMap(response.data);
      return _settingscache[id];
    }, onError: (Object obj) {
      return new Future.delayed(new Duration(seconds: 10), () => GUISettings(id)
          );
    });

  }
  Future _vehicleFirstRun;
  Future vehicleState(num id, [bool singleRun = false]) {
    if ((_vehicleStateCache.containsKey(id) || _vehicleFirstRun != null) &&
        !singleRun) {
      return _vehicleFirstRun.then((_) => new Future.value(
          _vehicleStateCache[id]));
    }
    if (singleRun) {
      return _setVehicleState(id, singleRun);
    }
    _vehicleFirstRun = _setVehicleState(id, singleRun);
    return _vehicleFirstRun;
  }

  Future _setVehicleState(num id, [bool singleRun = false]) {
    String url = "$_apiVehiclesUrl/$id/$_apiVehicleStateUrl";
    return _http.get(url).then((HttpResponse response) {
      if (response.data is String) {
        throw ("Response Data Not JSON: $response.data");
      }
      _vehicleStateCache[id] = new VehicleState.fromJsonMap(response.data);
      _vehicleUpdateController.add(_vehicleStateCache[id]);
      if (!singleRun) {
        new Future.delayed(new Duration(seconds: 30), () => _setVehicleState(id)
            );
      }
      return _vehicleStateCache[id];
    }, onError: (Object obj) {
      if (!singleRun) {
        new Future.delayed(new Duration(seconds: 10), () => _setVehicleState(id)
            );
      }
    });
  }

  Future _chargeFirstRun;
  Future chargeState(num id, [bool singleRun = false]) {
    //TODO: Issue if chargeFirstRun Errors?
    if ((_chargeStateCache.containsKey(id) || _chargeFirstRun != null) &&
        !singleRun) {
      return _chargeFirstRun.then((_) => new Future.value(_chargeStateCache[id])
          );
    }
    if (singleRun) {
      return _setChargeState(id, singleRun);
    }
    _chargeFirstRun = _setChargeState(id, singleRun);
    return _chargeFirstRun;
  }

  Future _setChargeState(num id, [bool singleRun = false]) {
    String url = "$_apiVehiclesUrl/$id/$_apiChargeStateUrl";
    return _http.get(url).then((HttpResponse response) {
      if (response.data is String) {
        throw ("Response Data Not JSON: $response.data");
      }
      _chargeStateCache[id] = new ChargeState.fromJsonMap(response.data);
      _chargeUpdateController.add(_chargeStateCache[id]);
      if (!singleRun) {
        int duration = 30000;
        if (!_chargeUpdated) {
          duration = 37500;
          _chargeUpdated = true;
        }
        new Future.delayed(new Duration(milliseconds: duration), () =>
            _setChargeState(id));
      }
      return _chargeStateCache[id];
    }, onError: (Object obj) {
      if (!singleRun) {
        new Future.delayed(new Duration(seconds: 10), () => _setChargeState(id)
            );
      }
    });
  }

  Future _climateFirstRun;
  Future climateState(num id, [bool singleRun = false]) {
    //TODO: Issue if chargeFirstRun Errors?
    if ((_climateStateCache.containsKey(id) || _climateFirstRun != null) &&
        !singleRun) {
      return _climateFirstRun.then((_) => new Future.value(
          _climateStateCache[id]));
    }
    if (singleRun) {
      return _setClimateState(id, singleRun);
    }
    _climateFirstRun = _setClimateState(id, singleRun);
    return _climateFirstRun;
  }

  Future _setClimateState(num id, [bool singleRun = false]) {
    String url = "$_apiVehiclesUrl/$id/$_apiClimateStateUrl";
    return _http.get(url).then((HttpResponse response) {
      if (response.data is String) {
        throw ("Response Data Not JSON: $response.data");
      }
      _climateStateCache[id] = new ClimateState.fromJsonMap(response.data);
      _climateUpdateController.add(_climateStateCache[id]);
      if (!singleRun) {
        int duration = 30;
        if (!_climateUpdated) {
          duration = 45;
          _climateUpdated = true;
        }
        new Future.delayed(new Duration(seconds: duration), () =>
            _setClimateState(id));
      }
      return _climateStateCache[id];
    }, onError: (Object obj) {
      if (!singleRun) {
        new Future.delayed(new Duration(seconds: 10), () => _setClimateState(id)
            );
      }
    });
  }

  Future _driveFirstRun;
  Future driveState(num id, [bool singleRun = false]) {
    //TODO: Issue if chargeFirstRun Errors?
    if ((_driveStateCache.containsKey(id) || _driveFirstRun != null) &&
        !singleRun) {
      return _driveFirstRun.then((_) => new Future.value(_driveStateCache[id]));
    }
    if (singleRun) {
      return _setDriveState(id, singleRun);
    }
    _driveFirstRun = _setDriveState(id, singleRun);
    return _driveFirstRun;
  }

  Future _setDriveState(num id, [bool singleRun = false]) {
    String url = "$_apiVehiclesUrl/$id/$_apiDriveStateUrl";
    return _http.get(url).then((HttpResponse response) {
      if (response.data is String) {
        throw ("Response Data Not JSON: $response.data");
      }
      _driveStateCache[id] = new DriveState.fromJsonMap(response.data);
      _driveUpdateController.add(_driveStateCache[id]);
      if (!singleRun) {
        int duration = 30000;
        if (!_driveUpdated) {
          duration = 52500;
          _driveUpdated = true;
        }
        new Future.delayed(new Duration(milliseconds: duration), () =>
            _setDriveState(id));
      }
      return _driveStateCache[id];
    }, onError: (Object obj) {
      if (!singleRun) {
        new Future.delayed(new Duration(seconds: 10), () => _setDriveState(id));
      }
    });
  }

  Future lockDoors(num id) {
    String url = "$_apiVehiclesUrl/$id/$_apiLockDoorUrl";
    return _simpleRequest(url);
  }

  Future unlockDoors(num id) {
    String url = "$_apiVehiclesUrl/$id/$_apiUnlockDoorUrl";
    return _simpleRequest(url);
  }

  Future honkHorn(num id) {
    String url = "$_apiVehiclesUrl/$id/$_apiHonkHornUrl";
    return _simpleRequest(url);
  }

  Future flashLights(num id) {
    String url = "$_apiVehiclesUrl/$id/$_apiFlashLightsUrl";
    return _simpleRequest(url);
  }

  Future setSunRoof(num id, String state) {
    String url = "$_apiVehiclesUrl/$id/$_apiSunRoofUrl$state";
    return _simpleRequest(url);
  }

  Future setChargeLimit(num id, num percent) {
    String url = "$_apiVehiclesUrl/$id/$_apiChargeLimitUrl$percent";
    return _simpleRequest(url);
  }

  Future openChargePort(num id) {
    String url = "$_apiVehiclesUrl/$id/$_apiOpenChargePortUrl";
    return _simpleRequest(url);
  }

  Future startCharging(num id) {
    String url = "$_apiVehiclesUrl/$id/$_apiStartChargingUrl";
    return _simpleRequest(url);
  }

  Future stopCharging(num id) {
    String url = "$_apiVehiclesUrl/$id/$_apiStopChargingUrl";
    return _simpleRequest(url);
  }

  Future setTemps(num id, num C) {
    String url =
        "$_apiVehiclesUrl/$id/$_apiSetTempsUrl?driver_temp=$C&passenger_temp=$C";
    return _simpleRequest(url);
  }

  Future startHVAC(num id) {
    String url = "$_apiVehiclesUrl/$id/$_apiStartHVACUrl";
    return _simpleRequest(url);
  }

  Future stopHVAC(num id) {
    String url = "$_apiVehiclesUrl/$id/$_apiStopHVACUrl";
    return _simpleRequest(url);
  }

  Future _simpleRequest(url) {
    return _http.get(url).then((HttpResponse response) {
      if (response.data is String) {
        throw ("Response Data Not JSON: $response.data");
      }
      if (response.data['result']) {
      } else {
        print(response.data['result']);
      }
    });
  }

  Future googleGeocode(num lat, num lng) {
    String _loc = "$lat,$lng";
    if (_geocacheCache.containsKey(_loc)) {
      return new Future.value(_geocacheCache[_loc]);
    }
    String url = "$_googleGeocode$lat,$lng&sensor=true";
    return _http.get(url).then((HttpResponse response) {
      if (response.data['results'].length > 1) {
        var address = response.data['results'][0];
        _geocacheCache[_loc] = address['formatted_address'].replaceFirst(', ',
            '\n');
        return _geocacheCache[_loc];
      }
      return "";
    });
  }

  Future<bool> isLoggedIn() {
    return _http.get(_apiVehiclesUrl).then((HttpResponse response) {
      if (response.data is String) {
        return false;
      }
      for (Map vehicles in response.data) {
        return true;
      }
      return false;
    });
  }
}
