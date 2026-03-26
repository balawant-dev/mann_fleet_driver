





class GetBannerModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<BannerData>? data;

  GetBannerModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  GetBannerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BannerData>[];
      json['data'].forEach((v) {
        data!.add(new BannerData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResult'] = this.totalResult;
    data['totalPage'] = this.totalPage;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerData {
  String? sId;
  String? image;
  int? priority;
  String? platform;
  String? type;
  bool? status;
  String? createdAt;
  int? iV;

  BannerData(
      {this.sId,
        this.image,
        this.priority,
        this.platform,
        this.type,
        this.status,
        this.createdAt,
        this.iV});

  BannerData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    priority = json['priority'];
    platform = json['platform'];
    type = json['type'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['image'] = this.image;
    data['priority'] = this.priority;
    data['platform'] = this.platform;
    data['type'] = this.type;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
