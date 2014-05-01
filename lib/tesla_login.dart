library tesla_login_controller;

import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:tesla_extension/service/tesla_service.dart';
@Controller(selector: '[tesla-login]', publishAs: 'ctrl')
class TeslaLoginController {

  Http _http;
  TeslaService _teslaService;
  TeslaService get teslaService => _teslaService;
  bool showLogin = false;
  bool hideLogo = false;
  TeslaLoginController(Http this._http, TeslaService this._teslaService) {
    Future.wait([_teslaService.isLoggedIn()]).then((List responses) {
      if (responses[0]) {
        window.location.replace('main.html');
      } else {
        showLogin = true;
        sleep2().then((_) => hideLogo = true);
      }
    }, onError: (Object obj) {
      print(obj);
    });
  }

  Future sleep() {
    return new Future.delayed(const Duration(milliseconds: 500), () => ".5");
  }
  Future sleep2() {
    return new Future.delayed(const Duration(seconds: 1), () => "1");
  }

  String logoClass() {
    return showLogin ? "fade" : "";
  }
}
