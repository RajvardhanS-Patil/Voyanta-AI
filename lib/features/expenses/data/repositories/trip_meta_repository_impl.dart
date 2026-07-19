import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/trip_meta.dart';
import '../../domain/repositories/trip_meta_repository.dart';

class TripMetaRepositoryImpl implements TripMetaRepository {
  final FlutterSecureStorage _storage;
  
  static const String _budgetKey = 'trip_meta_budget';
  static const String _membersKey = 'trip_meta_members';

  TripMetaRepositoryImpl(this._storage);

  @override
  Future<TripMeta> getTripMeta() async {
    final budgetStr = await _storage.read(key: _budgetKey);
    final membersStr = await _storage.read(key: _membersKey);

    double budget = 5000.0;
    List<String> members = ['Me'];

    if (budgetStr != null) {
      budget = double.tryParse(budgetStr) ?? 5000.0;
    }
    
    if (membersStr != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(membersStr);
        members = jsonList.map((e) => e.toString()).toList();
      } catch (e) {
        // fallback to default
      }
    }

    return TripMeta(totalBudget: budget, members: members);
  }

  @override
  Future<void> saveTripMeta(TripMeta meta) async {
    await _storage.write(key: _budgetKey, value: meta.totalBudget.toString());
    await _storage.write(key: _membersKey, value: jsonEncode(meta.members));
  }
}
