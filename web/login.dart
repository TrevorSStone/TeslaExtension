library tesla_login;
@MirrorsUsed(
	targets: const ['tesla_service'],
    override: '*'
)
import 'dart:mirrors';

import 'package:angular/angular.dart';
import 'package:tesla_extension/service/tesla_service.dart';
import 'package:tesla_extension/tesla_login.dart';
import 'package:tesla_extension/component/tesla_login_component.dart';
class LoginModule extends Module {
  LoginModule() {
    type(TeslaLoginController);
    type(TeslaService);
    type(TeslaLoginComponent);
  }
}

main() {
  ngBootstrap(module: new LoginModule());
}
