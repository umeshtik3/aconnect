import 'dart:ui';

class Constants {
  String BASE_URL;
  static const String DEANA_LOGIN_URL = "api/authenticate";
  static const String DEANA_CHANGE_PASSWORD_URL = "api/account/change-password";
  static const String DEANA_USERDETAIL = "api/admin/current-user";
  static const String DEANA_SITE = "api/ag-location-masters";

  // static const String DEANA_SITE="api/ag-location-masters-like/";
  static const String DEANA_CUSTOMER_NAME = "api/ag-customer-masters-like/";
  static const String DEANA_ITEM_OLD = "api/ag-item-masters-like/";
  static const String DEANA_ITEM = "api/ag-item-masters-company-like/";

  static const PrimaryColor = Color(0xFF561e65);
  static const String DEANA_PAYTEM = "api/ag-payterm-masters";

  //static const String DEANA_PAYTEM="api/ag-payterm-masters-like/";
  static const String DEANA_EXEC = "api/ag-item-group-mappings-view-executive";
  static const String DEANA_DELIVERYAPI =
      "api/ag-location-pincode-mappings-ddvalue";
  static const String DEANA_QUOTESFILTER = "api/ag-executive-quotes-filter";
  static const String DEANA_QUOTESAPPROVALFILTER = "api/ag-executive-quotes-approval-filter";
  static const int ITEM_PER_PAGE = 10;
  static const String DEANA_SAVEDATA = "api/ag-executive-quotes";
  static const String DEANA_UPDATEDATA = "api/ag-executive-quotes-update";

  // String url="http://aconnect.alokindustries.com/";
  String url = "http://aconnect.alokindustries.com/";
  static const String DEANA_QUOTESDETAIL = "api/ag-executive-quotes/";
  static const DEANA_PAYTEM_MASTER_GREATER = "api/ag-payterm-masters-greater";
  static const DEANA_SECURITYGEN = "api/store-pin";
  static const DEANA_SECURITYFETCH = "api/authenticate-pin";
  static const DEANA_SECURITYRESET = "api/reset-pin";
  static const DEANA_FORWARD_QUOTES = "api/ag-executive-quotes-forward/";
  static const DEANA_APPROVE_QUOTES = "api/ag-executive-quotes-approve/";
  static const DEANA_REJECT_QUOTES = "api/ag-executive-quotes-reject/";

  void setString(String text) {
    BASE_URL = text;
  }

  String getString() {
    return this.BASE_URL;
  }
}
