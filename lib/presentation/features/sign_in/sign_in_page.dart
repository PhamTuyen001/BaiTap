import 'package:appp_sale_29092022/common/bases/base_widget.dart';
import 'package:appp_sale_29092022/common/utils/extension.dart';
import 'package:appp_sale_29092022/common/widgets/loading_widget.dart';
import 'package:appp_sale_29092022/common/widgets/progress_listener_widget.dart';
import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/repositories/authentication_repository.dart';
import 'package:appp_sale_29092022/presentation/features/sign_in/sign_in_bloc.dart';
import 'package:appp_sale_29092022/presentation/features/sign_in/sign_in_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      providers: [
        Provider(create: (context) => ApiRequest()),
        ProxyProvider<ApiRequest, AuthenticationRepository>(
          create: (context) => AuthenticationRepository(),
          update: (context, request, repository) {
            repository?.updateApiRequest(request);
            return repository!;
          },
        ),
        ProxyProvider<AuthenticationRepository, SignInBloc>(
          create: (context) => SignInBloc(),
          update: (context, repository, bloc) {
            bloc?.updateAuthenRepo(repository);
            return bloc!;
          },
        )
      ],
      child: _SignInContainer(),
    );
  }
}

class _SignInContainer extends StatefulWidget {
  const _SignInContainer({Key? key}) : super(key: key);

  @override
  State<_SignInContainer> createState() => _SignInContainerState();
}

class _SignInContainerState extends State<_SignInContainer> {

  late SignInBloc bloc;
  late TextEditingController emailController, passwordController;

  @override
  void initState() {
    super.initState();
    bloc = context.read();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    flex: 2, child: Image.asset("assets/images/ic_hello_food.png")),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildEmailTextField(emailController),
                        _buildPasswordTextField(passwordController),
                        _buildButtonSignIn(onPress: () {
                          String email = emailController.text.toString();
                          String password = passwordController.text.toString();

                          if (email.isEmpty || password.isEmpty) {
                            showMessage(
                                context,
                                "Message",
                                "Input is not empty",
                                [
                                  TextButton(onPressed: () {
                                    Navigator.pop(context);
                                  }, child: Text("ok"))
                                ]
                            );
                            return;
                          }

                          bloc.eventSink.add(SignInEvent(email: email, password: password));
                        })
                      ],
                    ),
                  ),
                ),
                Expanded(child: _buildTextSignUp(function: () {
                  Navigator
                      .pushNamed(context, "sign-up")
                      .then((value){
                        if (value != null) {
                          emailController.text = (value as List)[0];
                          passwordController.text = (value as List)[1];
                        }
                      })
                      .catchError((error) {
                         print(error);
                      });
                }))
              ],
            ),
            LoadingWidget(
              bloc: bloc,
              child: Container(),
            ),
            ProgressListenerWidget<SignInBloc>(
              child: Container(),
              callback: (event) {
                switch (event.runtimeType) {
                  case SignInSuccessEvent:
                    showSnackBar(context, "Đăng nhập thành công");
                    emailController.clear();
                    passwordController.clear();
                    Navigator.pushReplacementNamed(context, "home");
                    break;
                  case SignInFailEvent:
                    showSnackBar(context, (event as SignInFailEvent).message);
                    break;
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextSignUp({Function()? function}) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account!"),
            InkWell(
              onTap: function,
              child: Text("Sign Up",
                  style: TextStyle(
                      color: Colors.red, decoration: TextDecoration.underline)),
            )
          ],
        ));
  }

  Widget _buildEmailTextField(TextEditingController emailController) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          hintText: "Email",
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          prefixIcon: Icon(Icons.email, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(TextEditingController passwordController) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: passwordController,
        obscureText: true,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          fillColor: Colors.black12,
          filled: true,
          hintText: "PassWord",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 0, color: Colors.black12)),
          labelStyle: TextStyle(color: Colors.blue),
          prefixIcon: Icon(Icons.lock, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildButtonSignIn({Function? onPress = null}) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: ElevatedButtonTheme(
            data: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.blue[500];
                    } else if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return Colors.blueAccent;
                  }),
                  elevation: MaterialStateProperty.all(5),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 5, horizontal: 100)),
                )),
            child: ElevatedButton(
              child: Text("Login",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              onPressed: () => onPress?.call(),
            )));
  }
}