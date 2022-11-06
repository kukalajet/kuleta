// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_repository/invoice_repository.dart';
import 'package:kuleta/features/app/app.dart';
import 'package:kuleta/features/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      final invoiceRepository = InvoiceRepository();
      await invoiceRepository.init();
      await tester.pumpWidget(App(invoiceRepository: invoiceRepository));
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
