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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final invoiceRepository = InvoiceRepository();
  await invoiceRepository.init();

  await bootstrap(() => App(invoiceRepository: invoiceRepository));
}
