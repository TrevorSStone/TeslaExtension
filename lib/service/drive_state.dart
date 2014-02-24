library drive_state;

class DriveState{
	String shiftState;
	num speed;
	num latitude;
	num longitude;
	num heading;
	num gpsTime;

	DriveState(this.shiftState, this.speed, this.latitude, this.longitude, 
		this.heading, this.gpsTime);

  factory DriveState.fromJsonMap(Map json) {
    return new DriveState(json["shift_state"], json["speed"], json["latitude"], 
      json["longitude"], json["heading"], json["gps_as_of"]);
  }
}
