import 'dart:async';

import '../../../common/bases/base_bloc.dart';
import '../../../common/bases/base_event.dart';
import '../../../common/constants/variable_constant.dart';
import '../../../data/datasources/local/cache/app_cache.dart';
import '../../../data/datasources/remote/dto/app_resource.dart';
import '../../../data/datasources/remote/dto/cart_dto.dart';
import '../../../data/datasources/remote/dto/product_dto.dart';
import '../../../data/model/cart.dart';
import '../../../data/model/product.dart';
import '../../../data/repositories/cart_repository.dart';
import 'cart_event.dart';

class CartBloc extends BaseBloc{
  late CartRespository _cartRespository;
  StreamController<Cart> _streamController = StreamController.broadcast();
  Cart? _cartModel ;
  late List<Product> listProduct;
  void updateRepository(CartRespository cartRespository){
    _cartRespository = cartRespository;
  }

  StreamController<Cart> get streamController => _streamController;

  @override
  void dispatch(BaseEvent event) {
    // TODO: implement dispatch
    switch (event.runtimeType) {
      case FetchCartEvent:
        handleFetchCartEvent();
        break;
      case AddCartEvent:
        handleAddCartEvent (event as AddCartEvent);
        break;
      case ChangeQtyCartItemEvent:
        _ChangeQtyCartItemEvent(event as ChangeQtyCartItemEvent);
        break;
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController.close();
  }
  int getQtyProductCart(String idProduct){
    int quantity = 0;
    if(_cartModel == null) {
      return 0;
    }
    for(int i = 0; i<_cartModel!.products.length;i++){
      if(_cartModel!.products[i].id == idProduct){
        quantity = _cartModel!.products[i].quantity;
      }
    }
    return quantity;
  }
  void _ChangeQtyCartItemEvent(ChangeQtyCartItemEvent event) async{
    loadingSink.add(true);
    try{
        int qty = getQtyProductCart(event.idProduct) + event.quantity;

        AppResource<CartDTO> resourceDTO = await _cartRespository.updateCart(event.idProduct,event.idCart,qty>0?qty:1);
        if (resourceDTO.data == null) return;
        handleFetchCartEvent();
    }catch(e){
      print(e.toString());
    }
    loadingSink.add(false);
  }

  void handleAddCartEvent(AddCartEvent event) async{
    loadingSink.add(true);
    try{
      AppResource<CartDTO> appResourceDTO = await _cartRespository.addToCart(event.idProduct);
      if (appResourceDTO.data == null) return;
      handleFetchCartEvent();
    }catch (e){
      print(e.toString());
    }
    loadingSink.add(false);
  }
  void handleFetchCartEvent() async {
    loadingSink.add(true);
    try {
      AppResource<CartDTO> appResourceDTO = await _cartRespository.getCart();
      if (appResourceDTO.data == null) return;
      CartDTO cartDTO = appResourceDTO.data!;
      if (cartDTO.products != null) {
        List<dynamic> listProductResponse = cartDTO.products!;
        List<ProductDTO> listProductDTO = ProductDTO.parserListProducts(listProductResponse);
        listProduct = listProductDTO.map((e){
          return Product(e.id, e.name, e.address, e.price, e.img, e.quantity, e.gallery);
        }).toList();
      }
      _cartModel = Cart(cartDTO.id, listProduct, cartDTO.idUser, cartDTO.price, cartDTO.dateCreated);
      AppCache.setString(key: VariableConstant.CART_ID,value: _cartModel!.id.toString());
      _streamController.add(_cartModel!);
    } catch (e) {
      print(e.toString());
    }
    loadingSink.add(false);
  }


}