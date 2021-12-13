import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:tracking/home_page.dart';

class DropDown extends StatefulWidget {
  DropDown() : super();

  final String title = "";

  @override
  DropDownState createState() => new DropDownState();
}

class leavecase {
  int id;
  String name;

  leavecase(this.id, this.name);

  static List<leavecase> getCompanies() {
    return <leavecase>[
      leavecase(1, 'ลากิจ'),
      leavecase(2, 'ลาป่วย'),
      leavecase(3, 'พักร้อน'),
      leavecase(4, 'การลาหยุดเพื่อดูแลครอบครัว'),
      leavecase(5, 'ลาคลอด'),
      leavecase(6, 'ลาไปเรียนต่อ'),
      leavecase(7, 'ลาไปแต่งงาน'),
    ];
  }
}

class DropDownState extends State<DropDown> {
  final mDatabase = FirebaseDatabase.instance.reference().child("leave");

  List<leavecase> _companies = leavecase.getCompanies();
  List<DropdownMenuItem<leavecase>> _dropdownMenuItems;
  leavecase _selectedleave;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedleave = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<leavecase>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<leavecase>> items = List();
    for (leavecase company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(leavecase selectedCompany) {
    setState(() {
      _selectedleave = selectedCompany;
      print(_selectedleave.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("หน้าลางาน"),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('กรุณาเลือกหัวข้อการลา',
                      style: new TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: 300.0,
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton(
                        value: _selectedleave,
                        items: _dropdownMenuItems,
                        onChanged: onChangeDropdownItem,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: new TextFormField(
                    maxLines: 1,
                    autofocus: false,
                    controller: commentController,
                    decoration: new InputDecoration(
                      hintText: 'คำอธิบายเพิ่มเติม',
                    ),
                  ),
                ),
                /* Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Test".split(' ')[0]/*"${selectedDate.toLocal()}".split(' ')[0]*/,
                      style:
                          TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      onPressed: () => _selectDate(context), // Refer step 3
                      child: Text(
                        'Select date',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.greenAccent,
                    ),
                  ],
                ), */
                SizedBox(
                  height: 10.0,
                ),
                Container(
                    height: 50,
                    width: 300,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text(
                        'บันทึกข้อมูล',
                        style: new TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () {
                        save_data(context);
                      },
                    )),
              ],
            )));
  }

  _selectDate(BuildContext context) async {
    /*final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      }); */
  }

  void save_data(BuildContext context) async {
    var date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    var time = DateFormat('kk:mm').format(DateTime.now()) + " น.";
    var comment = commentController.text.trim().toString();
    var leave = _selectedleave.name;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString("user_id");

    mDatabase
        .child(user_id)
        .child(date)
        .once()
        .then((DataSnapshot snapshot) async {
      var data = '${snapshot.value}';

      if (data == "null") {
        mDatabase.child(user_id).child(date).set({
          'leave': leave,
          'comment': comment,
          'date': date,
          'time': time,
          'user_id': user_id
        });

        Toast.show("บันทึกข้อมูลสำเร็จ", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Toast.show("เพิ่มข้อมูลการลาได้แค่วันละ 1 ครั้ง", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage()));
        return;
      }
    });
  }
}
