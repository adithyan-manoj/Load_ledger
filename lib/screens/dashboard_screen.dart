import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  final Widget child;

  const DashboardScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    final sidebarContent = Container(
      color: AppTheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_balance_outlined,
                    size: 26, color: AppTheme.primary),
                SizedBox(height: 10),
                Text(
                  'Co-op Society',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Loan Recovery Platform',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.border),
          const SizedBox(height: 12),
          _SidebarTile(
            icon: CupertinoIcons.person_3,
            label: 'Customers',
            selected: true,
            onTap: () {
              context.go('/');
              if (!isDesktop) Navigator.of(context).pop();
            },
          ),
          _SidebarTile(
            icon: CupertinoIcons.doc_text,
            label: 'Drafts',
            selected: false,
            onTap: () {
              if (!isDesktop) Navigator.of(context).pop();
            },
          ),
          const Spacer(),
          const Divider(height: 1, color: AppTheme.border),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.border),
                  ),
                  alignment: Alignment.center,
                  child: const Text('AD',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary)),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Officer',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary)),
                      Text('System Admin',
                          style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (isDesktop) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Row(
          children: [
            Container(
              width: 240,
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: AppTheme.border, width: 1.0),
                ),
              ),
              child: sidebarContent,
            ),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Co-op Recovery'),
      ),
      drawer: Drawer(
        child: sidebarContent,
      ),
      body: child,
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppTheme.surfaceVariant : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected ? AppTheme.primary : AppTheme.textSecondary,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? AppTheme.primary : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
