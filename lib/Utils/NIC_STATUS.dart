class NIC_STATUS {
  int? id;
  String? name;
  String? nic;
  int? dob;
  String? address;
  String? phone;
  int? isCleared;
  bool? isActive;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;

  NIC_STATUS(
      {this.id,
        this.name,
        this.nic,
        this.dob,
        this.address,
        this.phone,
        this.isCleared,
        this.isActive,
        this.isDeleted,
        this.createdAt,
        this.updatedAt});

  NIC_STATUS.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nic = json['nic'];
    dob = json['dob'];
    address = json['address'];
    phone = json['phone'];
    isCleared = json['is_cleared'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['nic'] = this.nic;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['is_cleared'] = this.isCleared;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}