import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dummy_data.dart';
import '../theme/app_theme.dart';
import '../widgets/fintech_components.dart';

class CustomersScreen extends ConsumerWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = DummyData.customers;

    return FintechScaffold(
      appBar: AppBar(
        title: const Text('Customers Overview'),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ALL REGISTERED CUSTOMERS',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                FintechBadge.neutral('${customers.length} REGISTERED'),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: FintechCard(
                padding: EdgeInsets.zero,
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor:
                          WidgetStateProperty.all(AppTheme.surfaceVariant),
                      dividerThickness: 1.0,
                      headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.8,
                      ),
                      dataTextStyle: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('NAME')),
                        DataColumn(label: Text('MEMBER NO')),
                        DataColumn(label: Text('UNIT ID')),
                        DataColumn(label: Text('STATUS')),
                      ],
                      rows: customers.map((c) {
                        return DataRow(
                          cells: [
                            DataCell(Text(c.id)),
                            DataCell(Text(c.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700))),
                            DataCell(Text(c.memberNo)),
                            DataCell(Text(c.officeId)),
                            DataCell(FintechBadge.success('ACTIVE')),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
