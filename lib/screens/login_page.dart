import 'package:authentication_repository/authentication_repository.dart';
import 'package:bluestacks_assignment/blocs/events/login_form_event.dart';
import 'package:bluestacks_assignment/blocs/login_form_bloc.dart';
import 'package:bluestacks_assignment/blocs/states/login_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CircleAvatar(
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                BlocProvider(
                  child: _LoginForm(),
                  create: (context) {
                    return LoginFormBloc(
                      authenticationRepository:
                          RepositoryProvider.of<AuthenticationRepository>(
                              context),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  late TextEditingController userNameInputController;
  late TextEditingController passWordInputController;
  var loginFormKey = GlobalKey<FormState>();
  late _LoginButtonState loginButtonState;

  @override
  void initState() {
    // TODO: implement initState
    userNameInputController = TextEditingController();
    passWordInputController = TextEditingController();
    loginButtonState = _LoginButtonState(
        isEnabled: false, displayText: 'Login', onSubmit: null);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? validateFormEntry(String intentOfInput, String? entry) {
    var errorMessage =
        'The ' + intentOfInput + ' must be between 3 and 11 characters long.';
    if (entry == null) {
      return errorMessage;
    }
    bool isValid = entry.length >= 3 && entry.length <= 13;
    return isValid ? null : errorMessage;
  }

  Widget constructTextInputField(
      {required String intentOfInput,
      required IconData displayIcon,
      bool obscureText = false,
      required TextEditingController inputController}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        validator: (String? newValue) {
          return validateFormEntry(intentOfInput, newValue);
        },
        obscureText: obscureText,
        controller: inputController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          icon: Icon(Icons.person),
          hintText: 'Enter ' + intentOfInput,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emailField = constructTextInputField(
        intentOfInput: 'UserName',
        displayIcon: Icons.person,
        inputController: userNameInputController);
    final passwordField = constructTextInputField(
        intentOfInput: 'Password',
        displayIcon: Icons.password,
        inputController: passWordInputController,
        obscureText: true);

    return BlocListener<LoginFormBloc, LoginFormState>(
      listener: (context, state) {
        if (state.isBusy) {
          setState(() {
            loginButtonState.isEnabled = false;
            loginButtonState.displayText = 'Logging In...';
          });
        }
        else {
          var isSubmissionSuccessful = state.submissionSuccess;
          if (isSubmissionSuccessful != null && isSubmissionSuccessful) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => AppView(title: 'whaaaattt')));
          }
        }
      },
      child: Form(
        key: loginFormKey,
        onChanged: () {
          var currentFormState = loginFormKey.currentState;
          if (currentFormState != null) {
            var isFormValid = currentFormState.validate();
            setState(() {
              loginButtonState.displayText = 'Login';
              if (isFormValid) {
                loginButtonState.isEnabled = true;
                loginButtonState.onSubmit = onFormSubmit;
              } else {
                loginButtonState.isEnabled = false;
                loginButtonState.onSubmit = null;
              }
            });
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            emailField,
            passwordField,
            _LoginSubmitButton(
              loginButtonState: loginButtonState,
            ),
          ],
        ),
      ),
    );
  }

  void onFormSubmit() {
    context.read<LoginFormBloc>().add(SubmitLoginForm(
        userName: userNameInputController.text,
        password: passWordInputController.text));
  }
}

class _LoginSubmitButton extends StatefulWidget {
  final _LoginButtonState loginButtonState;
  const _LoginSubmitButton({Key? key, required this.loginButtonState})
      : super(key: key);

  @override
  _LoginSubmitButtonState createState() => _LoginSubmitButtonState();
}

class _LoginSubmitButtonState extends State<_LoginSubmitButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          widget.loginButtonState.isEnabled ? Colors.blue : Colors.greenAccent,
      borderRadius: BorderRadius.circular(8.0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: widget.loginButtonState.onSubmit,
        child: Text(
          widget.loginButtonState.displayText,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _LoginButtonState {
  bool isEnabled;
  String displayText;
  VoidCallback? onSubmit;

  _LoginButtonState(
      {required this.isEnabled,
      required this.displayText,
      required this.onSubmit});
}
