import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/core/services/connectivity_service.dart';
import 'package:voyanta_ai/core/database/isar_service.dart';
import 'package:voyanta_ai/core/database/collections/sync_queue_db.dart';
import 'package:voyanta_ai/core/sync/sync_queue_processor.dart';

class SyncStatusBanner extends ConsumerWidget {
  const SyncStatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStatus = ref.watch(connectivityServiceProvider);
    
    return StreamBuilder<int>(
      stream: IsarService.isar.syncQueueDbs.watchLazy().map((_) => 
        IsarService.isar.syncQueueDbs.countSync()
      ),
      initialData: IsarService.isar.syncQueueDbs.countSync(),
      builder: (context, snapshot) {
        final pendingCount = snapshot.data ?? 0;
        final isOffline = connectionStatus == ConnectionStatus.offline;
        final isWeak = connectionStatus == ConnectionStatus.weak;

        if (!isOffline && !isWeak && pendingCount == 0) {
          return const SizedBox.shrink();
        }

        Color bannerColor = Colors.orangeAccent.withOpacity(0.15);
        String label = "Weak connection speed";
        IconData icon = Icons.signal_wifi_bad_outlined;

        if (isOffline) {
          bannerColor = Colors.redAccent.withOpacity(0.15);
          label = "Offline Mode active";
          icon = Icons.cloud_off_outlined;
        } else if (pendingCount > 0) {
          bannerColor = Colors.tealAccent.withOpacity(0.15);
          label = "Syncing actions to remote server...";
          icon = Icons.sync_outlined;
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: bannerColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        if (pendingCount > 0)
                          Text(
                            "$pendingCount pending write operation${pendingCount > 1 ? 's' : ''} saved locally",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontFamily: 'Outfit',
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (pendingCount > 0 && !isOffline)
                    IconButton(
                      icon: const Icon(Icons.refresh_outlined, color: Colors.white, size: 20),
                      onPressed: () {
                        ref.read(syncQueueProcessorProvider).triggerSync();
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
