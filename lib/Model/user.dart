import 'package:firebase_database/firebase_database.dart';

class User {
  //String Key;
  // ignore: non_constant_identifier_names

  final String user_id;
  final String email;
  final String password;
  final String photo;
  final String name;
  final String surname;
  final String position;
  final String tel;

  User(this.user_id, this.email, this.password, this.photo, this.name, this.surname, this.position, this.tel);

  /* String FirstName;
  String LastName;
  String Address;
  String Birthday;
  String EmployeeID;
  String Phone;
  String Position;
  String Sex;
  String email;

  Users(this.FirstName, this.LastName, this.EmployeeID,
        this.Address, this.Birthday, this.Phone,
        this.Position, this.Sex, this.EmployeeID,
        this.FirstName, this.LastName, this.email); */

  /* Users.fromSnapshot(DataSnapshot snapshot) :
        //Key = snapshot.key,
        FirstName = snapshot.value["FirstName"],
        LastName = snapshot.value["LastName"],
        Address = snapshot.value["Address"],
        Birthday = snapshot.value["Birthday"],
        EmployeeID = snapshot.value["EmployeeID"],
        Phone = snapshot.value["Phone"],
        Position = snapshot.value["Position"],
        Sex = snapshot.value["Sex"],
        email = snapshot.value["email"];

  toJson() {
    return {
      "FirstName": FirstName,
      "LastName": LastName,
      "Address": Address,
      "Birthday": Birthday,
      "EmployeeID": EmployeeID,
      "Phone": Phone,
      "Position": Position,
      "Sex": Sex,
      "email": email,
    };
  } */
}