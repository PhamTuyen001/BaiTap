import 'package:appp_sale_29092022/common/bases/base_widget.dart';
import 'package:appp_sale_29092022/common/utils/extension.dart';
import 'package:appp_sale_29092022/common/widgets/loading_widget.dart';
import 'package:appp_sale_29092022/common/widgets/progress_listener_widget.dart';
import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';
import 'package:appp_sale_29092022/data/repositories/authentication_repository.dart';
import 'package:appp_sale_29092022/presentation/features/sign_up/sign_up_bloc.dart';
import 'package:appp_sale_29092022/presentation/features/sign_up/sign_up_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SignUpPage extends StatefulWidget {

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        title: const Text("Sign Up"),
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
        ProxyProvider<AuthenticationRepository, SignUpBloc>(
          create: (context) => SignUpBloc(),
          update: (context, repository, bloc) {
            bloc?.updateAuthenRepo(repository);
            return bloc!;
          },
        )
      ],
      child: SignUpContainer(),
    );
  }
}

class SignUpContainer extends StatefulWidget {
  const SignUpContainer({Key? key}) : super(key: key);

  @override
  State<SignUpContainer> createState() => _SignUpContainerState();
}

class _SignUpContainerState extends State<SignUpContainer> {
  late TextEditingController emailController, phoneController, passwordController, addressController, nameController;
  late SignUpBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read();
    emailController = TextEditingController();
    nameController = TextEditingController();
    passwordController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
  }

  void clearTextEdit() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    addressController.clear();
    phoneController.clear();
  }
  
  void signUp() {
    String email = emailController.text.toString();
    String password = passwordController.text.toString();
    String name = nameController.text.toString();
    String phone = phoneController.text.toString();
    String address = addressController.text.toString();
    
    if (isNotEmpty([email, password, name, phone, address])) {
      bloc.eventSink.add(SignUpEvent(name: name, address: address, email: email, phone: phone, password: password));
    } else {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              flex: 2, child: Image.asset("assets/images/ic_hello_food.png")),
          Expanded(
              flex: 4,
              child: LayoutBuilder(
                builder: (context, constraint) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                      BoxConstraints(minHeight: constraint.maxHeight),
                      child: LoadingWidget(
                        bloc: bloc,
                        child: IntrinsicHeight(
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildNameTextField(nameController),
                                  SizedBox(height: 10),
                                  _buildAddressTextField(addressController),
                                  SizedBox(height: 10),
                                  _buildEmailTextField(emailController),
                                  SizedBox(height: 10),
                                  _buildPhoneTextField(phoneController),
                                  SizedBox(height: 10),
                                  _buildPasswordTextField(passwordController),
                                  SizedBox(height: 10),
                                  _buildButtonSignUp(function: signUp)
                                ],
                              ),
                              ProgressListenerWidget<SignUpBloc>(
                                child: Container(),
                                callback: (event) {
                                  if (event is SignUpSuccessEvent) {
                                    showSnackBar(context, "Đăng ký thành công");
                                    clearTextEdit();
                                    Future.delayed(Duration(seconds: 1), () {
                                      Navigator.pop(context, [event.email, event.password]);
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget _buildNameTextField(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Example : Mr. John",
          fillColor: Colors.black12,
          filled: true,
          prefixIcon: Icon(Icons.person, color: Colors.blue),
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
        ),
      ),
    );
  }

  Widget _buildAddressTextField(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Example : district 1",
          fillColor: Colors.black12,
          filled: true,
          prefixIcon: Icon(Icons.map, color: Colors.blue),
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
        ),
      ),
    );
  }

  Widget _buildEmailTextField(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Email : abc@gmail.com",
          fillColor: Colors.black12,
          filled: true,
          prefixIcon: Icon(Icons.email, color: Colors.blue),
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
        ),
      ),
    );
  }

  Widget _buildPhoneTextField(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: controller,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: "Phone ((+84) 123 456 789)",
          fillColor: Colors.black12,
          filled: true,
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
          prefixIcon: Icon(Icons.phone, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        maxLines: 1,
        controller: controller,
        obscureText: true,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: "Pass word",
          fillColor: Colors.black12,
          filled: true,
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
          prefixIcon: Icon(Icons.lock, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildButtonSignUp({Function()? function}) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: ElevatedButtonTheme(
            data: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.blue[500];
                    }
                    return Colors.blueAccent;
                  }),
                  elevation: MaterialStateProperty.all(5),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 5, horizontal: 100)),
                )),
            child: ElevatedButton(
              child: Text("Register",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              onPressed: function,
            )));
  }
}