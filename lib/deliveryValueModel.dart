class deliveryValueModel {
  int id;
  String pincode;
  double pricekg;
  String validFrom;
  Null endDate;
  AgLocationMaster agLocationMaster;

  deliveryValueModel(
      {this.id,
      this.pincode,
      this.pricekg,
      this.validFrom,
      this.endDate,
      this.agLocationMaster});

  deliveryValueModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pincode = json['pincode'];
    pricekg = json['pricekg'];
    validFrom = json['validFrom'];
    endDate = json['endDate'];
    agLocationMaster = json['agLocationMaster'] != null
        ? new AgLocationMaster.fromJson(json['agLocationMaster'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pincode'] = this.pincode;
    data['pricekg'] = this.pricekg;
    data['validFrom'] = this.validFrom;
    data['endDate'] = this.endDate;
    if (this.agLocationMaster != null) {
      data['agLocationMaster'] = this.agLocationMaster.toJson();
    }
    return data;
  }
}

class AgLocationMaster {
  int id;
  String locationCode;
  String locationDescription;
  String pincode;
  String flag;
  String createdBy;
  String createdDate;

  AgLocationMaster(
      {this.id,
      this.locationCode,
      this.locationDescription,
      this.pincode,
      this.flag,
      this.createdBy,
      this.createdDate});

  AgLocationMaster.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationCode = json['locationCode'];
    locationDescription = json['locationDescription'];
    pincode = json['pincode'];
    flag = json['flag'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['locationCode'] = this.locationCode;
    data['locationDescription'] = this.locationDescription;
    data['pincode'] = this.pincode;
    data['flag'] = this.flag;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
