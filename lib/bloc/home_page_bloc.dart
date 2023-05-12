import 'dart:async';
import 'package:dmuh_net/bloc/home_page_event.dart';
import 'package:dmuh_net/shared_pref.dart';
import 'home_page_state.dart';
import 'package:http/http.dart' as http;

class HomePageBloc {
  var _state = HomePageState();
  final _inputEventController = StreamController<HomePageEvent>();
  StreamSink<HomePageEvent> get inputEventSink => _inputEventController.sink;

  final _outputStateController = StreamController<HomePageState>();

  Stream<HomePageState> get outputStateStream => _outputStateController.stream;
  HomePageBloc() {
    _inputEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(HomePageEvent event) async {
    if (event is LoadData) {
      final login = await Helper.getLogin();
      final phone = await Helper.getPhoneNumber();

      final sendMessageTime = await Helper.getCurrentTime();
      _state = _state.copyWith(
        login: login,
        phoneNumber: phone,
        isLoading: false,
      );
      if (sendMessageTime != null) {
        final dateTime = DateTime.parse(sendMessageTime);
        final difference = DateTime.now().difference(dateTime).inSeconds;
        if (difference < 7200) {
          _startCountDown();
        }
      }
      // if (timer == null) {
      // } else {
      //   _startCountDown(timeLeft: timer);
      // }
    }
    if (event is LoginEvent) {
      if (event.login.isEmpty) {
        _state = _state.copyWith(
            login: event.login, loginError: " Введіть ваший логін");
      } else {
        _state = _state.copyWith(login: event.login, loginError: null);
      }
    } else if (event is PhoneNumberEvent) {
      if (event.phoneNumber.length != 13) {
        _state = _state.copyWith(
            phoneNumber: event.phoneNumber,
            phoneNumberError: "Невірний номер телефону");
      } else {
        _state = _state.copyWith(
            phoneNumber: event.phoneNumber, phoneNumberError: null);
      }
    } else if (event is IssueEvent) {
      if (event.issue.isEmpty) {
        _state = _state.copyWith(
            issue: event.issue, issueError: "Текст надто короткий");
      } else {
        _state = _state.copyWith(issue: event.issue, issueError: null);
      }
    } else if (event is SendMessageEvent) {
      //https://api.telegram.org/bot1839504780:AAG-MeLH_SWwADfUAfp53Lo72tGA0EhXCiU/sendMessage?chat_id=-1001478942370&text=HELLO_WORLD
      var url = Uri.https('api.telegram.org',
          '/bot1839504780:AAG-MeLH_SWwADfUAfp53Lo72tGA0EhXCiU/sendMessage', {
        'chat_id': '-1001478942370',
        'text':
            "Логін: ${_state.login}\n Телефон: ${_state.phoneNumber}\n Проблема: ${_state.issue.trim()}"
      });
      try {
        var response = await http.get(url);

        if (response.statusCode == 200) {
          Helper.saveCurrentTime(DateTime.now().toIso8601String());
          _state = _state.copyWith(
            successText:
                "Заявку надіслано, найближчим часом з вами зв'яжеться майстер.",
            issue: '',
          );
          _startCountDown();
        } else {
          _state = _state.copyWith(
              errorText:
                  'Помилка, не вдалося відправити зявку. Спробуйте пізніше.');
        }
      } catch (e) {
        _state = _state.copyWith(errorText: 'Проблема з доступом до інтернету');
      }
    }
    _outputStateController.sink.add(_state);
  }

  void dispose() {
    _inputEventController.close();
    _outputStateController.close();
  }

  void _startCountDown() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      final sendMessageTime = await Helper.getCurrentTime();
      if (sendMessageTime != null) {
        final dateTime = DateTime.parse(sendMessageTime);
        final difference = DateTime.now().difference(dateTime).inSeconds;
        int timeLeft = 7200 - difference;
        if (timeLeft >= 0) {
          _state = _state.copyWith(
              timer: timeLeft, successText: null, visibilityTimer: true);
          Helper.saveStateTimer(_state.timer);
        } else {
          timer.cancel();
          _state = _state.copyWith(visibilityTimer: false);
        }
      }
      _outputStateController.sink.add(_state);
    });
  }
}
