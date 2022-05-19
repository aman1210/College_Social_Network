import '../../responsive.dart';
import '../../utils/constants.dart';
import '../../view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showPassword = false;

  final _key = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    AuthViewModel authViewModel = context.watch<AuthViewModel>();
    return Form(
      key: _key,
      child: Container(
        height: _size.height - (120),
        width: Responsive.isDesktop(context)
            ? _size.width / 3
            : Responsive.isTablet(context)
                ? _size.width / 1.5
                : _size.width / 1.2,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            margin: Responsive.isMobile(context)
                ? const EdgeInsets.all(kDefaultPadding / 4)
                : const EdgeInsets.all(kDefaultPadding),
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.isMobile(context)
                    ? kDefaultPadding
                    : kDefaultPadding * 1.5,
                vertical: kDefaultPadding),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 22,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white10
                      : Colors.black.withOpacity(0.07),
                )
              ],
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xff1a1d22)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Sign In",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : null),
                ),
                const SizedBox(height: kDefaultPadding / 4),
                Text(
                  "Welcome back, you've been missed!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : null),
                ),
                const SizedBox(height: kDefaultPadding * 2),
                TextFormField(
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : null),
                  controller: _emailController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter valid email address';
                    }
                    if (!val.endsWith('knit.ac.in')) {
                      return 'Please enter college email address';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: "name@knit.ac.in",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.alternate_email_rounded)),
                ),
                const SizedBox(height: kDefaultPadding),
                TextFormField(
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : null),
                  controller: _passwordController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  onFieldSubmitted: (val) {
                    if (submit()) {
                      authViewModel.loginUser("");
                    }
                  },
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    hintText: "********",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: GestureDetector(
                      onTapDown: (details) => setState(() {
                        showPassword = true;
                      }),
                      onTapUp: (details) => setState(() {
                        showPassword = false;
                      }),
                      child: const Icon(Icons.remove_red_eye_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: kDefaultPadding / 2),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: Responsive.isMobile(context) ? 40 : 20,
                  child: Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      TextButton(
                          onPressed: () {},
                          child: const Text("Forgot Password?"))
                    ],
                  ),
                ),
                const SizedBox(height: kDefaultPadding / 2),
                _button(context, authViewModel),
                const SizedBox(height: kDefaultPadding),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding,
                        vertical: kDefaultPadding / 2),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.09),
                        borderRadius:
                            BorderRadius.circular(kDefaultPadding / 4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          FontAwesomeIcons.google,
                          color: Colors.blue,
                          size: 20,
                        ),
                        new Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: new Text(
                            "Sign in with Google",
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool submit() {
    if (!_key.currentState!.validate()) {
      return false;
    }
    _key.currentState!.save();

    return true;
  }

  _button(BuildContext context, AuthViewModel authViewModel) {
    if (authViewModel.isLoading) {
      return const CircularProgressIndicator();
    }
    // if (authViewModel.userLoggedIn) {
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
    //     builder: (context) => Scaffold(
    //       body: Center(child: Text("User Logged In")),
    //     ),
    //   ));
    // }
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
            foregroundColor: MaterialStateProperty.all(Colors.white)),
        onPressed: () {
          if (submit()) {
            authViewModel.loginUser("");
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            "Sign In",
            style: TextStyle(letterSpacing: 1.2, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class CrossFade extends StatelessWidget {
  const CrossFade({
    Key? key,
    required this.showSecond,
    required this.firstWidget,
    required this.secondWidget,
  }) : super(key: key);

  final bool showSecond;
  final Widget firstWidget;
  final Widget secondWidget;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: firstWidget,
      secondChild: secondWidget,
      crossFadeState:
          showSecond ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }
}
