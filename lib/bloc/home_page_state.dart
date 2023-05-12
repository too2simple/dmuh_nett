class HomePageState {
  final String login;
  final String phoneNumber;
  final String issue;
  final String? loginError;
  final String? phoneNumberError;
  final String? issueError;
  final String? errorText;
  final String? successText;
  final bool isLoading;
  bool isPressed;
  final int timer;
  bool visibilityTimer;
  var dateTime;

  HomePageState({
    this.login = '',
    this.phoneNumber = '',
    this.issue = '',
    this.loginError,
    this.phoneNumberError,
    this.issueError,
    this.errorText,
    this.successText,
    this.isLoading = true,
    this.isPressed = false,
    this.timer = 0,
    this.visibilityTimer = false,
    this.dateTime,
  });
  bool get isAllFieldsValid =>
      login.isNotEmpty &&
      phoneNumber.isNotEmpty &&
      issue.trim().isNotEmpty &&
      loginError == null &&
      phoneNumberError == null &&
      issueError == null &&
      timer <= 0;

  HomePageState copyWith({
    String? login,
    String? phoneNumber,
    String? issue,
    String? loginError,
    String? phoneNumberError,
    String? issueError,
    String? errorText,
    String? successText,
    bool? isLoading,
    bool? isPressed,
    int? timer,
    bool? visibilityTimer,
    var dateTime,
  }) {
    return HomePageState(
      login: login ?? this.login,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      issue: issue ?? this.issue,
      loginError: loginError,
      phoneNumberError: phoneNumberError,
      issueError: issueError,
      errorText: errorText,
      successText: successText,
      isLoading: isLoading ?? this.isLoading,
      isPressed: isPressed ?? this.isPressed,
      timer: timer ?? this.timer,
      visibilityTimer: visibilityTimer ?? this.visibilityTimer,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
