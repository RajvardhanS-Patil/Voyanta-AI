import 'dart:convert';
import 'package:isar/isar.dart';
import 'isar_service.dart';
import 'collections/cache_entry_db.dart';

class CacheManager {
  // In-memory cache layer for rapid reads
  final Map<String, _MemoryCacheEntry> _memoryCache = {};
  
  // Cache statistics
  int _hits = 0;
  int _misses = 0;

  int get hits => _hits;
  int get misses => _misses;

  Future<void> put(String key, Map<String, dynamic> data, Duration ttl) async {
    final expiresAt = DateTime.now().add(ttl);
    
    // Cache in memory
    _memoryCache[key] = _MemoryCacheEntry(
      data: data,
      expiresAt: expiresAt,
    );

    // Persist to Isar local database
    final jsonStr = jsonEncode(data);
    
    await IsarService.isar.writeTxn(() async {
      final entry = CacheEntryDb()
        ..cacheKey = key
        ..valueJson = jsonStr
        ..expiresAt = expiresAt;
      await IsarService.isar.cacheEntryDbs.put(entry);
    });
  }

  Future<Map<String, dynamic>?> get(String key) async {
    final now = DateTime.now();

    // Check memory layer first
    if (_memoryCache.containsKey(key)) {
      final memEntry = _memoryCache[key]!;
      if (memEntry.expiresAt.isAfter(now)) {
        _hits++;
        return memEntry.data;
      } else {
        _memoryCache.remove(key); // Evict expired item
      }
    }

    // Check Isar local database persistence
    final entry = await IsarService.isar.cacheEntryDbs.filter().cacheKeyEqualTo(key).findFirst();
    if (entry != null) {
      if (entry.expiresAt.isAfter(now)) {
        _hits++;
        final decoded = jsonDecode(entry.valueJson) as Map<String, dynamic>;
        // Restore to memory cache
        _memoryCache[key] = _MemoryCacheEntry(data: decoded, expiresAt: entry.expiresAt);
        return decoded;
      } else {
        // Evict expired database entry
        await IsarService.isar.writeTxn(() async {
          await IsarService.isar.cacheEntryDbs.delete(entry.id);
        });
      }
    }

    _misses++;
    return null;
  }

  Future<void> invalidate(String key) async {
    _memoryCache.remove(key);
    final entry = await IsarService.isar.cacheEntryDbs.filter().cacheKeyEqualTo(key).findFirst();
    if (entry != null) {
      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.cacheEntryDbs.delete(entry.id);
      });
    }
  }

  Future<void> cleanup() async {
    final now = DateTime.now();
    _memoryCache.removeWhere((key, entry) => entry.expiresAt.isBefore(now));
    
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.cacheEntryDbs.filter().expiresAtLessThan(now).deleteAll();
    });
  }

  Future<void> clear() async {
    _memoryCache.clear();
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.cacheEntryDbs.clear();
    });
  }
}

class _MemoryCacheEntry {
  final Map<String, dynamic> data;
  final DateTime expiresAt;

  _MemoryCacheEntry({required this.data, required this.expiresAt});
}
