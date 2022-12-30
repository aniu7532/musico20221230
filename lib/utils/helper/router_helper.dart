import 'package:musico/app/myapp.dart';
import 'package:auto_route/auto_route.dart';

class AppRouterHelper {
  static Future<dynamic> replace({
    bool needPop = false,
    required PageRouteInfo route,
  }) async {
    if (needPop) {
      final result = await appRouter.replace(route);
      return result;
    } else {
      final result = await appRouter.push(route);
      return result;
    }
  }
}
