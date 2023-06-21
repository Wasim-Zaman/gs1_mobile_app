class GetAllCrModel {
  String? id;
  String? cr;
  String? activity;
  int? status;
  String? createdAt;
  String? updatedAt;

  GetAllCrModel(
      {this.id,
      this.cr,
      this.activity,
      this.status,
      this.createdAt,
      this.updatedAt});

  GetAllCrModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cr = json['cr'];
    activity = json['activity'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['cr'] = cr;
    data['activity'] = activity;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
