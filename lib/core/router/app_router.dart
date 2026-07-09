import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/home/presentation/main_tab_screen.dart';
import '../../features/movie/presentation/movie_detail_screen.dart';
import '../../features/cinema/presentation/cinema_detail_screen.dart';
import '../../features/transaction/presentation/ticket_history_tab.dart';
import '../../features/transaction/presentation/seat_selection_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const MainTabScreen(),
      ),
      GoRoute(
        path: '/movie/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return MovieDetailScreen(movieId: id);
        },
      ),
      GoRoute(
        path: '/cinema/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return CinemaDetailScreen(cinemaId: id);
        },
      ),
      GoRoute(
        path: '/ticket-history',
        builder: (context, state) => const TicketHistoryTab(),
      ),
      GoRoute(
        path: '/seat-selection',
        builder: (context, state) {
          final movieId = state.uri.queryParameters['movieId'] ?? '';
          final movieTitle = state.uri.queryParameters['movieTitle'] ?? '';
          final cinemaId = state.uri.queryParameters['cinemaId'] ?? '';
          final cinemaName = state.uri.queryParameters['cinemaName'] ?? '';
          final date = state.uri.queryParameters['date'] ?? '';
          final time = state.uri.queryParameters['time'] ?? '';
          final classType = state.uri.queryParameters['classType'] ?? '';
          final qty = int.tryParse(state.uri.queryParameters['qty'] ?? '1') ?? 1;
          final price = double.tryParse(state.uri.queryParameters['price'] ?? '50000') ?? 50000.0;

          return SeatSelectionScreen(
            movieId: movieId,
            movieTitle: movieTitle,
            cinemaId: cinemaId,
            cinemaName: cinemaName,
            date: date,
            time: time,
            classType: classType,
            qty: qty,
            price: price,
          );
        },
      ),
    ],
  );
});
