class saveData {
  int id;
  String groupCode;
  String groupDescription;
  int subGroupCode;
  String validFrom;
  String endDate;
  String newVersion;
  bool wastage;
  bool msp;
  bool osp;
  String createdBy;
  String createdDate;
  String lockedBy;
  String lockedDate;
  AgItemMasterRmcDetailsBean agItemMasterRmcDetailsBean;
  Null agItemGroupMappingDetails;
  Null agItemGroupMappingDetailsBeans;
  Null agItemMasterRmcDetails;
  Null agCustGroupMasterBeans;
  Null agCustGroupMasterHistoryBeans;
  Null agSalesHistories;

  saveData(
      {this.id,
      this.groupCode,
      this.groupDescription,
      this.subGroupCode,
      this.validFrom,
      this.endDate,
      this.newVersion,
      this.wastage,
      this.msp,
      this.osp,
      this.createdBy,
      this.createdDate,
      this.lockedBy,
      this.lockedDate,
      this.agItemMasterRmcDetailsBean,
      this.agItemGroupMappingDetails,
      this.agItemGroupMappingDetailsBeans,
      this.agItemMasterRmcDetails,
      this.agCustGroupMasterBeans,
      this.agCustGroupMasterHistoryBeans,
      this.agSalesHistories});

  saveData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupCode = json['groupCode'];
    groupDescription = json['groupDescription'];
    subGroupCode = json['subGroupCode'];
    validFrom = json['validFrom'];
    endDate = json['endDate'];
    newVersion = json['newVersion'];
    wastage = json['wastage'];
    msp = json['msp'];
    osp = json['osp'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    lockedBy = json['lockedBy'];
    lockedDate = json['lockedDate'];
    agItemMasterRmcDetailsBean = json['agItemMasterRmcDetailsBean'] != null
        ? new AgItemMasterRmcDetailsBean.fromJson(
            json['agItemMasterRmcDetailsBean'])
        : null;
    agItemGroupMappingDetails = json['agItemGroupMappingDetails'];
    agItemGroupMappingDetailsBeans = json['agItemGroupMappingDetailsBeans'];
    agItemMasterRmcDetails = json['agItemMasterRmcDetails'];
    agCustGroupMasterBeans = json['agCustGroupMasterBeans'];
    agCustGroupMasterHistoryBeans = json['agCustGroupMasterHistoryBeans'];
    agSalesHistories = json['agSalesHistories'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['groupCode'] = this.groupCode;
    data['groupDescription'] = this.groupDescription;
    data['subGroupCode'] = this.subGroupCode;
    data['validFrom'] = this.validFrom;
    data['endDate'] = this.endDate;
    data['newVersion'] = this.newVersion;
    data['wastage'] = this.wastage;
    data['msp'] = this.msp;
    data['osp'] = this.osp;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['lockedBy'] = this.lockedBy;
    data['lockedDate'] = this.lockedDate;
    if (this.agItemMasterRmcDetailsBean != null) {
      data['agItemMasterRmcDetailsBean'] =
          this.agItemMasterRmcDetailsBean.toJson();
    }
    data['agItemGroupMappingDetails'] = this.agItemGroupMappingDetails;
    data['agItemGroupMappingDetailsBeans'] =
        this.agItemGroupMappingDetailsBeans;
    data['agItemMasterRmcDetails'] = this.agItemMasterRmcDetails;
    data['agCustGroupMasterBeans'] = this.agCustGroupMasterBeans;
    data['agCustGroupMasterHistoryBeans'] = this.agCustGroupMasterHistoryBeans;
    data['agSalesHistories'] = this.agSalesHistories;
    return data;
  }
}

class AgItemMasterRmcDetailsBean {
  int id;
  double wastageValue;
  double rmcPrice;
  double minPrice;
  double minPricePerc;
  double mspValue;
  double mspValueConv;
  double mspValuePerc;
  double mspValueDd;
  double ospValue;
  double ospValueConv;
  double ospValuePerc;
  double minPriceCust;
  double minPriceCustDlvr;
  double minPriceCustDly;
  double minPriceCustPterm;
  double minPriceCustOth;
  double minPriceCustTot;
  double mspValueCust;
  double mspValueCustDlvr;
  double mspValueCustDly;
  double mspValueCustPterm;
  double mspValueCustOth;
  double mspValueCustTot;
  double mspValueCustDd;
  double ospValueCust;
  double ospValueCustDlvr;
  double ospValueCustDly;
  double ospValueCustPterm;
  double ospValueCustOth;
  double ospValueCustTot;
  double lastPrice;
  double lastPriceDelivery;
  double lastPricePerc;
  String validFrom;
  String endDate;
  AgItemMaster agItemMaster;
  AgLocationMaster agLocationMaster;
  AgCustGroupMaster agCustGroupMaster;

