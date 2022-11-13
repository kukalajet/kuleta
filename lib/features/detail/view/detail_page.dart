import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_repository/invoice_repository.dart';
import 'package:kuleta/features/detail/bloc/bloc.dart';
import 'package:kuleta/features/invoice/bloc/bloc.dart';
import 'package:kuleta/ui/ui.dart';
import 'package:kuleta/utils/utils.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    required this.invoice,
    required this.isBeingCreated,
    super.key,
  });

  final Invoice invoice;
  final bool? isBeingCreated;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late InvoiceBloc _invoiceBloc;

  @override
  void initState() {
    _invoiceBloc = BlocProvider.of<InvoiceBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    // final totalExpenseLastWeekFetchedEvent = TotalExpenseLastWeekFetched();
    // final totalExpenseLastMonthFetched = TotalExpenseLastMonthFetched();
    // _invoiceBloc
    //   ..add(totalExpenseLastWeekFetchedEvent)
    //   ..add(totalExpenseLastMonthFetched);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetailView(
      invoice: widget.invoice,
      isBeingCreated: widget.isBeingCreated,
    );
  }
}

// https://dribbble.com/shots/14394839-Invoicing-app
class DetailView extends StatelessWidget {
  const DetailView({
    required this.invoice,
    required this.isBeingCreated,
    super.key,
  });

  final Invoice invoice;
  final bool? isBeingCreated;

  String get _orderNumber {
    return 'Faturë ${invoice.invoiceOrderNumber!}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        // `toolbarHeight` because of: https://stackoverflow.com/a/70815978
        toolbarHeight: kToolbarHeight + 1,
        backgroundColor: colorScheme.primary,
        centerTitle: true,
        title: Text(_orderNumber,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Items(invoice: invoice),
            if (isBeingCreated == true)
              Align(
                alignment: Alignment.bottomCenter,
                child: SaveButton(invoice: invoice),
              ),
            if (isBeingCreated == false)
              Align(
                alignment: Alignment.bottomCenter,
                child: DeleteButton(invoice: invoice),
              ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({required this.invoice, super.key});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final date = invoice.dateTimeCreated;

    final totalPrice = invoice.totalPrice;
    final totalPriceWithoutVAT = invoice.totalPriceWithoutVAT;
    final totalVATAmount = invoice.totalVATAmount;

    final invoiceOrderNumber = invoice.invoiceOrderNumber;
    final year = date?.year;
    final cashRegister = invoice.cashRegister;

    final seller = invoice.seller.value;

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimeSection(date: date),
              PriceSection(
                totalPrice: totalPrice!,
                totalPriceWithoutVAT: totalPriceWithoutVAT,
                totalVATAmount: totalVATAmount,
              ),
              if (seller != null) SellerSection(seller: seller),
              Align(
                alignment: Alignment.centerRight,
                child: InvoiceSignSection(
                  invoiceOrderNumber: invoiceOrderNumber!,
                  year: year,
                  cashRegister: cashRegister,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceSection extends StatelessWidget {
  const PriceSection({
    required this.totalPrice,
    this.totalPriceWithoutVAT,
    this.totalVATAmount,
    super.key,
  });

  final double totalPrice;
  final double? totalPriceWithoutVAT;
  final double? totalVATAmount;

  String get _formattedTotalPrice {
    return '${totalPrice.toInt()} Lekë';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final withoutVatValue =
        'Pa TVSH: ${totalPriceWithoutVAT?.toStringAsFixed(2)} Lekë';
    final vatValue =
        'Shuma e TVSH-së: ${totalVATAmount?.toStringAsFixed(2)} Lekë';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            _formattedTotalPrice,
            style: theme.textTheme.displaySmall?.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
        ),
        if (totalPriceWithoutVAT != null)
          Text(
            withoutVatValue,
            style: theme.textTheme.labelMedium
                ?.copyWith(color: colorScheme.onPrimary),
          ),
        if (totalVATAmount != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              vatValue,
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: colorScheme.onPrimary),
            ),
          )
      ],
    );
  }
}

class InvoiceSignSection extends StatelessWidget {
  const InvoiceSignSection({
    required this.invoiceOrderNumber,
    required this.year,
    required this.cashRegister,
    super.key,
  });

  final int invoiceOrderNumber;
  final int? year;
  final String? cashRegister;

