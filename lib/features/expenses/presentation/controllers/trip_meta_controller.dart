import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/trip_meta.dart';
import '../../domain/repositories/trip_meta_repository.dart';
import 'expense_providers.dart';

class TripMetaController extends AsyncNotifier<TripMeta> {
  late final TripMetaRepository _repository;

  @override
  Future<TripMeta> build() async {
    _repository = ref.read(tripMetaRepositoryProvider);
    return await _repository.getTripMeta();
  }

  Future<void> updateBudget(double newBudget) async {
    if (!state.hasValue) return;
    
    final currentMeta = state.value!;
    final newMeta = currentMeta.copyWith(totalBudget: newBudget);
    
    // Optimistic UI update
    state = AsyncData(newMeta);
    
    try {
      await _repository.saveTripMeta(newMeta);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addMember(String memberName) async {
    if (!state.hasValue) return;
    
    final currentMeta = state.value!;
    if (currentMeta.members.contains(memberName)) return;

    final newMembers = List<String>.from(currentMeta.members)..add(memberName);
    final newMeta = currentMeta.copyWith(members: newMembers);
    
    // Optimistic UI update
    state = AsyncData(newMeta);
    
    try {
      await _repository.saveTripMeta(newMeta);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> removeMember(String memberName) async {
    if (!state.hasValue) return;
    
    final currentMeta = state.value!;
    // Prevent removing 'Me'
    if (memberName == 'Me') return;
    
    final newMembers = List<String>.from(currentMeta.members)..remove(memberName);
    final newMeta = currentMeta.copyWith(members: newMembers);
    
    state = AsyncData(newMeta);
    
    try {
      await _repository.saveTripMeta(newMeta);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