  AgItemMasterRmcDetailsBean(
      {this.id,
      this.wastageValue,
      this.rmcPrice,
      this.minPrice,
      this.minPricePerc,
      this.mspValue,
      this.mspValueConv,
      this.mspValuePerc,
      this.mspValueDd,
      this.ospValue,
      this.ospValueConv,
      this.ospValuePerc,
      this.minPriceCust,
      this.minPriceCustDlvr,
      this.minPriceCustDly,
      this.minPriceCustPterm,
      this.minPriceCustOth,
      this.minPriceCustTot,
      this.mspValueCust,
      this.mspValueCustDlvr,
      this.mspValueCustDly,
      this.mspValueCustPterm,
      this.mspValueCustOth,
      this.mspValueCustTot,
      this.mspValueCustDd,
      this.ospValueCust,
      this.ospValueCustDlvr,
      this.ospValueCustDly,
      this.ospValueCustPterm,
      this.ospValueCustOth,
      this.ospValueCustTot,
      this.lastPrice,
      this.lastPriceDelivery,
      this.lastPricePerc,
      this.validFrom,
      this.endDate,
      this.agItemMaster,
      this.agLocationMaster,
      this.agCustGroupMaster});

  AgItemMasterRmcDetailsBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wastageValue = json['wastageValue'];
    rmcPrice = json['rmcPrice'];
    minPrice = json['minPrice'];
    minPricePerc = json['minPricePerc'];
    mspValue = json['mspValue'];
    mspValueConv = json['mspValueConv'];
    mspValuePerc = json['mspValuePerc'];
    mspValueDd = json['mspValueDd'];
    ospValue = json['ospValue'];
    ospValueConv = json['ospValueConv'];
    ospValuePerc = json['ospValuePerc'];
    minPriceCust = json['minPriceCust'];
    minPriceCustDlvr = json['minPriceCustDlvr'];
    minPriceCustDly = json['minPriceCustDly'];
    minPriceCustPterm = json['minPriceCustPterm'];
    minPriceCustOth = json['minPriceCustOth'];
    minPriceCustTot = json['minPriceCustTot'];
    mspValueCust = json['mspValueCust'];
    mspValueCustDlvr = json['mspValueCustDlvr'];
    mspValueCustDly = json['mspValueCustDly'];
    mspValueCustPterm = json['mspValueCustPterm'];
    mspValueCustOth = json['mspValueCustOth'];
    mspValueCustTot = json['mspValueCustTot'];
    mspValueCustDd = json['mspValueCustDd'];
    ospValueCust = json['ospValueCust'];
    ospValueCustDlvr = json['ospValueCustDlvr'];
    ospValueCustDly = json['ospValueCustDly'];
    ospValueCustPterm = json['ospValueCustPterm'];
    ospValueCustOth = json['ospValueCustOth'];
    ospValueCustTot = json['ospValueCustTot'];
    lastPrice = json['lastPrice'];
    lastPriceDelivery = json['lastPriceDelivery'];
    lastPricePerc = json['lastPricePerc'];
    validFrom = json['validFrom'];
    endDate = json['endDate'];
    agItemMaster = json['agItemMaster'] != null
        ? new AgItemMaster.fromJson(json['agItemMaster'])
        : null;
    agLocationMaster = json['agLocationMaster'] != null
        ? new AgLocationMaster.fromJson(json['agLocationMaster'])
        : null;
    agCustGroupMaster = json['agCustGroupMaster'] != null
        ? new AgCustGroupMaster.fromJson(json['agCustGroupMaster'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['wastageValue'] = this.wastageValue;
    data['rmcPrice'] = this.rmcPrice;
    data['minPrice'] = this.minPrice;
    data['minPricePerc'] = this.minPricePerc;
    data['mspValue'] = this.mspValue;
    data['mspValueConv'] = this.mspValueConv;
    data['mspValuePerc'] = this.mspValuePerc;
    data['mspValueDd'] = this.mspValueDd;
    data['ospValue'] = this.ospValue;
    data['ospValueConv'] = this.ospValueConv;
    data['ospValuePerc'] = this.ospValuePerc;
    data['minPriceCust'] = this.minPriceCust;
    data['minPriceCustDlvr'] = this.minPriceCustDlvr;
    data['minPriceCustDly'] = this.minPriceCustDly;
    data['minPriceCustPterm'] = this.minPriceCustPterm;
    data['minPriceCustOth'] = this.minPriceCustOth;
    data['minPriceCustTot'] = this.minPriceCustTot;
    data['mspValueCust'] = this.mspValueCust;
    data['mspValueCustDlvr'] = this.mspValueCustDlvr;
    data['mspValueCustDly'] = this.mspValueCustDly;
    data['mspValueCustPterm'] = this.mspValueCustPterm;
    data['mspValueCustOth'] = this.mspValueCustOth;
    data['mspValueCustTot'] = this.mspValueCustTot;
    data['mspValueCustDd'] = this.mspValueCustDd;
    data['ospValueCust'] = this.ospValueCust;
    data['ospValueCustDlvr'] = this.ospValueCustDlvr;
    data['ospValueCustDly'] = this.ospValueCustDly;
    data['ospValueCustPterm'] = this.ospValueCustPterm;
    data['ospValueCustOth'] = this.ospValueCustOth;
    data['ospValueCustTot'] = this.ospValueCustTot;
    data['lastPrice'] = this.lastPrice;
    data['lastPriceDelivery'] = this.lastPriceDelivery;
    data['lastPricePerc'] = this.lastPricePerc;
    data['validFrom'] = this.validFrom;
    data['endDate'] = this.endDate;
    if (this.agItemMaster != null) {
      data['agItemMaster'] = this.agItemMaster.toJson();
    }
    if (this.agLocationMaster != null) {
      data['agLocationMaster'] = this.agLocationMaster.toJson();
    }
    if (this.agCustGroupMaster != null) {
      data['agCustGroupMaster'] = this.agCustGroupMaster.toJson();
    }
    return data;
  }
}

class AgItemMaster {
  int id;
  String itemCode;
  String itemDescription;
  String flag;
  String createdBy;
  String createdDate;
  Null subGroupCode;
  AgItemGroupMaster agItemGroupMaster;
  AgCompanyMaster agCompanyMaster;

