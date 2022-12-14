import 'package:appp_sale_29092022/common/bases/base_event.dart';

class FetchCartEvent extends BaseEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AddCartEvent extends BaseEvent{
  String idProduct;
  AddCartEvent(this.idProduct);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeQtyCartItemEvent extends BaseEvent{
  String idProduct;
  String idCart;
  int quantity;
  ChangeQtyCartItemEvent(this.idProduct, this.idCart , this.quantity);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
