class SiteModel {
  int id;
  String locationCode;
  String locationDescription;
  String flag;
  String createdBy;
  String createdDate;

  SiteModel(
      {this.id,
      this.locationCode,
      this.locationDescription,
      this.flag,
      this.createdBy,
      this.createdDate});

  SiteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationCode = json['locationCode'];
    locationDescription = json['locationDescription'];
    flag = json['flag'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['locationCode'] = this.locationCode;
    data['locationDescription'] = this.locationDescription;
    data['flag'] = this.flag;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
