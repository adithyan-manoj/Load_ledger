import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'schemas/office_collection.dart';
import 'schemas/customer_collection.dart';
import 'schemas/loan_collection.dart';
import 'schemas/monthly_recovery_collection.dart';

class IsarDatabaseService {
  static Isar? _instance;
  final String? customDirectory;

  IsarDatabaseService({this.customDirectory});

  /// Returns the active Isar database instance, opening it if not yet open.
  Future<Isar> get isar async {
    if (_instance != null && _instance!.isOpen) {
      return _instance!;
    }

    // Check if an instance named 'default' already exists
    final existing = Isar.getInstance('default');
    if (existing != null && existing.isOpen) {
      _instance = existing;
      return _instance!;
    }

    final String dir;
    if (customDirectory != null) {
      dir = customDirectory!;
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      dir = appDir.path;
    }

    _instance = await Isar.open(
      [
        OfficeCollectionSchema,
        CustomerCollectionSchema,
        LoanCollectionSchema,
        MonthlyRecoveryCollectionSchema,
      ],
      name: 'default',
      directory: dir,
      inspector: kDebugMode,
    );

    return _instance!;
  }

  /// Wipes all data across all collections in the database.
  Future<void> clearAll() async {
    final db = await isar;
    await db.writeTxn(() async {
      await db.monthlyRecoveryCollections.clear();
      await db.loanCollections.clear();
      await db.customerCollections.clear();
      await db.officeCollections.clear();
    });
  }

  /// Closes the Isar database instance.
  Future<void> close() async {
    if (_instance != null && _instance!.isOpen) {
      await _instance!.close();
      _instance = null;
    }
  }
}

