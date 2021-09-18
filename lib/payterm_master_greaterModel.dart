class Payterm_masrer_greater {
  int id;
  String payCode;
  String payDescription;
  double creditDaysFrom;
  double creditDaysTo;
  double percentage;
  String flag;
  String createdBy;
  String createdDate;

  Payterm_masrer_greater(
      {this.id,
      this.payCode,
      this.payDescription,
      this.creditDaysFrom,
      this.creditDaysTo,
      this.percentage,
      this.flag,
      this.createdBy,
      this.createdDate});

  Payterm_masrer_greater.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    payCode = json['payCode'];
    payDescription = json['payDescription'];
    creditDaysFrom = json['credit_days_from'];
    creditDaysTo = json['credit_days_to'];
    percentage = json['percentage'];
    flag = json['flag'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['payCode'] = this.payCode;
    data['payDescription'] = this.payDescription;
    data['credit_days_from'] = this.creditDaysFrom;
    data['credit_days_to'] = this.creditDaysTo;
    data['percentage'] = this.percentage;
    data['flag'] = this.flag;
    data['createdBy'] = this.createdBy;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
