library climate_state;

class ClimateState {
  num insideTemp;
  num outsideTemp;
  num driverTempSet;
  num passengerTempSet;
  bool autoConditioningOn;
  num frontDefroster;
  bool rearDefroster;
  num fanStatus;

  ClimateState(this.insideTemp, this.outsideTemp, this.driverTempSet, this.passengerTempSet, this.autoConditioningOn, this.frontDefroster, this.rearDefroster, this.fanStatus);

  factory ClimateState.fromJsonMap(Map json) {
    return new ClimateState(json["inside_temp"], json["outside_temp"],
        json["driver_temp_setting"], json["passenger_temp_setting"],
        json["is_auto_conditioning_on"], json["is_front_defroster_on"],
        json["is_rear_defroster_on"], json["fan_status"]);
  }
}
