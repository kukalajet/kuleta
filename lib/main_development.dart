// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:invoice_repository/invoice_repository.dart';
import 'package:kuleta/bootstrap.dart';
import 'package:kuleta/features/app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final invoiceRepository = InvoiceRepository();
  await invoiceRepository.init();

  // final invoiceFromService1 = await invoiceRepository.getInvoiceFromService(
  //   iic: 'B2612C45EFFD711F8640739BA9ABCC94',
  //   dateTimeCreated: '2022-06-05T11:15:02 02:00',
  //   tin: 'K92201080V',
  // );
  // final invoiceFromService2 = await invoiceRepository.getInvoiceFromService(
  //   iic: 'E469949D81F26446F0AC5C8A75CAB288',
  //   dateTimeCreated: '2022-06-05T10:24:24 02:00',
  //   tin: 'M12409049N',
  // );
  // final invoiceFromService3 = await invoiceRepository.getInvoiceFromService(
  //   iic: 'C748E0A537991D2B1DDE0758A4588099',
  //   dateTimeCreated: '2022-03-19T21:13:13 01:00',
  //   tin: 'L82002010R',
  // );
  // final invoiceFromService4 = await invoiceRepository.getInvoiceFromService(
  //   iic: 'A98A8E0A1BBACFE4D6C37669513D1597',
  //   dateTimeCreated: '2022-04-05T10:42:15 02:00',
  //   tin: 'L92103036T',
  // );

  // final firstConadInvoice = await invoiceRepository.getInvoiceFromService(
  //   iic: '68A837DECBDF5FB5249631A040BA9EE3',
  //   dateTimeCreated: '2022-11-04T15:28:39 01:00',
  //   tin: 'K61704029H',
  // );
  // final secondConadInvoice = await invoiceRepository.getInvoiceFromService(
  //   iic: 'E5CDA1CFF3AB556C0A8D9E38C368E803',
  //   dateTimeCreated: '2022-11-03T12:34:01 01:00',
  //   tin: 'K61704029H',
  // );

  // await invoiceRepository.storeInvoice(invoiceFromService1!);
  // await invoiceRepository.storeInvoice(invoiceFromService2!);
  // await invoiceRepository.storeInvoice(invoiceFromService3!);
  // await invoiceRepository.storeInvoice(invoiceFromService4!);
  // await invoiceRepository.storeInvoice(firstConadInvoice!);
  // await invoiceRepository.storeInvoice(secondConadInvoice!);

  // print(invoiceFromService1);
  // print(invoiceFromService2);
  // print(invoiceFromService3);
  // print(invoiceFromService4);

  final sharedPreferences = await SharedPreferences.getInstance();

  await bootstrap(
    () => App(
      invoiceRepository: invoiceRepository,
      sharedPreferences: sharedPreferences,
    ),
  );
}
