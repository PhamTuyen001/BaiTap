class CartDTO {
  String? id;
  List<dynamic>? products;
  String? idUser;
  int? price;
  String? dateCreated;

  CartDTO({this.id, this.products, this.idUser, this.price, this.dateCreated});

  CartDTO.fromJson(Map<String, dynamic> json) {
  id = json['_id'];
  products = json['products'];
  idUser = json['id_user'];
  price = json['price'];
  dateCreated = json['date_created'];
  }

  static CartDTO parser (Map<String, dynamic> json){
    return CartDTO.fromJson(json);
  }

  static List<CartDTO> parserListCartDTO (List<dynamic> json){
    return (json as List).map((e) => CartDTO.fromJson(e)).toList();
  }
}