library tesla_main;
@MirrorsUsed(targets: const ['tesla_service', 'charge_state', 'climate_state',
    'drive_state', 'vehicle_state', 'vehicles', 'gui_settings', 'tesla_routing'],
    override: '*')
import 'dart:mirrors';

import 'package:angular/angular.dart';
import 'package:tesla_extension/service/tesla_service.dart';
import 'package:tesla_extension/tesla.dart';
import 'package:tesla_extension/routing/tesla_router.dart';
import 'package:tesla_extension/component/tesla_nav_component.dart';
import 'package:tesla_extension/component/tesla_car_component.dart';
import 'package:tesla_extension/component/tesla_battery_component.dart';
import 'package:tesla_extension/component/tesla_climate_component.dart';
import 'package:tesla_extension/component/tesla_map_component.dart';
import 'package:tesla_extension/component/tesla_charge_controls.dart';
import 'package:tesla_extension/component/tesla_charge_rate.dart';


class TeslaModule extends Module {
  TeslaModule() {
    type(TeslaController);
    type(TeslaNavComponent);
    type(TeslaCarComponent);
    type(TeslaBatteryComponent);
    type(TeslaClimateComponent);
    type(TeslaMapComponent);
    type(TeslaService);
    type(TeslaChargeControls);
    type(TeslaChargeRate);
    value(RouteInitializerFn, teslaRouteInitializer);
    factory(NgRoutingUsePushState, (_) => new NgRoutingUsePushState.value(false)
        );
  }
}

main() {
  ngBootstrap(module: new TeslaModule());
}
