import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(' DmuhNet'),
            centerTitle: true,
          ),
          body: MyForm(),
        ),
      ),
    );

class MyForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyFormState();
}

class MyFormState extends State {
  final _loginController = TextEditingController();
  final _issueController = TextEditingController();
  final _foneNumber = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _loginController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(
                labelText: 'Логін',
                fillColor: Colors.white70,
                filled: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) return " Введіть ваший логін";
              },
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 6),
            IntlPhoneField(
              invalidNumberMessage: "Невірний номер телефону",
              controller: _foneNumber,
              countries: ['UA'],
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(
                labelText: 'Номер телефону',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: 'UA',
            ),
            const SizedBox(height: 16),
            TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.deny("  ")
              ],
              controller: _issueController,
              decoration: const InputDecoration(
                labelText: 'Опишіть проблему',
                fillColor: Colors.white70,
                filled: true,
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) {
                if (value?.trim().isEmpty ?? true)
                  return "Текст надто короткий";
              },
            ),
            Spacer(),
            ElevatedButton(
              child: const Text('Надіслати'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  //https://api.telegram.org/bot1839504780:AAG-MeLH_SWwADfUAfp53Lo72tGA0EhXCiU/sendMessage?chat_id=-1001478942370&text=HELLO_WORLD
                  var url = Uri.https(
                      'api.telegram.org',
                      '/bot1839504780:AAG-MeLH_SWwADfUAfp53Lo72tGA0EhXCiU/sendMessage',
                      {
                        'chat_id': '-1001478942370',
                        'text':
                            "Логін: ${_loginController.text}\n Телефон: ${_foneNumber.text}\n Проблема: ${_issueController.text.trim()}"
                      });
                  try {
                    var response = await http.get(url);
                    String message =
                        "Заявку надіслано, найближчим часом з вами зв'яжеться майстер.";

                    if (response.statusCode == 200) {
                      message;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(message),
                        ),
                      );
                      _issueController.clear();
                    } else {
                      message =
                          'Помилка, не вдалося відправити зявку. Спробуйте пізніше.';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(message),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Проблема з доступом до інтернету'),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
