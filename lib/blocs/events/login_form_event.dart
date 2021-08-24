abstract class LoginFormEvent {}

class EditingLoginForm extends LoginFormEvent {}

class SubmitLoginForm extends LoginFormEvent {
  final String userName, password;
  SubmitLoginForm({required this.userName, required this.password});
}
