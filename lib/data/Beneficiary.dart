class Beneficiary {
  // Define class properties
  int? id; // Beneficiary  ID
  String? name; // User name
  String? number; // User email
  int?  userid; // User email

  // Constructor with optional 'id' parameter
  Beneficiary(this.name, this.number, this.userid, {this.id});

  // Convert a Note into a Map. The keys must correspond to the names of the
  // columns in the database.
  Beneficiary.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    number = map['number'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
      'userid': userid,
    };
  }
}
