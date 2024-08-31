class Beneficiary {
  // Define class properties
  int? id; // Beneficiary  ID Auto
  String? name; // User name
  String? number; // User Mobile Number
  int?  userid; // User Id Who adding Beneficiary in table

  // Constructor with optional 'id' parameter
  Beneficiary(this.name, this.number, this.userid, {this.id});

  // Convert a Note into a Map. The keys must correspond to the names of the
  // columns in the database.
  Beneficiary.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    number = map['number'];
    userid = map['userid'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
      'userid': userid,
    };
  }
}
