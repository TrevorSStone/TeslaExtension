library gui_settings;

class GUI_Settings {
  String distanceUnits;
  String temperatureUnits;
  String chargeUnits;
  bool is24HourTime;
  String rangeDisplay;

  GUI_Settings(this.distanceUnits, this.temperatureUnits, this.chargeUnits, this.is24HourTime, this.rangeDisplay);

  factory GUI_Settings.fromJsonMap(Map json) {
    return new GUI_Settings(json['gui_distance_units'],
        json['gui_temperature_units'], json['gui_charge_rate_units'],
        json['gui_24_hour_time'], json['gui_range_display']);
  }

}
