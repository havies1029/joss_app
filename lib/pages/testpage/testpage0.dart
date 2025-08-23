import 'package:flutter/material.dart';
import 'package:joss_app/pages/testpage/invoice_page.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  void _showSnack(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label ditekan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        // responsif jumlah kolom
        final cols = c.maxWidth < 380 ? 3 : 4;
        return GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: cols,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _IconButtonTile(
              icon: Icons.receipt_long,
              label: 'Invoice',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const InvoicePage()),
                );
              },
            ),
            _IconButtonTile(
              icon: Icons.shopping_cart,
              label: 'Orders',
              onTap: () => _showSnack(context, 'Orders'),
            ),
            _IconButtonTile(
              icon: Icons.people_alt,
              label: 'Clients',
              onTap: () => _showSnack(context, 'Clients'),
            ),
            _IconButtonTile(
              icon: Icons.bar_chart,
              label: 'Reports',
              onTap: () => _showSnack(context, 'Reports'),
            ),
            _IconButtonTile(
              icon: Icons.calendar_today,
              label: 'Schedule',
              onTap: () => _showSnack(context, 'Schedule'),
            ),
            _IconButtonTile(
              icon: Icons.settings,
              label: 'Settings',
              onTap: () => _showSnack(context, 'Settings'),
            ),
          ],
        );
      },
    );
  }
}

class _IconButtonTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _IconButtonTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cs.surfaceVariant.withOpacity(0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: cs.primary),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}