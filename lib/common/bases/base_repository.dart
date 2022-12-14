import 'package:appp_sale_29092022/data/datasources/remote/api_request.dart';

abstract class BaseRepository {
  late ApiRequest apiRequest;

  void updateRequest(ApiRequest apiRequest) {
    this.apiRequest = apiRequest;
  }
}