import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool notifOn = true;
  String theme = 'Terang';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Notifikasi'),
          value: notifOn,
          onChanged: (v) => setState(() => notifOn = v),
        ),
        const SizedBox(height: 12),
        const Text('Tema', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Terang'),
              selected: theme == 'Terang',
              onSelected: (_) => setState(() => theme = 'Terang'),
            ),
            ChoiceChip(
              label: const Text('Gelap'),
              selected: theme == 'Gelap',
              onSelected: (_) => setState(() => theme = 'Gelap'),
            ),
          ],
        ),
      ],
    );
  }
}