import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'index.dart';

var logger = Logger();

var loggerNoStack = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // number of method calls to be displayed
    errorMethodCount: 8, // number of method calls if stacktrace is provided
    lineLength: 120, // width of the output
    colors: true, // Colorful log messages
    printEmojis: false, // Print an emoji for each log message
  ),
);

void main() async {
  var logger = Logger();

  logger.d("Logger is working!");
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  await SetLocalizations.initialize();

  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (context) {
        AppStateNotifier appStateNotifier = AppStateNotifier.instance;
        return appStateNotifier;
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = Locale('en');
  ThemeMode _themeMode = ThemeMode.system;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;

    _router = createRouter(_appStateNotifier);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));

    // _appStateNotifier.loadSaveUserData().then((isSuccess) async {
    //   if (isSuccess) {
    //     _appStateNotifier.apicall();
    //   } else {
    //     print('Omit data call');
    //   }
    // });

    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      setState(() => _adapterState = state);
      if (_adapterState != BluetoothAdapterState.on) {
        //FlutterBluePlus.turnOn();
      }
    });
    // Future.delayed(Duration(milliseconds: 500), () {
    //   _appStateNotifier.stopShowingSplashImage();
    // });
  }

  @override
  void dispose() {
    _adapterStateSubscription.cancel();
    super.dispose();
  }

  void setLocale(String language) {
    setState(() {
      _locale = createLocale(language);
    });
    SetLocalizations.storeLocale(language);
  }

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fisica',
      localizationsDelegates: [
        SetLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [Locale('ko'), Locale('en'), Locale('ja')],
      theme: ThemeData(
        fontFamily: "Pretendard",
        brightness: Brightness.light,
        scrollbarTheme: ScrollbarThemeData(),
      ),
      themeMode: _themeMode,
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
    );
  }
}
