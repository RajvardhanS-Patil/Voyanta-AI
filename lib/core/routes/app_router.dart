import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/journey/presentation/screens/live_journey_screen.dart';
import '../../features/companion/presentation/screens/companion_screen.dart';
import '../../features/expenses/presentation/screens/expense_dashboard_screen.dart';
import '../../features/trip_planner/presentation/screens/trip_planner_screen.dart';
import '../widgets/dashboard_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // NOTE: Keeping it open for easy testing if auth is mocked
      // final isAuth = authState.value != null;
      // final isLoggingIn = state.uri.path == '/login';
      // if (!isAuth && !isLoggingIn) return '/login';
      // if (isAuth && isLoggingIn) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return DashboardScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const LiveJourneyScreen(),
          ),
          GoRoute(
            path: '/companion',
            builder: (context, state) => const CompanionScreen(),
          ),
          GoRoute(
            path: '/expenses',
            builder: (context, state) => const ExpenseDashboardScreen(),
          ),
          GoRoute(
            path: '/planner',
            builder: (context, state) => const TripPlannerScreen(),
          ),
          // TODO: Add other feature screens
        ],
      ),
    ],
  );
});
