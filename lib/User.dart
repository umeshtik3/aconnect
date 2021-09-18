class User {
  int id;
  String locationCode;
  String locationDescription;
  Null locationAddress;
  String pincode;
  String flag;
  String createdBy;
  String createdDate;
  AgCompanyMaster agCompanyMaster;

  User(
      {this.id,
      this.locationCode,
      this.locationDescription,
      this.locationAddress,
      this.pincode,
      this.flag,
      this.createdBy,
      this.createdDate,
      this.agCompanyMaster});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationCode = json['locationCode'];
    locationDescription = json['locationDescription'];
    // locationAddress = json['locationAddress'];
    pincode = json['pincode'];
    flag = json['flag'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    agCompanyMaster = json['agCompanyMaster'] != null
        ? new AgCompanyMaster.fromJson(json['agCompanyMaster'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['locationCode'] = this.locationCode;
    data['locationDescription'] = this.locationDescription;
    data['locationAddress'] = this.locationAddress;
    data['pincode'] = this.pincode;
    data['flag'] = this.flag;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    if (this.agCompanyMaster != null) {
      data['agCompanyMaster'] = this.agCompanyMaster.toJson();
    }
    return data;
  }
}

class AgCompanyMaster {
  int id;
  String companyCode;
  String companyDescription;
  String flag;
  String createdBy;
  String createdDate;

  AgCompanyMaster(
      {this.id,
      this.companyCode,
      this.companyDescription,
      this.flag,
      this.createdBy,
      this.createdDate});

  AgCompanyMaster.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyCode = json['companyCode'];
    companyDescription = json['companyDescription'];
    flag = json['flag'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['companyCode'] = this.companyCode;
    data['companyDescription'] = this.companyDescription;
    data['flag'] = this.flag;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
