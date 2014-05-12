library tesla_login_controller;

import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:tesla_extension/service/tesla_service.dart';
@Controller(selector: '[tesla-login]', publishAs: 'login')
class TeslaLoginController {

  Http _http;
  TeslaService _teslaService;
  TeslaService get teslaService => _teslaService;
  bool showLogin = false;
  bool hideLogo = false;
  bool vanish = false;
  TeslaLoginController(Http this._http, TeslaService this._teslaService) {
    _teslaService.loginUpdate.listen((bool m) {
        vanish = true;
      });
        _teslaService.logoutUpdate.listen((bool m) {
        vanish = false;
      });
    Future.wait([_teslaService.isLoggedIn(), sleep()]).then((List responses) {
      if (responses[0]) {
        _teslaService.sendLoginMessage();
      } else {
        showLogin = true;
        sleep().then((_) => hideLogo = true);
      }
    }, onError: (Object obj) {
      print(obj);
    });
  }

  Future sleep() {
    return new Future.delayed(const Duration(milliseconds: 1300), () => "1.3");
  }
  Future sleep2() {
    return new Future.delayed(const Duration(seconds: 100), () => "1");
  }

  String logoClass() {
    return showLogin ? "fade" : "";
  }
  bool showLogo() {
    return !hideLogo;
  }
  bool showAll(){
    return !vanish;
  }
}
