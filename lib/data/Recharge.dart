class Recharge {
  // Define class properties
  int? id;
  int? benid;
  int? userid;
  double? credit;
  String? date;
  String? username;

  // Constructor with optional 'id' parameter
  Recharge({this.benid, this.userid, this.credit, this.username})
      : date = DateTime.now().millisecondsSinceEpoch.toString();

  // Convert a Note into a Map. The keys must correspond to the names of the
  // columns in the database.
  Recharge.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    benid = map['benid'];
    userid = map['userid'];
    credit = map['credit'];
    date = map['date'];
    username = map['username'];
  }

  Map<String, dynamic> toJson() {
    return {
      'benid': benid,
      'userid': userid,
      'credit': credit,
      'date': date,
      'username': username,
    };
  }
}
