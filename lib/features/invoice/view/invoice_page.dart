import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:intl/intl.dart';
import 'package:invoice_repository/invoice_repository.dart';
import 'package:kuleta/features/invoice/bloc/invoice_bloc.dart';
import 'package:kuleta/features/invoice/view/onboarding_page.dart';
import 'package:kuleta/l10n/l10n.dart';
import 'package:kuleta/ui/ui.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _View();
  }
}

class _View extends StatelessWidget {
  const _View();

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
      body: const _InvoiceList(),
    );
  }
}

class _InvoiceList extends StatefulWidget {
  const _InvoiceList();

  @override
  State<_InvoiceList> createState() => _InvoiceListState();
}

class _InvoiceListState extends State<_InvoiceList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvoiceBloc, InvoiceState>(
      listenWhen: (previous, current) =>
          previous.shouldBeOnboarded != current.shouldBeOnboarded,
      listener: (context, state) {
        if (state.shouldBeOnboardedStatus == ShouldBeOnboardedStatus.success &&
            state.shouldBeOnboarded) {
          unawaited(
            showCupertinoModalBottomSheet<void>(
              context: context,
              expand: true,
              enableDrag: false,
              builder: (context) => const OnboardingPage(),
            ),
          );
        }
      },
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
            if (section == 0) {
              return 0;
            }
            // Needed to render bottom of list
            if (section == invoices.length + 1) {
              return 1;
            }
            return invoices[section - 1].invoices.length;
          },
          itemBuilder: (BuildContext context, IndexPath index) {
            if (index.section == 0) {
              return Container();
            }
            // Renders bottom of list to allow FAB to not overlap listings
            if (index.section == invoices.length + 1) {
              return BlocSelector<InvoiceBloc, InvoiceState, bool>(
                selector: (state) => state.hasReachedMax,
                builder: (context, hasReachedMax) => _BottomSection(
                  hasReachedMax: hasReachedMax,
                ),
              );
            }
            final item = invoices[index.section - 1].invoices[index.index];
            return _Receipt(invoice: item);
          },
          groupHeaderBuilder: (BuildContext context, int section) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;

            if (section == 0) {
              return const _Header();
            }
            // avoids rendering bottom of list header
            if (section == invoices.length + 1) {
              return Container();
            }
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
    if (!_scrollController.hasClients) {
      return false;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return BlocSelector<InvoiceBloc, InvoiceState, double>(
      selector: (state) => state.totalAmountSpentLastMonth,
      builder: (context, totalAmountSpentLastMonth) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(24),
              ),
            ),
            child: totalAmountSpentLastMonth == double.nan
                ? CircularProgressIndicator(color: colorScheme.onPrimary)
                : Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Text(
                          '${l10n.totalAmountSpentThisMonthTitle}:',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(color: colorScheme.onPrimary),
                        ),
                        Text(
                          '${totalAmountSpentLastMonth.toStringAsFixed(2)} '
                          'Lekë',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _BottomSection extends StatelessWidget {
  const _BottomSection({required this.hasReachedMax});

  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!hasReachedMax) const BottomLoader(),
        const SizedBox(height: 72),
      ],
    );
  }
}

class _Receipt extends StatelessWidget {
  const _Receipt({required this.invoice});

  final Invoice invoice;

  String? get _name => invoice.seller.value?.name;

  String? get _address => invoice.seller.value?.address;

  double? get _totalPrice => invoice.totalPrice;

  String? get _time {
    final time = invoice.dateTimeCreated;
    if (time == null) {
      return null;
    }
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
            color: colorScheme.surface,
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
