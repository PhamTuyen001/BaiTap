class ProductDTO {
  String? id;
  String? name;
  String? address;
  int? price;
  String? img;
  int? quantity;
  List<String>? gallery;

  ProductDTO(
      {this.id,
      this.name,
      this.address,
      this.price,
      this.img,
      this.quantity,
      this.gallery});

  ProductDTO.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    address = json['address'];
    price = json['price'];
    img = json['img'];
    quantity = json['quantity'];
    gallery = json['gallery'].cast<String>();
  }
  static ProductDTO parser(Map<String,dynamic> json){
    return ProductDTO.fromJson(json);
  }

  static List<ProductDTO> parserListProducts(List<dynamic> json){
    return (json as List).map((e) => ProductDTO.fromJson(e)).toList();
  }
  @override
  String toString() {
    return 'ProductDTO{id: $id, name: $name, address: $address, price: $price, img: $img, quantity: $quantity, gallery: $gallery}';
  }
}
