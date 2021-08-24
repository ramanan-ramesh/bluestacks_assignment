import 'package:authentication_repository/authentication_repository.dart';
import 'package:bluestacks_assignment/blocs/authentication_bloc.dart';
import 'package:bluestacks_assignment/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/states/authentication_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (context) {
          return AuthenticationBloc(
              authenticationRepository: authenticationRepository);
        },
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return Container();
                    },
                  ),
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginPage();
                    },
                  ),
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      //onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
