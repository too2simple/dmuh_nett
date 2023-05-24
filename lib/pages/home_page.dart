import 'dart:async';

import 'package:dmuh_net/bloc/home_page_bloc.dart';
import 'package:dmuh_net/bloc/home_page_event.dart';
import 'package:dmuh_net/bloc/home_page_state.dart';
import 'package:dmuh_net/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl_phone_field/intl_phone_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _loginController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _issueController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _homePageBloc = HomePageBloc();
  bool isButtonDisable = false;
  int _timeLeft = 5;
  final moonLanding = DateTime.now().toString();

  @override
  void dispose() {
    _homePageBloc.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _homePageBloc.inputEventSink.add(LoadData());
  }

  void _initLoginData() async {
    final String? loginData = await Helper.getLogin();
    _loginController.text = loginData ?? '';
  }

  void _initPhoneNumberData() async {
    final String? phoneNumberData = await Helper.getPhoneNumber();
    _phoneNumberController.text = phoneNumberData ?? '';
  }

  String _formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  void _isPressed() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          isButtonDisable = true;
          _timeLeft--;
        });
      } else {
        setState(() {
          _timeLeft = 5;
          isButtonDisable = false;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: StreamBuilder(
            stream: _homePageBloc.outputStateStream,
            initialData: HomePageState(),
            builder: (context, snapshot) {
              if (snapshot.data?.successText != null) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(snapshot.data!.successText!),
                    ),
                  );
                  _issueController.clear();
                });
              }
              if (snapshot.data?.errorText != null) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (timeStamp) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(snapshot.data!.errorText!),
                      ),
                    );
                  },
                );
              }
              if (snapshot.data?.isLoading ?? true) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_loginController.text.isEmpty &&
                  _phoneNumberController.text.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  _loginController.text = snapshot.data?.login ?? '';
                  if (snapshot.data?.phoneNumber != '') {
                    _phoneNumberController.text =
                        snapshot.data?.phoneNumber.substring(4) ?? '';
                  }
                });
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 20),
                  TextFormField(
                    maxLength: 8,
                    controller: _loginController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      errorText: snapshot.data?.loginError,
                      labelText: 'Логін',
                      fillColor: Colors.white70,
                      filled: true,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return " Введіть ваший логін";
                      return null;
                    },
                    onChanged: (value) {
                      _homePageBloc.inputEventSink.add(LoginEvent(value));
                      Helper.saveLogin(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  IntlPhoneField(
                    invalidNumberMessage: "Невірний номер телефону",

                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    countries: const ['UA'],
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      errorText: snapshot.data?.phoneNumberError,
                      labelText: 'Номер телефону',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    onChanged: (value) {
                      _homePageBloc.inputEventSink
                          .add(PhoneNumberEvent(value.completeNumber));
                      Helper.savePhoneNumber(value.completeNumber);
                    },

                    // initialCountryCode: 'UA',
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.deny("  ")
                    ],
                    controller: _issueController,
                    decoration: InputDecoration(
                      errorText: snapshot.data?.issueError,
                      labelText: 'Опишіть проблему',
                      fillColor: Colors.white70,
                      filled: true,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true)
                        return "Текст надто короткий";
                      return null;
                    },
                    onChanged: (value) {
                      _homePageBloc.inputEventSink.add(IssueEvent(value));
                    },
                  ),
                  // const Spacer(),
                  Visibility(
                    visible: snapshot.data?.visibilityTimer ?? true,
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                              'Наступну заявку можна буде відправити через:'),
                          const SizedBox(height: 8),
                          Text(
                            _formatTime(snapshot.data?.timer ?? 0),
                            style: TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),
                  ElevatedButton(
                    onPressed: snapshot.data?.isAllFieldsValid ?? false
                        ? () {
                            _homePageBloc.inputEventSink
                                .add(SendMessageEvent());

                            setState(() {});
                          }
                        : null,
                    child: const Text('Надіслати'),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
