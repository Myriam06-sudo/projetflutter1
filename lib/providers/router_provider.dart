import 'package:projetflutter1/providers/login_controller_provider.dart';
import 'package:projetflutter1/providers/states/login_states.dart';
import 'package:projetflutter1/screens/home_screen.dart';
import 'package:projetflutter1/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);
  return GoRouter(
      debugLogDiagnostics: true,
      refreshListenable: router,
      redirect: router._redirectLogic,
      routes: router._routes);
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<LoginState>(
      loginControllerProvider as AlwaysAliveProviderListenable<LoginState>,
          (_, __) => notifyListeners(),
    );
  }

  String? _redirectLogic(GoRouterState state) {
    final loginState = _ref.read(loginControllerProvider);

    final areWeLoggingIn = state.location == '/login';

    if (loginState is LoginStateInitial) {
      return areWeLoggingIn ? null : '/login';
    }

    if (areWeLoggingIn) return '/';

    return null;
  }

  List<GoRoute> get _routes => [
    GoRoute(
      name: 'login',
      builder: (context, state) => const SignInScreen(),
      path: '/login',
    ),
    GoRoute(
      name: 'home',
      builder: (context, state) => const HomeScreen(title: 'Flutter Demo Home Page'),
      path: '/',
    ),
  ];
}