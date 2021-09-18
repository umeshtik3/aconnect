class UserModel {
  String idToken;
  bool isLoggedIn;
  String baseurl;
  bool pin_exist;
  String username;

  UserModel(
      {this.idToken,
      this.isLoggedIn,
      this.baseurl,
      this.pin_exist,
      this.username});

  UserModel.fromJson(Map<String, dynamic> json) {
    idToken = json['id_token'];
    isLoggedIn = json['isLoggedIn'];
    baseurl = json['baseurl'];
    pin_exist = json['pin_exist'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_token'] = this.idToken;
    data['isLoggedIn'] = this.isLoggedIn;
    data['baseurl'] = this.baseurl;
    data['pin_exist'] = this.pin_exist;
    data['username'] = this.username;

    return data;
  }
}
