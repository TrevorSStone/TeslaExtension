library charge_state;

class ChargeState{
	String chargingState;
	num chargeLimitSoc;
	num chargeLimitSocStd;
	num chargeLimitSocMin;
	num chargeLimitSocMax;
	bool chargeToMaxRage;
	bool batteryHeaterOn;
	bool notEnoughPowerToHeat;
	num maxRangeChargeCounter;
	bool fastChargerPresent;
	num batteryRange;
	num estBatteryrange;
	num idealBatteryRange;
	num batteryLevel;
	num batteryCurrent;
	num chargeEnergyAdded;
	num chargeMilesAddedRates;
	num chargeMilesAddedIdeal;
	num chargerVoltage;
	num chargerPilotCurrent;
	num chargerActualCurrent;
	num chargerPower;
	num timeToFullCharge;
	num chargeRate;
	bool chargePortDoorOpen;
	num scheduledChargingStartTime;
	bool scheduledChargingPending;
	bool userChargeEnableRequest;
	bool chargeEnableRequest;
	bool euVehicle;
	String chargerPhases;

	ChargeState(this.chargingState, this.chargeLimitSoc, this.chargeLimitSocStd, this.chargeLimitSocMin,
		this.chargeLimitSocMax, this.chargeToMaxRage, this.batteryHeaterOn, this.notEnoughPowerToHeat,
		this.maxRangeChargeCounter, this.fastChargerPresent, this.batteryRange, this.estBatteryrange,
		this.idealBatteryRange, this.batteryLevel, this.batteryCurrent, this.chargeEnergyAdded,
		this.chargeMilesAddedRates, this.chargeMilesAddedIdeal, this.chargerVoltage,
		this.chargerPilotCurrent, this.chargerActualCurrent, this.chargerPower, this.timeToFullCharge,
		this.chargeRate, this.chargePortDoorOpen, this.scheduledChargingStartTime,
		this.scheduledChargingPending, this.userChargeEnableRequest, this.chargeEnableRequest,
		this.euVehicle, this.chargerPhases);
	
	factory ChargeState.fromJsonMap(Map json){
		return new ChargeState(json["charging_state"], json["charge_limit_soc"], 
			json["charge_limit_soc_std"], json["charge_limit_soc_min"], 
			json["charge_limit_soc_max"], json["charge_to_max_range"], json["battery_heater_on"], 
			json["not_enough_power_to_heat"], json["max_range_charge_counter"], 
			json["fast_charger_present"], json["battery_range"], json["est_battery_range"], 
			json["ideal_battery_range"], json["battery_level"], json["battery_current"], 
			json["charge_energy_added"], json["charge_miles_added_rated"], 
			json["charge_miles_added_ideal"], json["charger_voltage"], 
			json["charger_pilot_current"], json["charger_actual_current"], 
			json["charger_power"], json["time_to_full_charge"], json["charge_rate"], 
			json["charge_port_door_open"], json["scheduled_charging_start_time"], 
			json["scheduled_charging_pending"], json["user_charge_enable_request"], 
			json["charge_enable_request"], json["eu_vehicle"], json["charger_phases"]);
	}
}