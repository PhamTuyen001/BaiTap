class AppResource<T> {
  String? messsage;
  T? data;

  AppResource({this.messsage, this.data});

  // parser
  AppResource.fromJson(Map<String, dynamic> json, Function parseModel) {
    messsage = json["message"];
    data = parseModel(json["data"]);
  }
}