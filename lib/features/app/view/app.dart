// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invoice_repository/invoice_repository.dart';
import 'package:kuleta/features/app/view/app_tabs_page.dart';
import 'package:kuleta/features/app/view/nav_handler.dart';
import 'package:kuleta/features/detail/bloc/bloc.dart';
import 'package:kuleta/features/detail/view/view.dart';
import 'package:kuleta/features/invoice/bloc/invoice_bloc.dart';
import 'package:kuleta/features/scanner/scanner.dart';
import 'package:kuleta/l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({
    required InvoiceRepository invoiceRepository,
    required SharedPreferences sharedPreferences,
    super.key,
  })  : _invoiceRepository = invoiceRepository,
        _sharedPreferences = sharedPreferences;

  final InvoiceRepository _invoiceRepository;
  final SharedPreferences _sharedPreferences;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final List<BlocProvider> _providers;

  @override
  void initState() {
    super.initState();

    final invoiceBloc = InvoiceBloc(
      invoiceRepository: widget._invoiceRepository,
      sharedPreferences: widget._sharedPreferences,
    )
      ..add(InvoicesFetched())
      ..add(TotalAmountSpentLastMonthFetched())
      ..add(TotalAmountSpentLastWeekFetched())
      ..add(ShouldBeOnboardedFetched());
    final scannerBloc =
        ScannerBloc(invoiceRepository: widget._invoiceRepository);
    final detailBloc = DetailBloc(invoiceRepository: widget._invoiceRepository);

    _providers = <BlocProvider>[
      BlocProvider<InvoiceBloc>(create: (context) => invoiceBloc),
      BlocProvider<ScannerBloc>(create: (context) => scannerBloc),
      BlocProvider<DetailBloc>(create: (context) => detailBloc),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: _providers, child: View());
  }
}

class View extends StatelessWidget {
  View({super.key});

  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const AppTabsPage(),
        ),
        routes: [
          GoRoute(
            path: 'scanner',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const ScannerPage(),
            ),
          ),
          GoRoute(
            path: 'detail',
            pageBuilder: (context, state) {
              final isBeingCreated = state.queryParams['iscreating'] == 'true';
              final invoice = state.extra! as Invoice;
              return MaterialPage(
                key: state.pageKey,
                child: DetailPage(
                  invoice: invoice,
                  isBeingCreated: isBeingCreated,
                ),
              );
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavHandler>(
      create: (_) => NavHandler(_router),
      child: MaterialApp.router(
        theme: FlexThemeData.light(
          scheme: FlexScheme.amber,
          usedColors: 2,
          surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
          blendLevel: 20,
          appBarOpacity: 0.95,
          swapColors: true,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 20,
          ),
          keyColors: const FlexKeyColors(
            useSecondary: true,
            keepSecondary: true,
            keepSecondaryContainer: true,
          ),
          tones: FlexTones.highContrast(Brightness.light),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          fontFamily: GoogleFonts.arvo().fontFamily,
        ),
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.amber,
          usedColors: 2,
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 15,
          appBarStyle: FlexAppBarStyle.background,
          appBarOpacity: 0.90,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 30,
          ),
          keyColors: const FlexKeyColors(
            useSecondary: true,
          ),
          tones: FlexTones.highContrast(Brightness.dark),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          fontFamily: GoogleFonts.arvo().fontFamily,
        ),
        themeMode: ThemeMode.light,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        routeInformationProvider: _router.routeInformationProvider,
      ),
    );
  }
}
