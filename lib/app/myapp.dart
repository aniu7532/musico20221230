import 'package:musico/gen/colors.gen.dart';
import 'package:musico/generated/l10n.dart';
import 'package:musico/router/router.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final appRouter = AppRouter();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primaryColor: ColorName.themeColor,
        scaffoldBackgroundColor: ColorName.bgColor,
        backgroundColor: ColorName.bgColor,
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(secondary: ColorName.secondaryColor.withOpacity(0.4)),
        textTheme: const TextTheme(
          titleSmall: TextStyle(color: Colors.white, fontSize: 18),
        ),
        appBarTheme: const AppBarTheme(color: ColorName.themeColor),
      ),
      debugShowCheckedModeBanner: dotenv.get('IS_PRODUCTION') == '0',
      routeInformationParser: appRouter.defaultRouteParser(),
      routeInformationProvider: appRouter.routeInfoProvider(),
      routerDelegate: AutoRouterDelegate(
        appRouter,
        navigatorObservers: () => [AppRouteObserver()],
      ),
      builder: MyToast.init(
        builder: (context, child) {
          return child!;
        },
      ),
      //默认显示英文
      locale: const Locale('en'),
      localizationsDelegates: const [
        RefreshLocalizations.delegate,
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        //print("change language");
        return locale;
      },
    );
  }
}
