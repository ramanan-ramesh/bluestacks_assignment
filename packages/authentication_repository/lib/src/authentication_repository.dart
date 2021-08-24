import 'dart:async';

import 'package:authentication_repository/src/login_info.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  final _allowedLoginDetails = [
    LoginInfo(userName: '9898989898', passWord: 'password123'),
    LoginInfo(userName: '9876543210', passWord: 'password123')
  ];

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({required LoginInfo loginInfo}) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
      () => _controller.add(_allowedLoginDetails.contains(loginInfo)
          ? AuthenticationStatus.authenticated
          : AuthenticationStatus.unauthenticated),
    );
  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
