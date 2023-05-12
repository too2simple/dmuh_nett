abstract class HomePageEvent {}

class LoginEvent extends HomePageEvent {
  final String login;

  LoginEvent(this.login);
}

class PhoneNumberEvent extends HomePageEvent {
  final String phoneNumber;

  PhoneNumberEvent(this.phoneNumber);
}

class IssueEvent extends HomePageEvent {
  final String issue;

  IssueEvent(this.issue);
}

class SendMessageEvent extends HomePageEvent {}

class LoadData extends HomePageEvent {}
