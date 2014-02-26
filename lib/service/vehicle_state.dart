library vehicle_state;

class VehicleState {
  num driverFrontOpen;
  num driverRearOpen;
  num passFrontOpen;
  num passRearOpen;
  num frunkOpen;
  num trunkOpen;
  String carVersion;
  bool isLocked;
  bool hasSunRoof;
  String sunRoofState;
  num sunRoofPercent;
  bool darkRims;
  String wheelType;
  bool hasSpoiler;
  String roofColor;
  String perfConfig;
  String exteriorColor;

  VehicleState(this.driverFrontOpen, this.driverRearOpen, this.passFrontOpen, this.passRearOpen, this.frunkOpen, this.trunkOpen, this.carVersion, this.isLocked, this.hasSunRoof, this.sunRoofState, this.sunRoofPercent, this.darkRims, this.wheelType, this.hasSpoiler, this.roofColor, this.perfConfig, this.exteriorColor);

  factory VehicleState.fromJsonMap(Map json) {
    return new VehicleState(json['df'], json['dr'], json['pf'], json['pr'],
        json['ft'], json['rt'], json['car_version'], json['locked'],
        json['sun_roof_installed'], json['sun_roof_state'],
        json['sun_roof_percent_open'], json['dark_rims'], json['wheel_type'],
        json['has_spoiler'], json['roof_color'], json['perf_config'],
        json['exterior_color']);
  }
}
