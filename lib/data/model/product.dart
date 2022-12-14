class Product {
  String id = "";
  String name = "";
  String address = "";
  int price = -1;
  String img = "";
  int quantity = -1;
  List<String> gallery = List.empty();

  Product(
      String? id,
      String? name,
      String? address,
      int? price,
      String? img,
      int? quantity,
      List<String>? gallery
  ) {
    this.id = id ?? "";
    this.name = name ?? "";
    this.address = address ?? "";
    this.price = price ?? -1;
    this.img = img ?? "";
    this.quantity = quantity ?? -1;
    this.gallery = gallery ?? List.empty();
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, address: $address, price: $price, img: $img, quantity: $quantity, gallery: $gallery}';
  }
}