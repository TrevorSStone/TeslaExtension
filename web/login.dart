library tesla_login;
import 'package:angular/angular.dart';
import 'package:tesla_extension/service/tesla_service.dart';
import 'package:tesla_extension/tesla_login.dart';
import 'package:tesla_extension/component/tesla_login_component.dart';
import 'package:angular/application_factory.dart';

class LoginModule extends Module {
  LoginModule() {
    type(TeslaLoginController);
    type(TeslaService);
    type(TeslaLoginComponent);
  }
}

main() {
  applicationFactory()
    .addModule(new LoginModule())
    .run();
}
