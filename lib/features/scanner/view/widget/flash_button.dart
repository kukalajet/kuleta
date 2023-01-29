import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class FlashButton extends StatefulWidget {
  const FlashButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  State<FlashButton> createState() => _FlashButtonState();
}

class _FlashButtonState extends State<FlashButton> {
  bool _isTorchActive = false;

  Future<void> _onPressed() async {
    await widget.controller.toggleTorch();
    setState(() => _isTorchActive = !_isTorchActive);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Ink(
      decoration: ShapeDecoration(
        shape: const CircleBorder(),
        color: colorScheme.secondary,
      ),
      child: IconButton(
        iconSize: 32,
        icon: Icon(
          _isTorchActive ? Icons.flash_on : Icons.flash_off,
          color: colorScheme.onPrimary,
        ),
        onPressed: _onPressed,
      ),
    );
  }
}
