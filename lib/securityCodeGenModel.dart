class SecurityCodeGenModel {
  String idToken;
  bool pin_exist;

  SecurityCodeGenModel({this.idToken, this.pin_exist});

  SecurityCodeGenModel.fromJson(Map<String, dynamic> json) {
    idToken = json['id_token'];
    pin_exist = json['pin_exist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_token'] = this.idToken;
    data['pin_exist'] = this.pin_exist;
    return data;
  }
}
