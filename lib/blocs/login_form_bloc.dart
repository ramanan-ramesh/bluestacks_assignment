import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';

import 'events/login_form_event.dart';
import 'states/login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState>
    with ValidationMixin {
  LoginFormBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(LoginFormState());

  final AuthenticationRepository _authenticationRepository;

  @override
  Stream<LoginFormState> mapEventToState(LoginFormEvent event) async* {
    if (event is SubmitLoginForm) {
      yield LoginFormState(isBusy: true);
      await Future.delayed(Duration(seconds: 2));
      try {
        await _authenticationRepository.logIn(
          loginInfo:
              LoginInfo(userName: event.userName, passWord: event.password),
        );
        yield LoginFormState(submissionSuccess: true);
      } on Exception catch (_) {
        yield LoginFormState(submissionSuccess: false);
      }
    }
  }
}

mixin ValidationMixin {
  bool validateFormEntry(String entry) {
    return entry.length >= 3 && entry.length <= 13;
  }
}
