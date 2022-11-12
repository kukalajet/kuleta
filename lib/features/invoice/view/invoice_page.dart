import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:intl/intl.dart';
import 'package:invoice_repository/invoice_repository.dart';
import 'package:kuleta/features/invoice/bloc/invoice_bloc.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const InvoicePageView();
  }
}

class InvoicePageView extends StatelessWidget {
  const InvoicePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        elevation: 0,
        toolbarHeight: 0,
      ),
      backgroundColor: colorScheme.surface,
      body: const InvoiceList(),
    );
  }
}

class InvoiceList extends StatefulWidget {
  const InvoiceList({super.key});

  @override
  State<InvoiceList> createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      buildWhen: (previous, current) {
        final previousInvoices = previous.invoices;
        final previousLength = previousInvoices.fold<int>(
          0,
          (previous, item) {
            final length = item.invoices.length;
            return previous + length;
          },
        );

        final currentInvoices = current.invoices;
        final currentLength = currentInvoices.fold<int>(0, (previous, item) {
          final length = item.invoices.length;
          return previous + length;
        });

        return previousLength != currentLength ||
            previous.invoicesStatus != current.invoicesStatus;
      },
      builder: (context, state) {
        final invoices = state.invoices;
        final status = state.invoicesStatus;

        if (status == InvoicesStatus.failure) {
          return const Center(child: Text('failed to fetch listings'));
        }

        if (status == InvoicesStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }

        return GroupListView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          sectionsCount: invoices.length + 2,
          countOfItemInSection: (int section) {
            if (section == 0) return 0;
            // Needed to render bottom of list
            if (section == invoices.length + 1) return 1;
            return invoices[section - 1].invoices.length;
          },
          itemBuilder: (BuildContext context, IndexPath index) {
            if (index.section == 0) return Container();
            // Renders bottom of list to allow FAB to not overlap listings
            if (index.section == invoices.length + 1) {
              return const SizedBox(height: 72);
            }
            final item = invoices[index.section - 1].invoices[index.index];
            return Receipt(invoice: item);
          },
          groupHeaderBuilder: (BuildContext context, int section) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;

            if (section == 0) return const Header();
            // avoids rendering bottom of list header
            if (section == invoices.length + 1) return Container();
            final dateTime = invoices[section - 1].dateTime;
            final value = DateFormat('EEEE, d MMMM').format(dateTime);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onBackground,
                ),
              ),
            );
          },
          sectionSeparatorBuilder: (context, section) =>
              const SizedBox(height: 16),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<InvoiceBloc>().add(InvoicesFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;
    // final l10n = context.l10n;
    // final totalExpenseLastMonth =
    //     context.select((InvoiceBloc bloc) => bloc.state.expenseLastMonth);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Container(),
        // child: Padding(
        //   padding: const EdgeInsets.all(40),
        //   child: Column(
        //     children: [
        //       Text(
        //         '${l10n.spentThisMonthTitle}:',
        //         style: theme.textTheme.titleSmall
        //             ?.copyWith(color: colorScheme.onPrimary),
        //       ),
        //       Text(
        //         '${totalExpenseLastMonth.toStringAsFixed(2)} Lekë',
        //         style: theme.textTheme.headline3?.copyWith(
        //           color: colorScheme.onPrimary,
        //         ),
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }
}

class Receipt extends StatelessWidget {
  const Receipt({required this.invoice, super.key});

  final Invoice invoice;

  String? get _name => invoice.seller.value?.name;

  String? get _address => invoice.seller.value?.address;

  double? get _totalPrice => invoice.totalPrice;

  String? get _time {
    final time = invoice.dateTimeCreated;
    if (time == null) return null;
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () => context.go('/detail', extra: invoice),
        child: Ink(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.onPrimary,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_name != null)
                      Text(
                        _name!,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(color: colorScheme.onSurface),
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (_address != null && _time != null)
                      Text(
                        '$_address',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: colorScheme.onSurface),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$_time',
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: colorScheme.onSurface),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${_totalPrice!.toInt()} Lekë',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(color: colorScheme.onSurface),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
