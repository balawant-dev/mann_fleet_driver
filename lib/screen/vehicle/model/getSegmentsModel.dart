class GetSegmentsModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<Data>? data;

  GetSegmentsModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  GetSegmentsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? sId;
  String? name;
  String? description;
  String? image;
  int? maxCapacity;
  String? createdAt;
  int? iV;

  Data(
      {this.sId,
        this.name,
        this.description,
        this.image,
        this.maxCapacity,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    maxCapacity = json['maxCapacity'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['maxCapacity'] = this.maxCapacity;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
