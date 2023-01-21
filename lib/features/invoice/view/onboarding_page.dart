import 'package:flutter/material.dart';
import 'package:kuleta/ui/ui.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) => const _View();
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Column(
        children: const <Widget>[
          _Title(),
          _Item(
            title: 'Keep your invoice always with you',
            description:
                'All your invoices in a single place where you can revisit '
                'them whenever you want',
            icon: Icons.document_scanner,
          ),
          _Item(
            title: 'Manage your spendings',
            description:
                'Ever felt spending too much? Having visibility of where your '
                'expenses are coming will help you save money',
            icon: Icons.attach_money,
          ),
          _Item(
            title: 'No login required',
            description:
                'Kuleta is not interested in who you are, use it anonymously',
            icon: Icons.supervised_user_circle,
          ),
          Spacer(),
          _ContinueButton(),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            'Kuleta',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(icon),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  description,
                  textAlign: TextAlign.left,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: TonalButton(
        title: 'Continue',
        onPrimary: colorScheme.onError,
        primary: colorScheme.primary,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
