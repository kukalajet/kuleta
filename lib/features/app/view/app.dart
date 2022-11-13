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

class App extends StatelessWidget {
  const App({super.key, required InvoiceRepository invoiceRepository})
      : _invoiceRepository = invoiceRepository;

  final InvoiceRepository _invoiceRepository;

  @override
  Widget build(BuildContext context) {
    final invoiceBloc = InvoiceBloc(invoiceRepository: _invoiceRepository)
      ..add(InvoicesFetched());
    final scannerBloc = ScannerBloc(invoiceRepository: _invoiceRepository);
    final detailBloc = DetailBloc(invoiceRepository: _invoiceRepository);

    final providers = <BlocProvider>[
      BlocProvider<InvoiceBloc>(create: (context) => invoiceBloc),
      BlocProvider<ScannerBloc>(create: (context) => scannerBloc),
      BlocProvider<DetailBloc>(create: (context) => detailBloc),
    ];

    return MultiBlocProvider(providers: providers, child: View());
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
          usedColors: 1,
          surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
          blendLevel: 30,
          appBarOpacity: 0.95,
          swapColors: true,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 30,
            defaultRadius: 16,
            dialogBackgroundSchemeColor: SchemeColor.onSecondaryContainer,
            dialogRadius: 50,
            timePickerDialogRadius: 50,
          ),
          useMaterial3ErrorColors: true,
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          fontFamily: GoogleFonts.arvo().fontFamily,
          // To use the playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.amber,
          usedColors: 1,
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 15,
          appBarOpacity: 0.90,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 30,
            defaultRadius: 16,
            dialogBackgroundSchemeColor: SchemeColor.onSecondaryContainer,
            dialogRadius: 50,
            timePickerDialogRadius: 50,
          ),
          useMaterial3ErrorColors: true,
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          fontFamily: GoogleFonts.arvo().fontFamily,
          // To use the playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        // If you do not have a themeMode switch, uncomment this line
        // to let the device system mode control the theme mode:
        // themeMode: ThemeMode.system,
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
