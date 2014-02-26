library tesla_nav_component;

import 'package:angular/angular.dart';

@NgComponent(selector: 'tesla-nav', templateUrl:
    'packages/tesla_extension/component/tesla_nav_component.html', cssUrl:
    'packages/tesla_extension/component/tesla_nav_component.css', publishAs: 'ctrl')
class TeslaNavComponent {
  List<String> buttons = ["home", "controls", "charge", "climate", "location"];
  String selected = "home";


  void handleClick(String b) {
    selected = b;
  }

  String navClass(String b) {
    if (selected == b) {
      return "$b selected";
    }
    return b;
  }
}

