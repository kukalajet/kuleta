import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:kuleta/features/scanner/bloc/scanner_bloc.dart';
import 'package:kuleta/l10n/l10n.dart';
import 'package:kuleta/ui/ui.dart';

class ManualAdditionForm extends StatelessWidget {
  const ManualAdditionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScannerBloc, ScannerState>(
      listener: (context, state) {
        if (state.manualAdditionStatus.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(context.l10n.invoiceSearchFailed)),
            );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(context.l10n.manualSearch),
            ),
            const SizedBox(height: 15),
            _TINInput(),
            const SizedBox(height: 15),
            _IICInput(),
            const SizedBox(height: 15),
            _DateCreatedInput(),
            const SizedBox(height: 15),
            _TimeCreatedInput(),
            const SizedBox(height: 15),
            _SearchButton()
          ],
        ),
      ),
    );
  }
}

class _TINInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScannerBloc, ScannerState>(
      buildWhen: (previous, current) => previous.tin != current.tin,
      builder: (context, state) {
        return TextField(
          key: const Key('manualAdditionForm_tinInput_textField'),
          onChanged: (tin) => context.read<ScannerBloc>().add(TINChanged(tin)),
          decoration: InputDecoration(
            labelText: 'NIPT',
            errorText: state.tin.invalid ? 'invalid nipt' : null,
          ),
        );
      },
    );
  }
}

class _IICInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScannerBloc, ScannerState>(
      buildWhen: (previous, current) => previous.iic != current.iic,
      builder: (context, state) {
        return TextField(
          key: const Key('manualAdditionForm_iicInput_textField'),
          onChanged: (iic) => context.read<ScannerBloc>().add(IICChanged(iic)),
          decoration: InputDecoration(
            labelText: 'NSLF / IIC',
            errorText: state.tin.invalid ? 'invalid iic' : null,
          ),
        );
      },
    );
  }
}

class _TimeCreatedInput extends StatefulWidget {
  @override
  State<_TimeCreatedInput> createState() => _TimeCreatedInputState();
}

class _TimeCreatedInputState extends State<_TimeCreatedInput> {
  final _controller = TextEditingController();

  Future<void> chooseTime(BuildContext context) async {
    final value = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 4, minute: 20),
    );
    if (value != null) {
      context.read<ScannerBloc>().add(TimeCreatedChanged(value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScannerBloc, ScannerState>(
      listenWhen: (previous, current) =>
          previous.timeCreated != current.timeCreated,
      listener: (context, state) {
        setState(() {
          _controller.text = '${state.timeCreated.value?.hour} : '
              '${state.timeCreated.value?.minute}';
        });
      },
      buildWhen: (previous, current) =>
          previous.timeCreated != current.timeCreated,
      builder: (context, state) {
        return TextFormField(
          key: const Key('manualAdditionForm_timeCreatedInput_textField'),
          controller: _controller,
          onTap: () => unawaited(chooseTime(context)),
          decoration: InputDecoration(
            labelText: context.l10n.timeCreated,
            errorText: state.timeCreated.invalid ? 'time created' : null,
          ),
        );
      },
    );
  }
}

class _DateCreatedInput extends StatefulWidget {
  @override
  State<_DateCreatedInput> createState() => _DateCreatedInputState();
}

class _DateCreatedInputState extends State<_DateCreatedInput> {
  final _controller = TextEditingController();

  Future<void> chooseDate(BuildContext context) async {
    final value = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2017, 3),
      lastDate: DateTime.now(),
      helpText: context.l10n.selectDate,
    );

    if (value != null) {
      context.read<ScannerBloc>().add(DateCreatedChanged(value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScannerBloc, ScannerState>(
      listenWhen: (previous, current) =>
          previous.dateCreated != current.dateCreated,
      listener: (context, state) {
        setState(() {
          _controller.text = '${state.dateCreated.value?.day} / '
              '${state.dateCreated.value?.month} / '
              '${state.dateCreated.value?.year}';
        });
      },
      buildWhen: (previous, current) =>
          previous.dateCreated != current.dateCreated,
      builder: (context, state) {
        return TextFormField(
          key: const Key('manualAdditionForm_timeCreatedInput_textField'),
          controller: _controller,
          onTap: () => unawaited(chooseDate(context)),
          decoration: InputDecoration(
            labelText: context.l10n.dateCreated,
            errorText: state.tin.invalid ? 'date created' : null,
          ),
        );
      },
    );
  }
}

class _SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScannerBloc, ScannerState>(
      buildWhen: (previous, current) =>
          previous.manualAdditionStatus != current.manualAdditionStatus,
      builder: (context, state) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return state.manualAdditionStatus.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : TonalButton(
                title: context.l10n.searchInvoice,
                onPrimary: colorScheme.error,
                primary: colorScheme.error,
                onPressed: state.manualAdditionStatus.isValidated
                    ? () {
                        context
                            .read<ScannerBloc>()
                            .add(const ManuallyFetchInvoice());
                      }
                    : null,
              );
      },
    );
  }
}
