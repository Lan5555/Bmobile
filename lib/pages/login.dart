import 'package:b_mobile/pages/register.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<Login> {
  bool isVisible = false;
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _ShowBannar = false;

  void checkDetails() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          content: Text('Welcome ${_controller1.text}'),
          actions: [
            TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                },
                child: const Text('Dismiss'))
          ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Container(
                      width: 250,
                      height: 250,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('misc/avatar/login.png'),
                              fit: BoxFit.cover))),
                ),
                const Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                              fontFamily: 'GowunBatang',
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue),
                        ))),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18)),
                            clipBehavior: Clip.antiAlias,
                            child: TextFormField(
                              controller: _controller1,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.2),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  prefixIcon: const Icon(Icons.mail),
                                  hintText: 'Email'),
                              style: const TextStyle(fontFamily: 'Inter'),
                              // ignore: body_might_complete_normally_nullable
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill in the bar';
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18)),
                            clipBehavior: Clip.antiAlias,
                            child: TextFormField(
                              controller: _controller2,
                              obscureText: isVisible ? false : true,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.2),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isVisible =
                                              isVisible == false ? true : false;
                                        });
                                      },
                                      icon: Icon(!isVisible
                                          ? Icons.visibility_off
                                          : Icons.remove_red_eye)),
                                  hintText: 'Password'),
                              style: const TextStyle(fontFamily: 'Inter'),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill in the bar';
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.blue)),
                          onPressed: () {
                            checkDetails();
                          },
                          label: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: const Icon(
                            Icons.login,
                            color: Colors.white,
                          ),
                        ))),
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Dont have an account?'),
                        TextButton.icon(
                          style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Color.fromARGB(255, 161, 222, 251))),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register()));
                          },
                          label: const Text(
                            'Register',
                            style: TextStyle(color: Colors.blue),
                          ),
                          icon: const Icon(Icons.app_registration),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
