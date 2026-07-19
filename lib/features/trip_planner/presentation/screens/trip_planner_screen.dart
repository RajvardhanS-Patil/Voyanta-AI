import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyanta_ai/core/ux/voyanta_button.dart';
import 'package:voyanta_ai/core/services/trip_config_provider.dart';
import 'package:voyanta_ai/core/services/weather_provider.dart';
import 'package:voyanta_ai/features/journey/presentation/controllers/journey_controller.dart';
import 'package:voyanta_ai/features/trip_planner/presentation/controllers/trip_planner_providers.dart';
import 'package:voyanta_ai/features/trip_planner/domain/entities/trip_itinerary.dart';
import 'package:voyanta_ai/core/utils/city_search.dart';

import 'package:voyanta_ai/core/ux/animated_background.dart';

class TripPlannerScreen extends ConsumerStatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  ConsumerState<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends ConsumerState<TripPlannerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _daysController = TextEditingController(text: '3');
  final _interestsController = TextEditingController();
  String _budgetLevel = 'Moderate';

  final List<String> _budgetOptions = ['Budget', 'Moderate', 'Luxury'];

  @override
  void initState() {
    super.initState();
    // Auto-fill destination from home page if set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dest = ref.read(tripConfigProvider);
      if (dest.isNotEmpty) {
        _destinationController.text = dest;
      }
    });
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _daysController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  Future<void> _generateItinerary() async {
    if (!_formKey.currentState!.validate()) return;

    ref.read(tripPlannerStateProvider.notifier).setLoading();

    try {
      final useCase = ref.read(generateItineraryUseCaseProvider);

      final numDays = int.tryParse(_daysController.text.trim()) ?? 3;
      final destination = _destinationController.text.trim();
      final interests = _interestsController.text.trim().isEmpty
          ? 'general sightseeing, food, culture'
          : _interestsController.text.trim();

      final itineraries = await useCase
          .call(
            destination: destination,
            numDays: numDays,
            interests: interests,
            budgetLevel: _budgetLevel,
          )
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () => throw Exception(
              'AI took too long to respond. Please check your internet connection and try again.',
            ),
          );

      if (!mounted) {
        // Still update provider state so next visit shows correct state
        ref.read(tripPlannerStateProvider.notifier).setData();
        if (itineraries.isNotEmpty) {
          ref
              .read(generatedItinerariesProvider.notifier)
              .setItineraries(itineraries);
        }
        return;
      }

      if (itineraries.isNotEmpty) {
        ref
            .read(generatedItinerariesProvider.notifier)
            .setItineraries(itineraries);
        ref
            .read(journeyControllerProvider.notifier)
            .startJourney(itineraries.first);
        ref.read(tripConfigProvider.notifier).setDestination(destination);
      }

      ref.read(tripPlannerStateProvider.notifier).setData();
    } catch (e, st) {
      // Always reset loading state, even if unmounted
      ref.read(tripPlannerStateProvider.notifier).setError(e, st);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll('Exception: ', ''),
              style: const TextStyle(fontSize: 13),
            ),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripPlannerStateProvider);
    final itineraries = ref.watch(generatedItinerariesProvider);
    final isLoading = state.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtextColor = isDark ? Colors.white70 : const Color(0xFF475569);
    final cardColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.white;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final accentColor = isDark ? Colors.tealAccent : const Color(0xFF0D9488);

    // If itineraries exist, show structured plan view
    if (itineraries.isNotEmpty) {
      return AnimatedBackground(
        child: _buildStructuredPlan(
          itineraries,
          isDark,
          textColor,
          subtextColor,
          cardColor,
          bgColor,
          accentColor,
        ),
      );
    }

    // Otherwise, show the input form
    return Scaffold(
      backgroundColor: bgColor,
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'AI Trip Planner',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Where do you want to go?',
                style: TextStyle(color: subtextColor, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return searchCities(textEditingValue.text, maxResults: 20);
                },
                onSelected: (String selection) {
                  _destinationController.text = selection;
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {
                  // Bind the external controller to the field's controller initially
                  if (fieldTextEditingController.text.isEmpty && _destinationController.text.isNotEmpty) {
                    fieldTextEditingController.text = _destinationController.text;
                  }
                  
                  // Listen to changes to keep our _destinationController in sync
                  fieldTextEditingController.addListener(() {
                    _destinationController.text = fieldTextEditingController.text;
                  });

                  return TextFormField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    style: TextStyle(color: textColor),
                    decoration: _inputDecoration(
                      'Destination (e.g. Goa, India)',
                      isDark,
                    ),
                    validator: (val) => val == null || val.trim().isEmpty
                        ? 'Please enter a destination'
                        : null,
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 48, // Padding minus 24*2
                        height: 200,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                title: Text(
                                  option,
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How many days?',
                          style: TextStyle(color: subtextColor, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _daysController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: textColor),
                          decoration: _inputDecoration('Days', isDark),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Required';
                            final days = int.tryParse(val);
                            if (days == null || days < 1 || days > 14) {
                              return '1 - 14';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budget Level',
                          style: TextStyle(color: subtextColor, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.black.withValues(alpha: 0.1),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _budgetLevel,
                              dropdownColor: isDark
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              isExpanded: true,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: accentColor,
                              ),
                              style: TextStyle(color: textColor),
                              items: _budgetOptions.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  setState(() => _budgetLevel = newValue);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'What are your interests?',
                style: TextStyle(color: subtextColor, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _interestsController,
                maxLines: 3,
                style: TextStyle(color: textColor),
                decoration: _inputDecoration(
                  'e.g. Beaches, Temples, Local Street Food...',
                  isDark,
                ),
              ),

              // Live weather preview
              _buildWeatherPreview(
                isDark,
                cardColor,
                textColor,
                subtextColor,
                accentColor,
              ),

              const SizedBox(height: 32),

              if (isLoading)
                Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: accentColor),
                      const SizedBox(height: 16),
                      Text(
                        'Gemini AI is crafting your perfect itinerary...',
                        style: TextStyle(color: accentColor),
                      ),
                    ],
                  ),
                )
              else
                VoyantaButton(
                  label: 'Generate Itinerary',
                  onPressed: _generateItinerary,
                ),
            ],
          ),
        ),
      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStructuredPlan(
    List<TripItinerary> itineraries,
    bool isDark,
    Color textColor,
    Color subtextColor,
    Color cardColor,
    Color bgColor,
    Color accentColor,
  ) {
    final destination = ref.watch(tripConfigProvider);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              destination.isNotEmpty ? destination : 'Your Trip Plan',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
                fontSize: 18,
              ),
            ),
            Text(
              '${itineraries.length} day${itineraries.length > 1 ? 's' : ''} planned',
              style: TextStyle(color: subtextColor, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: accentColor),
            tooltip: 'Regenerate',
            onPressed: () {
              ref.read(generatedItinerariesProvider.notifier).clear();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: itineraries.length + 1, // +1 for weather header
        itemBuilder: (context, index) {
          // First item is the weather banner
          if (index == 0) {
            return _buildWeatherPreview(
              isDark,
              cardColor,
              textColor,
              subtextColor,
              accentColor,
            );
          }
          final day = itineraries[index - 1];
          return _DayCard(
            day: day,
            isDark: isDark,
            textColor: textColor,
            subtextColor: subtextColor,
            cardColor: cardColor,
            accentColor: accentColor,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (itineraries.isNotEmpty) {
            ref
                .read(journeyControllerProvider.notifier)
                .startJourney(itineraries.first);
            context.go('/');
          }
        },
        backgroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
        foregroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        elevation: 8,
        icon: Icon(
          Icons.play_arrow_rounded, 
          color: isDark ? const Color(0xFF0F172A) : Colors.white, 
          size: 28,
        ),
        label: Text(
          'Start Journey',
          style: TextStyle(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, bool isDark) {
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.1);
    final accentColor = isDark ? Colors.tealAccent : const Color(0xFF0D9488);

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black38),
      filled: true,
      fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accentColor),
      ),
    );
  }

  Widget _buildWeatherPreview(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color subtextColor,
    Color accentColor,
  ) {
    final weatherAsync = ref.watch(destinationWeatherProvider);
    final destination = ref.watch(tripConfigProvider);

    if (destination.isEmpty) return const SizedBox.shrink();

    return weatherAsync.when(
      loading: () => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: accentColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Loading weather for $destination...',
              style: TextStyle(color: subtextColor, fontSize: 13),
            ),
          ],
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (weather) {
        if (weather == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color(0xFF0D9488).withValues(alpha: 0.15),
                      const Color(0xFF7C3AED).withValues(alpha: 0.08),
                    ]
                  : [
                      const Color(0xFF0D9488).withValues(alpha: 0.08),
                      const Color(0xFF7C3AED).withValues(alpha: 0.04),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accentColor.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(weather.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Live Weather in ${weather.locationName}',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          weather.description,
                          style: TextStyle(color: subtextColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${weather.temperatureC.round()}°C',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _WeatherChip(
                    icon: Icons.thermostat_outlined,
                    label: 'Feels ${weather.feelsLikeC.round()}°C',
                    color: accentColor,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _WeatherChip(
                    icon: Icons.water_drop_outlined,
                    label: '${weather.humidity}%',
                    color: accentColor,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _WeatherChip(
                    icon: Icons.air,
                    label: '${weather.windSpeedKmh.round()} km/h',
                    color: accentColor,
                    isDark: isDark,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WeatherChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;

  const _WeatherChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Day Card Widget ─────────────────────────────────────────────
class _DayCard extends StatelessWidget {
  final TripItinerary day;
  final bool isDark;
  final Color textColor;
  final Color subtextColor;
  final Color cardColor;
  final Color accentColor;

  const _DayCard({
    required this.day,
    required this.isDark,
    required this.textColor,
    required this.subtextColor,
    required this.cardColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          childrenPadding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 16,
          ),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                'D${day.dayNumber}',
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          title: Text(
            day.theme,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Outfit',
            ),
          ),
          subtitle: Text(
            '${day.activities.length} activities',
            style: TextStyle(color: subtextColor, fontSize: 12),
          ),
          children: day.activities.map((activity) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time badge
                  Container(
                    width: 72,
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      activity.time,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.place, size: 14, color: accentColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                activity.title,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activity.description,
                          style: TextStyle(
                            color: subtextColor,
                            fontSize: 12,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      ),
    );
  }
}
