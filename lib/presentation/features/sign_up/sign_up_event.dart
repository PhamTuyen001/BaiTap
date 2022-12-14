import 'package:appp_sale_29092022/common/bases/base_event.dart';

class SignUpEvent extends BaseEvent {
  late String name, address, email, phone, password;

  SignUpEvent({
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [];

}

class SignUpSuccessEvent extends BaseEvent {
  late String email, password;

  SignUpSuccessEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [];

}

class SignUpFailEvent extends BaseEvent {
  String message;

  SignUpFailEvent({required this.message});

  @override
  List<Object?> get props => [];

}