import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/features/companion/presentation/controllers/companion_controller.dart';
import 'package:voyanta_ai/core/ux/shimmer_loader.dart';
import 'package:voyanta_ai/core/ux/empty_state_view.dart';
import 'package:voyanta_ai/core/ux/error_recovery_view.dart';
import '../widgets/context_panel.dart';
import '../widgets/message_card.dart';
import '../widgets/typing_indicator.dart';

class CompanionScreen extends ConsumerStatefulWidget {
  const CompanionScreen({super.key});

  @override
  ConsumerState<CompanionScreen> createState() => _CompanionScreenState();
}

class _CompanionScreenState extends ConsumerState<CompanionScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  final List<String> _suggestions = [
    "🍔 Food suggestions nearby",
    "💰 Check my budget status",
    "🌤️ Should I adjust for weather?",
    "🗺️ Local transit tips"
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    ref.read(companionControllerProvider.notifier).sendMessage(text.trim());
    _textController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(companionControllerProvider);

    // Auto scroll to bottom when new messages arrive
    ref.listen(companionControllerProvider, (previous, next) {
      _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Slate Obsidian Base
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Voyanta AI Companion',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Outfit',
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Floating Smart Context Panel
            const ContextPanel(),
            
            // Chat Message Board
            Expanded(
              child: messagesAsync.when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return const EmptyStateView(
                      icon: Icons.chat_bubble_outline,
                      title: 'How can I help?',
                      description: 'Ask me about your budget, itinerary, or local recommendations.',
                    );
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      if (msg.id == 'typing') {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TypingIndicator(),
                          ),
                        );
                      }
                      return MessageCard(message: msg);
                    },
                  );
                },
                loading: () => ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final isUser = index % 2 == 0;
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ShimmerLoader(
                          child: Container(
                            height: 60,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                error: (err, st) => ErrorRecoveryView(
                  title: 'Companion Unavailable',
                  description: 'Unable to connect to the AI service. Please check your connection.',
                  onRetry: () {
                    ref.invalidate(companionControllerProvider);
                  },
                ),
              ),
            ),

            // Suggestion Chips list
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ActionChip(
                      backgroundColor: const Color(0xFF1E293B),
                      side: const BorderSide(color: Colors.white10),
                      label: Text(
                        suggestion, 
                        style: const TextStyle(color: Colors.tealAccent, fontSize: 12),
                      ),
                      onPressed: () => _send(suggestion),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Interactive Text Entry
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Ask Voyanta anything...',
                          hintStyle: TextStyle(color: Colors.white30),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (val) => _send(val),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _send(_textController.text),
                    child: CircleAvatar(
                      backgroundColor: Colors.tealAccent,
                      radius: 22,
                      child: const Icon(Icons.send, color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
