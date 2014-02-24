library tesla_login_component;

import 'dart:async';
import 'dart:html';
import '../service/tesla_service.dart';
import 'package:angular/angular.dart';

@NgComponent(
    selector: 'tesla-login-form',
    templateUrl: 'packages/tesla_extension/component/tesla_login_component.html',
    cssUrl: 'packages/tesla_extension/component/tesla_login_component.css',
    publishAs: 'ctrl',
    map: const {
      'email': '=>email',
      'password' : '=>password'
    }
)
class TeslaLoginComponent {
	String email;
	String password;
	Http _http;
	TeslaService _teslaService;
	TeslaService get teslaService => _teslaService;
	bool loginFailed = false;
	TeslaLoginComponent(Http this._http, TeslaService this._teslaService){
	}

	void checkKey(e){
		loginFailed = false;
		if(e.keyCode == KeyCode.ENTER){
			_login();
		}
	}

	void _login(){
		_teslaService.postLogin(email, password).then((HttpResponse response){
			_teslaService.isLoggedIn().then((bool loggedin){
				if (loggedin){
					window.location.replace('main.html');
				}else{
					loginFailed = true;
				}
			});
			});
	}
}

