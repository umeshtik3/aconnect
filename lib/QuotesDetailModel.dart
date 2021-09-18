class QuotesDetailModel {
  int id;
  bool firstTimeApplicable;
  String newCustomerDetail;
  int itemId;
  String itemCode;
  String itemDescription;
  String groupCode;
  String groupDescription;
  String locationCode;
  String locationDescription;
  String locationPinCode;
  String customerCode;
  String customerName;
  String customerPinCode;
  double ddCharges;
  double quantity;
  double sampleQuantity;
  String payCode;
  String payDescription;
  double payValue;
  bool deliveryType;
  double acd;
  double creditDays;
  double delayDays;
  double mspValue;
  double mspValueDd;
  double mspValueCust;
  double mspValueCustDd;
  Null customerPreference;
  String flag;
  String remarks;
  String createdBy;
  String createdDate;
  String approvedBy;
  String approvedDate;
  String approvalRemarks;

  QuotesDetailModel(
      {this.id,
      this.firstTimeApplicable,
      this.newCustomerDetail,
      this.itemId,
      this.itemCode,
      this.itemDescription,
      this.groupCode,
      this.groupDescription,
      this.locationCode,
      this.locationDescription,
      this.locationPinCode,
      this.customerCode,
      this.customerName,
      this.customerPinCode,
      this.ddCharges,
      this.quantity,
      this.sampleQuantity,
      this.payCode,
      this.payDescription,
      this.payValue,
      this.deliveryType,
      this.acd,
      this.creditDays,
      this.delayDays,
      this.mspValue,
      this.mspValueDd,
      this.mspValueCust,
      this.mspValueCustDd,
      this.customerPreference,
      this.flag,
      this.remarks,
      this.createdBy,
      this.createdDate,
      this.approvedBy,
      this.approvedDate,
      this.approvalRemarks});

  QuotesDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstTimeApplicable = json['firstTimeApplicable'];
    newCustomerDetail = json['newCustomerDetail'];
    itemId = json['itemId'];
    itemCode = json['itemCode'];
    itemDescription = json['itemDescription'];
    groupCode = json['groupCode'];
    groupDescription = json['groupDescription'];
    locationCode = json['locationCode'];
    locationDescription = json['locationDescription'];
    locationPinCode = json['locationPinCode'];
    customerCode = json['customerCode'];
    customerName = json['customerName'];
    customerPinCode = json['customerPinCode'];
    ddCharges = json['ddCharges'];
    quantity = json['quantity'];
    sampleQuantity = json['sampleQuantity'];
    payCode = json['payCode'];
    payDescription = json['payDescription'];
    payValue = json['payValue'];
    deliveryType = json['deliveryType'];
    acd = json['acd'];
    creditDays = json['creditDays'];
    delayDays = json['delayDays'];
    mspValue = json['mspValue'];
    mspValueDd = json['mspValueDd'];
    mspValueCust = json['mspValueCust'];
    mspValueCustDd = json['mspValueCustDd'];
    customerPreference = json['customerPreference'];
    flag = json['flag'];
    remarks = json['remarks'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    approvedBy = json['approvedBy'];
    approvedDate = json['approvedDate'];
    approvalRemarks = json['approvalRemarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstTimeApplicable'] = this.firstTimeApplicable;
    data['newCustomerDetail'] = this.newCustomerDetail;
    data['itemId'] = this.itemId;
    data['itemCode'] = this.itemCode;
    data['itemDescription'] = this.itemDescription;
    data['groupCode'] = this.groupCode;
    data['groupDescription'] = this.groupDescription;
    data['locationCode'] = this.locationCode;
    data['locationDescription'] = this.locationDescription;
    data['locationPinCode'] = this.locationPinCode;
    data['customerCode'] = this.customerCode;
    data['customerName'] = this.customerName;
    data['customerPinCode'] = this.customerPinCode;
    data['ddCharges'] = this.ddCharges;
    data['quantity'] = this.quantity;
    data['sampleQuantity'] = this.sampleQuantity;
    data['payCode'] = this.payCode;
    data['payDescription'] = this.payDescription;
    data['payValue'] = this.payValue;
    data['deliveryType'] = this.deliveryType;
    data['acd'] = this.acd;
    data['creditDays'] = this.creditDays;
    data['delayDays'] = this.delayDays;
    data['mspValue'] = this.mspValue;
    data['mspValueDd'] = this.mspValueDd;
    data['mspValueCust'] = this.mspValueCust;
    data['mspValueCustDd'] = this.mspValueCustDd;
    data['customerPreference'] = this.customerPreference;
    data['flag'] = this.flag;
    data['remarks'] = this.remarks;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    data['approvedBy'] = this.approvedBy;
    data['approvedDate'] = this.approvedDate;
    data['approvalRemarks'] = this.approvalRemarks;
    return data;
  }
}
