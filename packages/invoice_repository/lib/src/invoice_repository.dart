import 'package:dio/dio.dart';
import 'package:invoice_repository/src/models/invoice.dart';

const _baseUrl = 'https://efiskalizimi-app.tatime.gov.al';

class InvoiceRepository {
  late Dio dio;

  InvoiceRepository() {
    final contentType = Headers.formUrlEncodedContentType;
    final options = BaseOptions(baseUrl: _baseUrl, contentType: contentType);
    dio = Dio(options);
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
}
