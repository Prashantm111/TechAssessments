class Recharge {
  // Define class properties
  int? id;
  int? benid; // Beneficiary  ID
  int? userid; // User name
  double? credit; // User email
  String? date; // User email

  // Constructor with optional 'id' parameter
  Recharge({this.benid, this.userid, this.credit, this.id})
      : date = DateTime.now().toString();

  // Convert a Note into a Map. The keys must correspond to the names of the
  // columns in the database.
  Recharge.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    benid = map['benid'];
    userid = map['userid'];
    credit = map['credit'];
    date = map['date'];
  }

  Map<String, dynamic> toJson() {
    return {
      'benid': benid,
      'userid': userid,
      'credit': credit,
      'date': date,
    };
  }
}
