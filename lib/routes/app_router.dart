import 'package:go_router/go_router.dart';
import '../screens/loading_screen.dart';
import '../screens/home_screen.dart';

// Router yapılandırması
final router = GoRouter(
  initialLocation: '/', // Başlangıç rotası
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoadingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) =>
          HomeScreen(), // const yalnızca Stateless ve immutable ise
    ),
  ],
);
