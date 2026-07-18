import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:voyanta_ai/core/database/isar_service.dart';
import 'package:voyanta_ai/core/database/collections/cache_entry_db.dart';
import 'package:voyanta_ai/core/database/collections/sync_queue_db.dart';
import 'package:voyanta_ai/core/database/cache_manager.dart';
import 'package:voyanta_ai/core/sync/conflict_resolver.dart';
import 'package:voyanta_ai/core/sync/sync_queue_processor.dart';

class TestModel implements HasTimestamp {
  final String data;
  @override
  final DateTime updatedAt;

  TestModel(this.data, this.updatedAt);
}

void main() {
  late Directory tempDir;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    tempDir = await Directory.systemTemp.createTemp('isar_test');
    IsarService.isar = await Isar.open([
      CacheEntryDbSchema,
      SyncQueueDbSchema,
    ], directory: tempDir.path);
  });

  tearDownAll(() async {
    await IsarService.isar.close();
    await tempDir.delete(recursive: true);
  });

  group('Smart Cache Engine Tests', () {
    late CacheManager cacheManager;

    setUp(() async {
      cacheManager = CacheManager();
      await cacheManager.clear();
    });

    test(
      'CacheManager should store and retrieve valid entries within TTL',
      () async {
        await cacheManager.put('key1', {
          'foo': 'bar',
        }, const Duration(seconds: 5));

        final data = await cacheManager.get('key1');
        expect(data, isNotNull);
        expect(data!['foo'], 'bar');
        expect(cacheManager.hits, 1);
      },
    );

    test('CacheManager should return null and evict expired entries', () async {
      await cacheManager.put('key2', {
        'foo': 'bar',
      }, const Duration(milliseconds: 10));
      await Future.delayed(const Duration(milliseconds: 20));

      final data = await cacheManager.get('key2');
      expect(data, isNull);
      expect(cacheManager.misses, 1);
    });

    test('CacheManager should support manual invalidation', () async {
      await cacheManager.put('key3', {'foo': 'bar'}, const Duration(hours: 1));
      await cacheManager.invalidate('key3');

      final data = await cacheManager.get('key3');
      expect(data, isNull);
    });
  });

  group('Conflict Resolution Tests', () {
    late ConflictResolver conflictResolver;

    setUp(() {
      conflictResolver = ConflictResolverImpl();
    });

    test('LastWriteWins strategy should select newer timestamp item', () {
      final oldItem = TestModel('old', DateTime(2026, 1, 1));
      final newItem = TestModel('new', DateTime(2026, 1, 2));

      final resolved = conflictResolver.resolve(
        local: oldItem,
        server: newItem,
        strategy: ConflictStrategy.lastWriteWins,
      );

      expect(resolved.data, 'new');
    });

    test('LastWriteWins strategy should select local if local is newer', () {
      final oldItem = TestModel('old', DateTime(2026, 1, 1));
      final newItem = TestModel('new', DateTime(2026, 1, 2));

      final resolved = conflictResolver.resolve(
        local: newItem,
        server: oldItem,
        strategy: ConflictStrategy.lastWriteWins,
      );

      expect(resolved.data, 'new');
    });
  });

  group('Sync Queue Tests', () {
    setUp(() async {
      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.syncQueueDbs.clear();
      });
    });

    test(
      'SyncQueueProcessor should run FIFO queue successfully when triggered',
      () async {
        final container = ProviderContainer();

        final op1 = SyncQueueDb()
          ..operationId = '1'
          ..type = 'add_expense'
          ..payloadJson = jsonEncode({'amount': 100.0})
          ..timestamp = DateTime.now().subtract(const Duration(seconds: 1));

        final op2 = SyncQueueDb()
          ..operationId = '2'
          ..type = 'complete_activity'
          ..payloadJson = jsonEncode({'index': 1})
          ..timestamp = DateTime.now();

        await IsarService.isar.writeTxn(() async {
          await IsarService.isar.syncQueueDbs.putAll([op1, op2]);
        });

        final processor = container.read(syncQueueProcessorProvider);
        await processor.triggerSync();

        final count = await IsarService.isar.syncQueueDbs.count();
        expect(count, 0);
      },
    );
  });
}
