class UserDTO {
  String? email;
  String? name;
  String? phone;
  String? token;

  UserDTO({this.email,
        this.name,
        this.phone,
        this.token});

  // Named constructor
  UserDTO.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    token = json['token'];
  }

  @override
  String toString() {
    return 'UserDTO{email: $email, name: $name, phone: $phone, token: $token}';
  }

  // static UserDTO parser(Map<String, dynamic> json) => UserDTO.fromJson(json);
}