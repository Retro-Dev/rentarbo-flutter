

class CheckAccountStatusModel {
  List<String>? fieldsDue;
  List<Errors>? errors;
  PersonalInfo? personalInfo;
  BankInfo? bankInfo;

  CheckAccountStatusModel({this.fieldsDue, this.errors, this.personalInfo, this.bankInfo});
  //CheckAccountStatusModel({this.fieldsDue,this.personalInfo, this.bankInfo});

  CheckAccountStatusModel.fromJson(Map<String, dynamic> json) {
    if (json['fields_due'] != null) {
      fieldsDue = json['fields_due'].cast<String>();

    }
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(new Errors.fromJson(v));
      });
    }
    personalInfo = json['personal_info'] != null
        ? new PersonalInfo.fromJson(json['personal_info'])
        : null;
    bankInfo = json['bank_info'] != null
        ? new BankInfo.fromJson(json['bank_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fields_due'] = this.fieldsDue;
    // if (this.fieldsDue != null) {
    //   data['fields_due'] = this.fieldsDue!.map((v) => v.toJson()).toList();
    // }
    if (this.errors != null) {
      data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    }
    if (this.personalInfo != null) {
      data['personal_info'] = this.personalInfo!.toJson();
    }
    if (this.bankInfo != null) {
      data['bank_info'] = this.bankInfo!.toJson();
    }
    return data;
  }
}

class Errors {
  String? code;
  String? reason;
  String? requirement;

  Errors({this.code, this.reason, this.requirement});

  Errors.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    reason = json['reason'];
    requirement = json['requirement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['reason'] = this.reason;
    data['requirement'] = this.requirement;
    return data;
  }
}
class PersonalInfo {
  int? id;
  int? userId;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? ssn;
  String? idFront;
  String? idBack;
  String? city;
  String? state;
  String? street;
  String? phone;
  String? postalCode;
  String? status;
  String? dueFields;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  PersonalInfo(
      {this.id,
        this.userId,
        this.firstName,
        this.lastName,
        this.dateOfBirth,
        this.ssn,
        this.idFront,
        this.idBack,
        this.city,
        this.state,
        this.street,
        this.phone,
        this.postalCode,
        this.status,
        this.dueFields,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  PersonalInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dateOfBirth = json['date_of_birth'];
    ssn = json['ssn'];
    idFront = json['id_front'];
    idBack = json['id_back'];
    city = json['city'];
    state = json['state'];
    street = json['street'];
    phone = json['phone'];
    postalCode = json['postal_code'];
    status = json['status'];
    dueFields = json['due_fields'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['date_of_birth'] = this.dateOfBirth;
    data['ssn'] = this.ssn;
    data['id_front'] = this.idFront;
    data['id_back'] = this.idBack;
    data['city'] = this.city;
    data['state'] = this.state;
    data['street'] = this.street;
    data['phone'] = this.phone;
    data['postal_code'] = this.postalCode;
    data['status'] = this.status;
    data['due_fields'] = this.dueFields;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class BankInfo {
  int? id;
  int? userId;
  String? gatewayExternalAccountId;
  String? accountHolderName;
  String? last4Digit;
  String? isDefault;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  BankInfo(
      {this.id,
        this.userId,
        this.gatewayExternalAccountId,
        this.accountHolderName,
        this.last4Digit,
        this.isDefault,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  BankInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    gatewayExternalAccountId = json['gateway_external_account_id'];
    accountHolderName = json['account_holder_name'];
    last4Digit = json['last4_digit'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['gateway_external_account_id'] = this.gatewayExternalAccountId;
    data['account_holder_name'] = this.accountHolderName;
    data['last4_digit'] = this.last4Digit;
    data['is_default'] = this.isDefault;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}