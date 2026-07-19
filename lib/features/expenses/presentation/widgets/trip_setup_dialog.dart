import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/expense_providers.dart';

class TripSetupDialog extends ConsumerStatefulWidget {
  const TripSetupDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const TripSetupDialog(),
    );
  }

  @override
  ConsumerState<TripSetupDialog> createState() => _TripSetupDialogState();
}

class _TripSetupDialogState extends ConsumerState<TripSetupDialog> {
  final _budgetController = TextEditingController();
  final _memberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tripMeta = ref.read(tripMetaControllerProvider).value;
      if (tripMeta != null) {
        _budgetController.text = tripMeta.totalBudget.toStringAsFixed(0);
      }
    });
  }

  void _updateBudget() {
    final amt = double.tryParse(_budgetController.text);
    if (amt != null && amt > 0) {
      ref.read(tripMetaControllerProvider.notifier).updateBudget(amt);
    }
  }

  void _addMember() {
    final name = _memberController.text.trim();
    if (name.isNotEmpty) {
      ref.read(tripMetaControllerProvider.notifier).addMember(name);
      _memberController.clear();
    }
  }

  void _removeMember(String name) {
    ref.read(tripMetaControllerProvider.notifier).removeMember(name);
  }

  @override
  Widget build(BuildContext context) {
    final tripMetaAsync = ref.watch(tripMetaControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Trip Setup'),
      content: tripMetaAsync.when(
        loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
        error: (err, st) => Text('Error: $err'),
        data: (tripMeta) {
          return SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Budget', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _budgetController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '₹ ',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _updateBudget,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Trip Members', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _memberController,
                          decoration: const InputDecoration(
                            hintText: 'Name (e.g. Rahul)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Color(0xFF0D9488)),
                        onPressed: _addMember,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: tripMeta.members.map((member) {
                      final isMe = member == 'Me';
                      return Chip(
                        label: Text(member),
                        backgroundColor: isMe ? const Color(0xFF0D9488).withValues(alpha: 0.2) : null,
                        deleteIcon: isMe ? null : const Icon(Icons.close, size: 18),
                        onDeleted: isMe ? null : () => _removeMember(member),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
