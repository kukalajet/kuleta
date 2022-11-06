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

  Future<void> storeInvoice(Invoice invoice) async {
    return isar.writeTxn(() async {
      await isar.invoices.put(invoice);
      await isar.sellers.put(invoice.seller.value!);
      await invoice.seller.save();
    });
  }
}
