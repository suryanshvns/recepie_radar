import 'package:flutter/material.dart';
import 'package:recepie_radar/services/auth_service.dart';
import 'package:status_alert/status_alert.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _loginFormKey = GlobalKey();

  String? username, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(child: _buildUI()),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_image(), _title(), _LoginForm(), _loginButton()],
      ),
    );
  }

  Widget _image() {
    return Container(
      width: 200,
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        image: const DecorationImage(
          image: AssetImage('assets/login.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _title() {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        "Recipe Book",
        style: TextStyle(
          fontSize: 35,
          color: Colors.deepOrange,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _LoginForm() {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.90,
        height: MediaQuery.sizeOf(context).height * 0.30,
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextFormField(
                  initialValue: "kminchelle",
                  onSaved: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter a username';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextFormField(
                  initialValue: "0lelplR",
                  obscureText: true,
                  onSaved: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter password';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _loginButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.06,
        child: ElevatedButton(
          onPressed: () async {
            if (_loginFormKey.currentState?.validate() ?? false) {
              _loginFormKey.currentState?.save();
              bool result = await AuthService().login(username!, password!);
              if (result) {
                Navigator.pushReplacementNamed(context, "/home");
              } else {
                StatusAlert.show(
                  context,
                  duration: const Duration(seconds: 2),
                  title: "Login Failed",
                  subtitle: "Please try again",
                  configuration: IconConfiguration(icon: Icons.error),
                  maxWidth: 260,
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
          ),
          child: const Text(
            "Login",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
