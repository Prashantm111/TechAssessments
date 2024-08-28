import 'dart:ffi';

class UserInfoModel {
  // Define class properties
  int? id; // User ID
  String? name; // User name
  String? number; // User email
  String?  status;  // o true 1 false
  double?  credit;  //



  // Constructor with optional 'id' parameter
  UserInfoModel(this.name,  this.number,this.status, this.credit,{this.id});

  // Convert a Note into a Map. The keys must correspond to the names of the
  // columns in the database.
  UserInfoModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    number = map['number'];
    status = map['status'];
    credit = map['credit'];
  }


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
      'status': status,
      'credit': credit,
    };
  }
}