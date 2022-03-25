import 'package:college_social_network/responsive.dart';
import 'package:college_social_network/utils/constants.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignUpMode = false;

  final GlobalKey _key = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Form(
      key: _key,
      child: Container(
        height: _size.height - (120),
        width: Responsive.isDesktop(context)
            ? _size.width / 3
            : Responsive.isTablet(context)
                ? _size.width / 2
                : _size.width / 1.2,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            margin: Responsive.isMobile(context)
                ? EdgeInsets.all(kDefaultPadding / 4)
                : EdgeInsets.all(kDefaultPadding),
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 1.5, vertical: kDefaultPadding),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 22,
                  color: Colors.black.withOpacity(0.07),
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CrossFade(
                  showSecond: isSignUpMode,
                  firstWidget: Text(
                    "Sign In",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                  secondWidget: Text(
                    "Getting Started",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                ),
                const SizedBox(height: kDefaultPadding / 4),
                CrossFade(
                    firstWidget: Text(
                      "Welcome back, you've been missed!",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    secondWidget: Text(
                      "Create an account to connect with friends",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    showSecond: isSignUpMode),
                const SizedBox(height: kDefaultPadding * 2),
                TextFormField(
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
                  decoration: InputDecoration(
                      hintText: isSignUpMode ? "Your email" : "name@knit.ac.in",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.alternate_email_rounded)),
                ),
                if (isSignUpMode) const SizedBox(height: kDefaultPadding),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isSignUpMode ? 60 : 0,
                  child: TextFormField(
                    controller: _nameController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please enter your name';
                      }
                      if (val.trim().length < 6) {
                        return 'Please enter valid/full name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: !isSignUpMode ? null : "Your Name",
                        border: !isSignUpMode
                            ? InputBorder.none
                            : const OutlineInputBorder(),
                        prefixIcon: !isSignUpMode
                            ? null
                            : const Icon(Icons.face_outlined)),
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                TextFormField(
                  controller: _passwordController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: "********",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline_rounded)),
                ),
                const SizedBox(height: kDefaultPadding / 2),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isSignUpMode ? 0 : 20,
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
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {},
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CrossFade(
                          showSecond: isSignUpMode,
                          firstWidget: const Text(
                            "Sign In",
                            style: TextStyle(letterSpacing: 1.2, fontSize: 16),
                          ),
                          secondWidget: const Text(
                            "Sign Up",
                            style: TextStyle(letterSpacing: 1.2, fontSize: 16),
                          ),
                        )),
                  ),
                ),
                const SizedBox(height: kDefaultPadding / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: CrossFade(
                        showSecond: isSignUpMode,
                        firstWidget: const Text(
                          "Already have an account?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        secondWidget: const Text(
                          "Don't have an account?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(width: kDefaultPadding / 2),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSignUpMode = !isSignUpMode;
                        });
                      },
                      child: CrossFade(
                        showSecond: isSignUpMode,
                        firstWidget: const Text(
                          "Sign In",
                          style: TextStyle(letterSpacing: 1.2, fontSize: 16),
                        ),
                        secondWidget: const Text(
                          "Sign Up",
                          style: TextStyle(letterSpacing: 1.2, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
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
