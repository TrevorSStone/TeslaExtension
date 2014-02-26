library vehicles;

class Vehicle {
  String color;
  String display_name;
  num id;
  String option_codes;
  num user_id;
  num vehicle_id;
  String vin;
  List<String> tokens;
  String state;

  Vehicle(this.color, this.display_name, this.id, this.option_codes, this.user_id, this.vehicle_id, this.vin, this.tokens, this.state);

  factory Vehicle.fromJsonMap(Map json) {
    return new Vehicle(json['color'], json['display_name'], json['id'],
        json['option_codes'], json['user_id'], json['vehicle_id'], json['vin'],
        json['tokens'], json['state']);
  }

  String vinSix() {
    return vin.substring(vin.length - 6);
  }
}
