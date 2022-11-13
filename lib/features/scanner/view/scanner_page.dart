import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kuleta/features/scanner/scanner.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  void initState() {
    final event = ResetScannedValue();
    BlocProvider.of<ScannerBloc>(context).add(event);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const ScannerView();
  }
}

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  late MobileScannerController _controller;

  @override
  void initState() {
    _controller = MobileScannerController(torchEnabled: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScannerBloc, ScannerState>(
      listenWhen: (previous, current) =>
          previous.scannerStatus != current.scannerStatus ||
          previous.fetchingInvoiceStatus != current.fetchingInvoiceStatus,
      listener: (context, state) {
        final status = state.fetchingInvoiceStatus;
        if (status == FetchingInvoiceStatus.success) {
          final invoice = state.fetchedInvoice;
          context.go('/detail?iscreating=true', extra: invoice);
        }
      },
      builder: (context, state) {
        final isScanning = state.scannerStatus == ScannerStatus.initial;
        final progressIndicatorColor = Theme.of(context).colorScheme.background;

        // WIP: To avoid scanning manually. Should not be committed. @Jeton
        // final shouldSend = state.scannerStatus != ScannerStatus.success;
        // if (shouldSend) {
        //   const event = ValueScanned(
        //     'https://efiskalizimi-app.tatime.gov.al/invoice-check/#/verify?iic=4B6986C4151354F7B48E6B61050BD14C&tin=J61804031V&crtd=2022-06-18T11:32:48+02:00&ord=36911&bu=wj784it543&cr=bi956te417&sw=sc782sw243&prc=204.11',
        //   );
        //   context.watch<ScannerBloc>().add(event);
        // }

        return Scaffold(
          body: Stack(
            children: [
              MobileScanner(
                controller: _controller,
                allowDuplicates: isScanning,
                onDetect: (barcode, arguments) {
                  var code = barcode.rawValue;
                  final format = barcode.format;
                  if (code != null && format == BarcodeFormat.qrCode) {
                    // ignore: hack
                    // HACK: when parsing the value, `+` is parsed to `%2B`
                    if (code.contains('%2B') || code.contains('%20')) {
                      code = code.replaceAll('%2B', '+');
                    }

                    final event = ValueScanned(code);
                    BlocProvider.of<ScannerBloc>(context).add(event);
                  }
                },
              ),
              Positioned(
                right: 0,
                left: 0,
                bottom: 56,
                child: FlashButton(controller: _controller),
              ),
              if (isScanning) ...[
                ScannerIndicator(visible: isScanning),
              ] else ...[
                Center(
                  child: Transform.scale(
                    scale: 2,
                    child: CircularProgressIndicator(
                      color: progressIndicatorColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
