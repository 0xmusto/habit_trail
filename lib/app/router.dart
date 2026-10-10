import 'package:go_router/go_router.dart';

import '../features/home/presentaion/screens/home_screen.dart';
import '../features/rewards/presentaion/screens/rewards_screen.dart';
import '../features/tracker/presentaion/screens/create_tracker_screen.dart';
import '../features/tracker/presentaion/screens/tracker_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      name: 'create',
      path: '/create',
      builder: (context, state) => const CreateTrackerScreen(),
    ),
    GoRoute(
      name: 'rewards',
      path: '/rewards',
      builder: (context, state) => const RewardsScreen(),
    ),
    GoRoute(
      name: 'tracker',
      path: '/tracker/:id',
      builder: (context, state) =>
          TrackerScreen(trackerId: int.parse(state.pathParameters['id']!)),
    ),
  ],
);
