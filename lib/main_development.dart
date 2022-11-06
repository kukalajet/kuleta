// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:invoice_repository/invoice_repository.dart';
import 'package:kuleta/app/app.dart';
import 'package:kuleta/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final invoiceRepository = InvoiceRepository();
  await invoiceRepository.init();

  final invoiceFromService1 = await invoiceRepository.getInvoiceFromService(
    iic: 'B2612C45EFFD711F8640739BA9ABCC94',
    dateTimeCreated: '2022-06-05T11:15:02 02:00',
    tin: 'K92201080V',
  );
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

  await invoiceRepository.storeInvoice(invoiceFromService1!);

  print(invoiceFromService1);
  // print(invoiceFromService2);
  // print(invoiceFromService3);
  // print(invoiceFromService4);

  await bootstrap(() => const App());
}
