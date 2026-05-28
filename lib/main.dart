import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home_screen.dart';
import 'screens/grupos_screen.dart';
import 'screens/cuadro_screen.dart';
import 'screens/historico_screen.dart';
import 'screens/selecciones_screen.dart';
import 'screens/sedes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const Mundial2026App());
}

const kRojo   = Color(0xFFD0021B);
const kAzul   = Color(0xFF00205B);
const kDorado = Color(0xFFC9A84C);
const kBlanco = Color(0xFFFFFFFF);

const kFondo        = Color(0xFFD6DCE8);  // Gris azulado intermedio
const kFondoCard    = Color(0xFFFFFFFF);
const kFondoAppBar  = Color(0xFF00205B);
const kTexto        = Color(0xFF0D1527);
const kTextoSecund  = Color(0xFF3A4560);
const kTextoMuted   = Color(0xFF6B7A99);

class Mundial2026App extends StatelessWidget {
  const Mundial2026App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mundial 2026',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      locale: const Locale('es', 'ES'),
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: kAzul,
          secondary: kDorado,
          tertiary: kRojo,
          surface: kFondoCard,
          onPrimary: kBlanco,
          onSecondary: kAzul,
          primaryContainer: kAzul,
          onPrimaryContainer: kBlanco,
          surfaceContainerHighest: const Color(0xFFC8D0E0),
          onSurface: kTexto,
          onSurfaceVariant: kTextoSecund,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: kFondo,
        appBarTheme: const AppBarTheme(
          backgroundColor: kFondoAppBar,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: kFondoAppBar,
          indicatorColor: kRojo,
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Colors.white, fontSize: 10),
          ),
          iconTheme: WidgetStateProperty.all(
            const IconThemeData(color: Colors.white),
          ),
        ),
        cardTheme: CardThemeData(
          color: kFondoCard,
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: kRojo,
        ),
        expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: kFondoCard,
          collapsedBackgroundColor: kFondoCard,
          iconColor: kAzul,
          collapsedIconColor: kAzul,
          textColor: kTexto,
          collapsedTextColor: kTexto,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: kTexto),
          bodyMedium: TextStyle(color: kTexto),
          bodySmall: TextStyle(color: kTextoSecund),
          titleLarge: TextStyle(color: kTexto, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: kTexto, fontWeight: FontWeight.w600),
        ),
        dividerTheme: const DividerThemeData(color: Color(0xFFC8D0E0)),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kFondoCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFC8D0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFC8D0E0)),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    GruposScreen(),
    CuadroScreen(),
    HistoricoScreen(),
    SeleccionesScreen(),
    SedesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.sports_soccer), label: 'Partidos'),
          NavigationDestination(icon: Icon(Icons.table_chart), label: 'Grupos'),
          NavigationDestination(icon: Icon(Icons.emoji_events), label: 'Cuadro'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Histórico'),
          NavigationDestination(icon: Icon(Icons.flag), label: 'Selecciones'),
          NavigationDestination(icon: Icon(Icons.stadium), label: 'Sedes'),
        ],
      ),
    );
  }
}
