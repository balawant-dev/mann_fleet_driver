class VoiceCallInitiateModel {
  bool? status;
  String? message;
  Data? data;

  VoiceCallInitiateModel({this.status, this.message, this.data});

  VoiceCallInitiateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? channelName;
  String? token;
  int? uid;

  Data({this.channelName, this.token, this.uid});

  Data.fromJson(Map<String, dynamic> json) {
    channelName = json['channelName'];
    token = json['token'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channelName'] = this.channelName;
    data['token'] = this.token;
    data['uid'] = this.uid;
    return data;
  }
}