  String? get _sign {
    var sign = invoiceOrderNumber.toString();
    if (year != null) sign = '$sign / $year';
    if (cashRegister != null) sign = '$sign / $cashRegister';
    return sign;
  }

  @override
  Widget build(BuildContext context) {
    if (_sign == null) return const SizedBox();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Text(
      _sign!,
      style: theme.textTheme.labelLarge?.copyWith(
        color: colorScheme.onPrimary,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class SellerSection extends StatelessWidget {
  const SellerSection({this.seller, super.key});

  final Seller? seller;

  String? get _address {
    final address = seller?.address;
    final town = seller?.town;
    final country = seller?.country;

    if (address == null && town == null && country == null) {
      return null;
    }

    var value = address ?? '';
    if (town != null) value = '$value, $town';
    if (country != null) value = '$value, $country';

    return value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final address = _address;
    final name = seller?.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (address != null)
          Text(
            address,
            style: theme.textTheme.labelLarge
                ?.copyWith(color: colorScheme.onPrimary),
          ),
        if (name != null)
          Text(
            name,
            style: theme.textTheme.labelLarge
                ?.copyWith(color: colorScheme.onPrimary),
          ),
      ],
    );
  }
}

class TimeSection extends StatelessWidget {
  const TimeSection({required this.date, super.key});

  final DateTime? date;

  String? get _formattedDate {
    if (date == null) return null;

    final day = date?.day;
    final month = date?.month;
    final year = date?.year;

    final hour = date?.hour;
    final minute = date?.minute.toString().padLeft(2, '0');

    final formattedDate = '$day/$month/$year $hour:$minute';
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    if (_formattedDate == null) return const SizedBox();

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Text(
      _formattedDate!,
      style: textTheme.bodySmall?.copyWith(
        color: colorScheme.onPrimary,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class Items extends StatelessWidget {
  const Items({required this.invoice, super.key});

  final Invoice invoice;

  List<Item>? get _items {
    final items = invoice.items;
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: _items!.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) return Header(invoice: invoice);
        if (index == _items!.length + 1) return const SizedBox(height: 72);
        final item = _items![index - 1];
        return Article(item: item);
      },
    );
  }
}

class Article extends StatelessWidget {
  const Article({required this.item, super.key});

  final Item item;

  String? get _name => item.name;

  double? get _quantity => item.quantity;

  double? get _priceAfterVat => item.priceAfterVat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.onPrimary,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _name!,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: colorScheme.onSurface),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'X $_quantity',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: colorScheme.onSurface),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_priceAfterVat!.toInt()} Lekë',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(color: colorScheme.onSurface),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({required this.invoice, super.key});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailBloc, DetailState>(
      listener: (context, state) async {
        FocusScope.of(context).unfocus();
        final status = state.additionStatus;
        if (status == AdditionStatus.loading) {
          await Loader.startLoading(context);
          return;
        }
        if (status == AdditionStatus.success) {
          Loader.stopLoading(context);
          context.pop();
          return;
        }
      },
      builder: (context, state) => TonalButton(
        title: 'Ruaj faturën',
        onPressed: () {
          final addInvoiceEvent = AddInvoice(invoice);
          context.read<DetailBloc>().add(addInvoiceEvent);

          final addInvoiceToStateEvent = AddInvoiceToState(invoice);
          context.read<InvoiceBloc>().add(addInvoiceToStateEvent);
        },
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({required this.invoice, super.key});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailBloc, DetailState>(
      listener: (context, state) async {
        FocusScope.of(context).unfocus();
        final status = state.removalStatus;
        if (status == RemovalStatus.loading) {
          await Loader.startLoading(context);
          return;
        }
        if (status == RemovalStatus.success) {
          Loader.stopLoading(context);
          context.pop();
          return;
        }
      },
      builder: (context, state) => TonalButton(
        title: 'Fshij faturën',
        onPrimary: Theme.of(context).colorScheme.onError,
        primary: Theme.of(context).colorScheme.error,
        onPressed: () {
          final deleteInvoiceEvent = DeleteInvoice(invoice);
          context.read<DetailBloc>().add(deleteInvoiceEvent);

          final removeInvoiceFromStateEvent = RemoveInvoiceFromState(invoice);
          context.read<InvoiceBloc>().add(removeInvoiceFromStateEvent);
        },
      ),
    );
  }
}
