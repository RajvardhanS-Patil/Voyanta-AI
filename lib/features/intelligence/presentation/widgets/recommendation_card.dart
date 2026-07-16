import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:voyanta_ai/features/intelligence/domain/entities/travel_recommendation.dart';

class RecommendationCard extends StatelessWidget {
  final TravelRecommendation recommendation;

  const RecommendationCard({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    Color accentColor = Colors.tealAccent;
    IconData icon = Icons.star_border;

    switch (recommendation.type) {
      case RecommendationType.weather:
        accentColor = const Color(0xFFF87171); // Coral Red
        icon = Icons.cloudy_snowing;
        break;
      case RecommendationType.budget:
        accentColor = recommendation.severity == AlertSeverity.critical
            ? const Color(0xFFEF4444)
            : const Color(0xFFFBBF24); // Amber
        icon = Icons.account_balance_wallet_outlined;
        break;
      case RecommendationType.schedule:
        accentColor = const Color(0xFFFBBF24);
        icon = Icons.schedule;
        break;
      case RecommendationType.food:
        accentColor = Colors.tealAccent;
        icon = Icons.restaurant_menu;
        break;
      case RecommendationType.safety:
        accentColor = Colors.orangeAccent;
        icon = Icons.security;
        break;
      case RecommendationType.transit:
        accentColor = Colors.tealAccent;
        icon = Icons.directions_walk;
        break;
      case RecommendationType.nearby:
        accentColor = const Color(0xFFD8B4FE); // Lavender
        icon = Icons.location_searching;
        break;
    }

    return Container(
      width: 270,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withValues(alpha: 0.5), // Slate obsidian glass
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accentColor.withValues(alpha: 0.25)),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.05),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(icon, color: accentColor, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recommendation.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Outfit',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    recommendation.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontFamily: 'Inter',
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (recommendation.actionLabel != null) ...[
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      recommendation.actionLabel!,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
