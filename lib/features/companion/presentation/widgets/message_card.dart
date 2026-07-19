import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:voyanta_ai/features/companion/domain/entities/chat_message.dart';

class MessageCard extends StatelessWidget {
  final ChatMessage message;

  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final userBgColor = isDark ? const Color(0xFF5A3EAB).withValues(alpha: 0.25) : Colors.deepPurple.withValues(alpha: 0.15);
    final userBorderColor = isDark ? const Color(0xFF5A3EAB).withValues(alpha: 0.6) : Colors.deepPurple.withValues(alpha: 0.3);
    
    final aiBgColor = isDark ? const Color(0xFF1E293B).withValues(alpha: 0.45) : Colors.white.withValues(alpha: 0.85);
    final aiBorderColor = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.1);
    
    final textColor = isDark ? Colors.white : Colors.black87;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? userBgColor : aiBgColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                border: Border.all(
                  color: isUser ? userBorderColor : aiBorderColor,
                  width: 1,
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'Inter',
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
