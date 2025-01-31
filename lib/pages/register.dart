import 'package:b_mobile/pages/login.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});
  @override
  RegisterUser createState() => RegisterUser();
}

class RegisterUser extends State<Register> {
  bool isVisible = false;
  bool isChecked = false;
  String Terms = "Terms and condtitions goes here.!\nThis is Just a Test.";
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();

  void checkDetails() {
  if (_formKey.currentState!.validate()) {
    // First check: password mismatch
    if (_controller2.text != _controller3.text) {
      // Passwords do not match
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password Mismatch')),
      );
    } else if (!isChecked) {
      // Second check: terms not accepted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept terms and services!')),
      );
    } else {
      // All checks passed: show welcome message
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text('Welcome ${_controller1.text}'),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
    }
  }
}


  void showTermsAndServices() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 600,
            width: 600,
            decoration: const BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(30), topStart: Radius.circular(30)),
                color: Colors.white),
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Center(
                        child: Text(
                          'Terms and Conditions',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          Terms,
                          style: const TextStyle(fontFamily: 'GowunBatang'),
                        ),
                      )
                    ],
                  ),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 40),
              Center(
                  child: Container(
                      width: 250,
                      height: 250,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('misc/avatar/register.png'),
                              fit: BoxFit.cover)))),
              const Padding(
                  padding: EdgeInsets.all(16),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Create Account',
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
                          validator: (value) {
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
                              hintText: 'Passowrd',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible =
                                          isVisible == false ? true : false;
                                    });
                                  },
                                  icon: Icon(!isVisible
                                      ? Icons.visibility_off
                                      : Icons.remove_red_eye))),
                          style: const TextStyle(fontFamily: 'Inter'),
                          validator: (value) {
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
                          controller: _controller3,
                          obscureText: isVisible ? false : true,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.2),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              prefixIcon: const Icon(Icons.lock),
                              hintText: 'Confirm Password',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible =
                                          isVisible == false ? true : false;
                                    });
                                  },
                                  icon: Icon(!isVisible
                                      ? Icons.visibility_off
                                      : Icons.remove_red_eye))),
                          style: const TextStyle(fontFamily: 'Inter'),
                          validator: (value) {
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
                          controller: _controller4,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.2),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              prefixIcon: const Icon(Icons.person),
                              hintText: 'Nickname'),
                          style: const TextStyle(fontFamily: 'Inter'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please fill in the bar';
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          }),
                      const SizedBox(
                        width: 2,
                      ),
                      const Text('Agree to Terms and Services?'),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () {
                      showTermsAndServices();
                    },
                    child: const Text(
                      'Terms and Services',
                      style: TextStyle(color: Colors.blue, fontSize: 13),
                    ),
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
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ))),
              Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Already have an account?'),
                      TextButton.icon(
                        style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 161, 222, 251))),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        },
                        label: const Text(
                          'Sign in',
                          style: TextStyle(color: Colors.blue),
                        ),
                        icon: const Icon(Icons.login),
                      )
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
