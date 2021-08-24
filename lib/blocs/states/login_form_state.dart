class LoginFormState {
  final bool isBusy;
  final bool? submissionSuccess;
  final String? errorMessage;
  LoginFormState({
    this.isBusy: false,
    this.errorMessage,
    this.submissionSuccess,
  });
}
