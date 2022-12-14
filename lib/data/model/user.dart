class User {
  String email = "";
  String name = "";
  String phone = "";
  String token = "";

  User(String? email, String? name, String? phone, String? token) {
    this.email = email ?? "";
    this.name = name ?? "";
    this.phone = phone ?? "";
    this.token = token ?? "";
  }

  @override
  String toString() {
    return 'User{email: $email, name: $name, phone: $phone, token: $token}';
  }
}
