import 'package:firebase_database/firebase_database.dart';
 
class Location {
  String _location_id;
  String _photo;
  String _date;
  String _time;
  String _status;
  String _user_id;
 
  Location(this._location_id, this._photo, this._date, this._time, this._status, this._user_id);
 
  /* Location.map(dynamic obj) {
    this._location_id = obj['location_id'];
    this._photo = obj['photo'];
    this._date = obj['date'];
    this._time = obj['time'];
    this._status = obj['status'];
    this._user_id = obj['user_id'];
  } */
 
  String get location_id => _location_id;
  String get photo => _photo;
  String get date => _date;
  String get time => _time;
  String get status => _status;
  String get user_id => _user_id;
 
  /* Location.fromSnapshot(DataSnapshot snapshot) {
    _location_id = snapshot.value['location_id'];
    _photo = snapshot.value['photo'];
    _date = snapshot.value['date'];
    _time = snapshot.value['time'];
    _status = snapshot.value['status'];
    _user_id = snapshot.value['user_id'];
  } */
}