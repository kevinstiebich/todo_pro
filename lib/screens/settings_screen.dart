import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';

class SettingsScreen extends ConsumerWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final asksForDeletionConfirmation = ref
        .watch(appStateProvider)
        .asksForDeletionConfirmation;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 253, 169),
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (bool value) {
              ref.read(appStateProvider.notifier).setDarkMode(isDarkMode);
            },
          ),

          SwitchListTile(
            title: const Text('Ask for Deletion Confirmation'),
            value: asksForDeletionConfirmation,
            onChanged: (bool value) {
              ref.read(appStateProvider.notifier).toggleDeletionConfirmation();
            },
          ),
        ],
      ),
    );
  }
}
