library tesla_routing;

import 'package:angular/angular.dart';

void teslaRouteInitializer(Router router, RouteViewFactory views){
    views.configure({
    'home': ngRoute(path: '/home', view: 'view/home.html', defaultRoute: true),
    'controls': ngRoute(path: '/controls', view: 'view/controls.html'),
    'charge': ngRoute(path: '/charge', view: 'view/charge.html'),
    'climate': ngRoute(path: '/climate', view: 'view/climate.html'),
    'location': ngRoute(path: '/location', view: 'view/location.html')
  });
}
