import 'package:diu_bus_tracker/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool wrongCred = false;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void auth() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(
      const Duration(seconds: 1),
    );
    if (emailController.text == "admin" && passwordController.text == "admin") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      setState(() {
        wrongCred = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color rong = Color(0xff2196f3);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    LottieBuilder.asset("assets/busAnimated.json"),
                    wrongCred
                        ? const Text(
                            "User Authentication failed.",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          )
                        : Container(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Text(
                        "Email: ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: rong,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: rong,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8,
                        ),
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Text(
                        "Password: ",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: rong,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: rong,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8,
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: auth,
                      style: ElevatedButton.styleFrom(
                        // fixedSize: Size.fromWidth(
                        //   MediaQuery.of(context).size.width / 3,
                        // ),
                        fixedSize: Size(MediaQuery.of(context).size.width / 3, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text("Login"),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
