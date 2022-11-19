import 'package:dio/dio.dart';
import 'package:invoice_repository/invoice_repository.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

const _baseUrl = 'https://efiskalizimi-app.tatime.gov.al';

class InvoiceRepository {
  late Dio dio;
  late Isar isar;

  InvoiceRepository() {
    final contentType = Headers.formUrlEncodedContentType;
    final options = BaseOptions(baseUrl: _baseUrl, contentType: contentType);
    dio = Dio(options);
  }

  Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    isar = await Isar.open(
      [InvoiceSchema, SellerSchema],
      directory: dir.path,
      inspector: true,
    );
  }

  Future<List<GroupedByDateInvoices>> getGroupedByDateInvoices({
    int startIndex = 0,
    int limit = 20,
  }) async {
    final sorted = await isar.invoices
        .where()
        .sortByDateTimeCreatedDesc()
        .offset(startIndex)
        .limit(limit)
        .findAll();

    final invoices = sorted.fold<List<GroupedByDateInvoices>>(
      <GroupedByDateInvoices>[],
      (previous, item) {
        final dateTime = item.dateTimeCreated;
        final index =
            previous.indexWhere((item) => dateTime!.isSameDate(item.dateTime));

        if (index == -1) {
          final invoices = [item];
          final data = GroupedByDateInvoices(
            dateTime: dateTime!,
            invoices: invoices,
          );

          previous.add(data);
          return previous;
        }

        final current = previous[index];
        current.invoices.add(item);
        previous[index] = current;

        return previous;
      },
    )..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return invoices;
  }

  Future<Invoice?> getInvoiceFromService({
    required String iic,
    required String dateTimeCreated,
    required String tin,
  }) async {
    final body = {'iic': iic, 'dateTimeCreated': dateTimeCreated, 'tin': tin};
    final response =
        await dio.post('/invoice-check/api/verifyInvoice', data: body);
    final data = response.data as Map<String, dynamic>;
    final invoice = Invoice.fromJson(data, iic, tin);

    return invoice;
  }

  Future<bool> storeInvoice(Invoice invoice) async {
    try {
      await isar.writeTxn(() async {
        await isar.invoices.put(invoice);
        await isar.sellers.put(invoice.seller.value!);
        await invoice.seller.save();
      });

      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> removeStoredInvoice(int id) async {
    try {
      await isar.writeTxn(() => isar.invoices.delete(id));
      return true;
    } on Exception {
      return false;
    }
  }

  Future<double> getTotalAmountSpentLastWeek() async {
    return _getTotalAmountSpent(since: Duration(days: 7));
  }

  Future<double> getTotalAmountSpentLastMonth() async {
    return _getTotalAmountSpent(since: Duration(days: 30));
  }

  Future<double> _getTotalAmountSpent({Duration? since}) async {
    final invoices = await isar.invoices.filter().optional(
      since != null,
      (q) {
        final now = DateTime.now();
        final start = now.subtract(since ?? Duration.zero);
        return q.dateTimeCreatedGreaterThan(start);
      },
    ).findAll();

    final amountSpent = invoices.fold<double>(0.0, (previousTotalAmount, item) {
      final totalPrice = item.totalPrice;
      final value = previousTotalAmount + (totalPrice ?? 0.0);
      return value;
    });

    return amountSpent;
  }
}

extension DateTimeX on DateTime {
  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
