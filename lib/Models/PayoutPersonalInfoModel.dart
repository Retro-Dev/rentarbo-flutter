

class PayoutPersonalInfoModel {
  int? id;
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
  DueFields? dueFields;
  String? createdAt;

  PayoutPersonalInfoModel(
      {this.id,
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
        this.createdAt});

  PayoutPersonalInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    if (json['due_fields'] != null)
    {

      var test = json['due_fields'];
      print(test.runtimeType);
      if (test.runtimeType != List)
      {
        dueFields = json['due_fields'] != null
            ? new DueFields.fromJson(json['due_fields'])
            : null;
      }

    }


    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    if (this.dueFields != null ) {
      data['due_fields'] = this.dueFields!.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class DueFields {
  String? bankAccount;

  DueFields({this.bankAccount});

  DueFields.fromJson(Map<String, dynamic> json) {
    bankAccount = json['bank_account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank_account'] = this.bankAccount;
    return data;
  }
}