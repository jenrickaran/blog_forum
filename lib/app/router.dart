import 'package:flutter_app/pages/auth/login_page.dart';
import 'package:flutter_app/pages/home/home.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const Home()),
  ],
);