  AgItemMaster(
      {this.id,
      this.itemCode,
      this.itemDescription,
      this.flag,
      this.createdBy,
      this.createdDate,
      this.subGroupCode,
      this.agItemGroupMaster,
      this.agCompanyMaster});

  AgItemMaster.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemCode = json['itemCode'];
    itemDescription = json['itemDescription'];
    flag = json['flag'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    subGroupCode = json['subGroupCode'];
    agItemGroupMaster = json['agItemGroupMaster'] != null
        ? new AgItemGroupMaster.fromJson(json['agItemGroupMaster'])
        : null;
    agCompanyMaster = json['agCompanyMaster'] != null
        ? new AgCompanyMaster.fromJson(json['agCompanyMaster'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['itemCode'] = this.itemCode;
    data['itemDescription'] = this.itemDescription;
    data['flag'] = this.flag;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['subGroupCode'] = this.subGroupCode;
    if (this.agItemGroupMaster != null) {
      data['agItemGroupMaster'] = this.agItemGroupMaster.toJson();
    }
    if (this.agCompanyMaster != null) {
      data['agCompanyMaster'] = this.agCompanyMaster.toJson();
    }
    return data;
  }
}

class AgItemGroupMaster {
  int id;
  String groupCode;
  String groupDescription;
  String flag;
  bool wastage;
  bool msp;
  bool osp;
  String createdBy;
  String createdDate;

  AgItemGroupMaster(
      {this.id,
      this.groupCode,
      this.groupDescription,
      this.flag,
      this.wastage,
      this.msp,
      this.osp,
      this.createdBy,
      this.createdDate});

  AgItemGroupMaster.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupCode = json['groupCode'];
    groupDescription = json['groupDescription'];
    flag = json['flag'];
    wastage = json['wastage'];
    msp = json['msp'];
    osp = json['osp'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['groupCode'] = this.groupCode;
    data['groupDescription'] = this.groupDescription;
    data['flag'] = this.flag;
    data['wastage'] = this.wastage;
    data['msp'] = this.msp;
    data['osp'] = this.osp;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
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

class AgLocationMaster {
  int id;
  String locationCode;
  String locationDescription;
  Null locationAddress;
  String pincode;
  String flag;
  String createdBy;
  String createdDate;
  AgCompanyMaster agCompanyMaster;

  AgLocationMaster(
      {this.id,
      this.locationCode,
      this.locationDescription,
      this.locationAddress,
      this.pincode,
      this.flag,
      this.createdBy,
      this.createdDate,
      this.agCompanyMaster});

  AgLocationMaster.fromJson(Map<String, dynamic> json) {
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

class AgCustGroupMaster {
  int id;
  String groupCode;
  String groupDescription;
  String flag;
  String createdBy;
  String createdDate;

  AgCustGroupMaster(
      {this.id,
      this.groupCode,
      this.groupDescription,
      this.flag,
      this.createdBy,
      this.createdDate});

  AgCustGroupMaster.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupCode = json['groupCode'];
    groupDescription = json['groupDescription'];
    flag = json['flag'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['groupCode'] = this.groupCode;
    data['groupDescription'] = this.groupDescription;
    data['flag'] = this.flag;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
