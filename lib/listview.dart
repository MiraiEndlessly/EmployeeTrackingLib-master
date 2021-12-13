import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';

void main() => runApp(new MyListViewApp());

class MyListViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'หน้าหลัก'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future _data;

  Future getPosts() async {
    var firestore = Firestore.instance;
    // ignore: deprecated_member_use
    QuerySnapshot qn = await firestore.collection("trip").getDocuments();
    // ignore: deprecated_member_use
    return qn.documents;
  }

  void initState() {
    super.initState();
    _data = getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _data,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Loading ...'),
              );
            } else {
              /* return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    var Id = snapshot.data[index]["id"];
                    var Title = snapshot.data[index]["title"];
                    var Price = snapshot.data[index]["price"];
                    var Night = snapshot.data[index]["nights"];
                    var Img = snapshot.data[index]["img"];
                    return ListTile(
                      onTap: () {
                        final trip = Trip(title: Title, price: Price, nights: Night,img: Img);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details(trip: trip)));
                      },
                      onLongPress: () {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: const Text('กรุณาเลือกคำสั่ง'),
                                children: [
                                  SimpleDialogOption(
                                    onPressed: () {
                                      Toast.show("แก้ไข", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('แก้ไขข้อมูล'),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("product")
                                          .doc(Id)
                                          .delete();
                                      /* Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new Launcher()),
                                      ); */
                                      Toast.show("ลบ", context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM);
                                    },
                                    child: const Text('ลบข้อมูล'),
                                  )
                                ],
                              );
                            });
                      },
                      contentPadding: EdgeInsets.all(25),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${Night} nights',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[300])),
                          Text(Title,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.grey[600])),
                        ],
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Hero(
                          tag: 'location-img-${Img}',
                          child: Image.asset(
                            'images/${Img}',
                            height: 50.0,
                          ),
                        ),
                      ),
                      trailing: Text('\$${Price}'),
                    ); 
                  });*/
            }
          }),
    );
  }
}

/**/
