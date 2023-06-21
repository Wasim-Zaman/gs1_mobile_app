class SingleEventModel {
  String? gcpGLNID;
  Null? image;
  String? locationNameEn;
  String? addressEn;
  String? pobox;
  Null? officeTel;

  SingleEventModel(
      {this.gcpGLNID,
      this.image,
      this.locationNameEn,
      this.addressEn,
      this.pobox,
      this.officeTel});

  SingleEventModel.fromJson(Map<String, dynamic> json) {
    gcpGLNID = json['gcpGLNID'];
    image = json['image'];
    locationNameEn = json['locationNameEn'];
    addressEn = json['AddressEn'];
    pobox = json['pobox'];
    officeTel = json['office_tel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gcpGLNID'] = gcpGLNID;
    data['image'] = image;
    data['locationNameEn'] = locationNameEn;
    data['AddressEn'] = addressEn;
    data['pobox'] = pobox;
    data['office_tel'] = officeTel;
    return data;
  }
}
