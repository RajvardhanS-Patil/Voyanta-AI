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
      stream: IsarService.isar.syncQueueDbs.watchLazy().map(
        (_) => IsarService.isar.syncQueueDbs.countSync(),
      ),
      initialData: IsarService.isar.syncQueueDbs.countSync(),
      builder: (context, snapshot) {
        final pendingCount = snapshot.data ?? 0;
        final isOffline = connectionStatus == ConnectionStatus.offline;
        final isWeak = connectionStatus == ConnectionStatus.weak;

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark ? Colors.white : Colors.black87;
        final subTextColor = isDark ? Colors.white70 : Colors.black54;
        final borderColor = isDark ? Colors.white24 : Colors.black12;

        if (!isOffline && !isWeak && pendingCount == 0) {
          return const SizedBox.shrink();
        }

        Color bannerColor = isDark ? Colors.orangeAccent.withValues(alpha: 0.15) : Colors.orange.withValues(alpha: 0.2);
        String label = "Weak connection speed";
        IconData icon = Icons.signal_wifi_bad_outlined;

        if (isOffline) {
          bannerColor = isDark ? Colors.redAccent.withValues(alpha: 0.15) : Colors.red.withValues(alpha: 0.2);
          label = "Offline Mode active";
          icon = Icons.cloud_off_outlined;
        } else if (pendingCount > 0) {
          bannerColor = isDark ? Colors.tealAccent.withValues(alpha: 0.15) : Colors.teal.withValues(alpha: 0.2);
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
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Icon(icon, color: textColor, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                          ),
                        ),
                        if (pendingCount > 0)
                          Text(
                            "$pendingCount pending write operation${pendingCount > 1 ? 's' : ''} saved locally",
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 11,
                              fontFamily: 'Outfit',
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (pendingCount > 0 && !isOffline)
                    IconButton(
                      icon: Icon(
                        Icons.refresh_outlined,
                        color: textColor,
                        size: 20,
                      ),
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
