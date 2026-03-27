class GetPunchHistoryModel {
  bool? success;
  String? message;
  List<Data>? data;
  Pagination? pagination;

  GetPunchHistoryModel(
      {this.success, this.message, this.data, this.pagination});

  GetPunchHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Data {
  String? date;
  String? driverId;
  String? punchInTime;
  String? punchOutTime;
  String? totalWorkingHours;
  int? totalTrips;
  double? totalEarnings;
  String? status;

  Data(
      {this.date,
        this.driverId,
        this.punchInTime,
        this.punchOutTime,
        this.totalWorkingHours,
        this.totalTrips,
        this.totalEarnings,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    driverId = json['driverId'];
    punchInTime = json['punchInTime'];
    punchOutTime = json['punchOutTime'];
    totalWorkingHours = json['totalWorkingHours'];
    totalTrips = json['totalTrips'];
    totalEarnings = json['totalEarnings'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['driverId'] = this.driverId;
    data['punchInTime'] = this.punchInTime;
    data['punchOutTime'] = this.punchOutTime;
    data['totalWorkingHours'] = this.totalWorkingHours;
    data['totalTrips'] = this.totalTrips;
    data['totalEarnings'] = this.totalEarnings;
    data['status'] = this.status;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalRecords;
  int? perPage;

  Pagination(
      {this.currentPage, this.totalPages, this.totalRecords, this.perPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    perPage = json['perPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['totalRecords'] = this.totalRecords;
    data['perPage'] = this.perPage;
    return data;
  }
}
