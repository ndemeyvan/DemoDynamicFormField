import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'constant.dart';

class fromdata extends StatefulWidget {
  const fromdata({Key? key}) : super(key: key);

  @override
  _fromdataState createState() => _fromdataState();
}

class _fromdataState extends State<fromdata> {
  int ids = -1;
  List<Map<String, Object>> requestArray = [];
  List<Map<String, Object>> fieldRedponseArray = [];
  List selectdata = List<String>.empty(growable: true);
  List radiotdata = List<String>.empty(growable: true);
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey();

    apirequest();
  }

  var url = Uri.parse(
      'https://stoplight.io/mocks/khurramsoftware/data/20414976/getdata');

//getapidata
  apirequest() async {
    // final response = await http.get(url) ;
    var data = {
      "success": true,
      "service_name": "Evaluation de produit",
      "image_url":
          "https://images.unsplash.com/photo-1461749280684-dccba630e2f6?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
      "fields": [
        {"id": "user_name", "name": "Quel est votre nom", "type": "text"},
        {"id": "phone_id", "name": "telephone", "type": "number"},
        {
          "id": "ville_id",
          "name": "Qu'elle est votre ville de residence",
          "type": "select",
          "options": [
            {"text": "Douala", "value": "Douala"},
            {"text": "Yaounde", "value": "Yaounde"},
            {"text": "Kribi", "value": "Kribi"}
          ]
        },
        {
          "id": "send_now",
          "name": "Vous aimez le produit suivant MAMI BEIGNET?",
          "type": "radio",
          "options": [
            {"text": "Oui", "value": "Oui"},
            {"text": "Non", "value": "Non"},
            {"text": "Je ne sais pas", "value": "Je ne sais pas"}
          ]
        }
      ]
    };
    var array = data['fields'] as List<Map<String, Object>>;
    requestArray = array;
    array.forEach((element) {
      fieldRedponseArray.add({
        "id": element["id"].toString(),
        "name": element["name"].toString(),
      });
    });
    print("########## This is the data save by array : $requestArray");
    print("########## This is the data save by array length : ${requestArray.length}");
    print(
        "########## This is the dfieldRedponseArray by array : $fieldRedponseArray");
    print(
        "########## This is the dfieldRedponseArray by array length : ${fieldRedponseArray.length}");
    return data;
  }

//dynamic row
  _row(int index, name, field_type, id, field_data) {
    var _mySelection;
    field_type == "select" ? selectdata = field_data : selectdata;
    field_type == "radio" ? radiotdata = field_data : radiotdata;
    if (field_type == "select") {
      return Container(
        padding: const EdgeInsets.fromLTRB(28, 15, 28, 28),
        child: InputDecorator(
            decoration: InputDecoration(
              labelText: name,
              focusColor: Colors.blue,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: new BorderRadius.circular(10.0),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: new BorderRadius.circular(20.0),
              ),
            ),
            child: Center(
                child: new DropdownButton(
              style: TextStyle(color: Colors.black),
              autofocus: true,
              hint: Text(fieldRedponseArray[index]["reponse"]==null ? "Select $name" : fieldRedponseArray[index]["reponse"].toString()),
              items: selectdata.map((t) {
                return new DropdownMenuItem(
                  child: new Text(t["text"]),
                  value: t["value"],
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _mySelection = newVal;
                  print(_mySelection);
                  makeToast("${newVal.toString().toUpperCase()} : SELECTED");
                  fieldRedponseArray[index]["reponse"] = "$newVal";
                  print("######### This is the index in the array : $index");
                  print(
                      "###### ### This is the fieldRedponseArray reponse : $newVal");
                });
              },
              value: _mySelection,
            ))),
      );
    } else if (field_type == "radio") {
      return Container(
        padding: const EdgeInsets.fromLTRB(28, 15, 28, 28),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: name,
            fillColor: Colors.blue,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: new BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: new BorderRadius.circular(20.0),
            ),
          ),
          child: Column(
            children: radiotdata.map((data) {
              var inde = radiotdata.indexOf(data);
              return RadioListTile(
                title: Text("${data["text"]}"),
                groupValue: inde,
                // toggleable: true,
                // controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.lightBlue,
                autofocus: true,
                value: ids,
                onChanged: (val) {
                  setState(() {
                    print(inde);
                    ids = inde;
                    fieldRedponseArray[index]["reponse"] = "${ids+1}";
                    print("######### This is the index in the array : $index");
                    print("######### This is the val in the  : $val");
                    print(
                        "######### This is the fieldRedponseArray reponse : $fieldRedponseArray");
                  });
                },
              );
            }).toList(),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(28, 15, 28, 28),
        child: TextFormField(
          keyboardType: field_type == "number" && id == "amount"
              ? TextInputType.numberWithOptions(decimal: true)
              : field_type == "text"
                  ? TextInputType.text
                  : TextInputType.phone,
          inputFormatters: [
            field_type == "number" && id == "amount"
                ? FilteringTextInputFormatter.allow(RegExp("[. 0-9]"))
                : field_type == "text"
                    ? FilteringTextInputFormatter.allow(
                        RegExp("[a-z A-Z á-ú Á-Ú 0-9]"))
                    : FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            labelText: name,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: new BorderRadius.circular(10.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.black),
            ),
            labelStyle: TextStyle(),
          ),
          onChanged: (val) {
            fieldRedponseArray[index]["reponse"] = "$val";
            print("######### This is the index in the array : $index");
            print(
                "######### This is the fieldRedponseArray reponse : $fieldRedponseArray");
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: FutureBuilder(
            future: apirequest(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Container(
                  child: Text('error'),
                );
              }
              if (snapshot.data != null) {
                return Column(children: [
                  SizedBox(
                    height: 40,
                  ),

                  Text(snapshot.data['service_name']),
                  SizedBox(
                    height: 5,
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return _row(
                            index,
                            snapshot.data!['fields'][index]["name"],
                            snapshot.data!['fields'][index]["type"],
                            snapshot.data!['fields'][index]["id"],
                            snapshot.data!['fields'][index]["options"]);
                      }),
                  GestureDetector(
                    onTap: () {
                      List<Map<String, Object>> finalResponseArray = [];
                      for(int i=0 ; i<requestArray.length;i++){
                        print("Itteration :$i");
                        finalResponseArray.add(fieldRedponseArray[i]);
                        print("finalResponseArray[i] :${finalResponseArray[i]}");

                      }
                      makeToast(finalResponseArray.toString());
                      print("############ This is the finalResponseArray data : $finalResponseArray");
                      print("############ This is the finalResponseArray data length : ${finalResponseArray.length}");
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Text(
                        "See Dynamic Reponse value",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ]);
              }
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ),
    );
  }
}
