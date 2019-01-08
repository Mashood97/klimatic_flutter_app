import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;


class klimatic extends StatefulWidget {
  @override
  _klimaticState createState() => new _klimaticState();
}

class _klimaticState extends State<klimatic> {

String _cityEntered;
  Future _gotoNextScreen(BuildContext context) async
  {
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute(
          builder: (BuildContext context) {
            return new ChangeCity();
          }),
    );
    if(results!= null && results.containsKey('enter'))
      {
        _cityEntered = results['enter'].toString();
        //print(results['enter'].toString());
      }
  }

  // json contains start as "{" we take it as map or if its this [] we take it as a list
  void showStuff() async
  {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Klimatic"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.menu),
              onPressed: () {
                _gotoNextScreen(context);
              }
          ),
        ],
      ),

      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text('${_cityEntered ==null ? util.defaultCity : _cityEntered }',
              style: cityStyle(),
            ),
          ),

          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
          ),

          //container that will be changwe with weather data api

            //  alignment: Alignment.center,
             updateTempWidget(_cityEntered),
        ],
      ),
    );
  }

  //return get data from weather api
  Future<Map> getWeather(String appid, String city) async
  {
    String apiurl = 'http://api.openweathermap.org/data/2.5/weather?q=$city''&appid=${util
        .appId}&units=imperial';
    http.Response response = await http.get(apiurl);

    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeather(util.appId, city == null ?util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot)
        //where we want to get all of the json data we setup widgets etc.
        {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
                margin: const EdgeInsets.fromLTRB(20.0, 250.0, 0.0, 0.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    title: new Text(content['main']['temp'].toString() + " F",
                      style: new TextStyle(color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          fontSize: 49.9),),
                  subtitle: new ListTile(
                    title: new Text(
                      "Humidity: ${content['main']['humidity'].toString()}\n"
                       "Min: ${content['main']['temp_min'].toString()} F\n"
                        "Max:  ${content['main']['temp_max'].toString()} F",
                      style: extraData(),
                    ),
                  ),
                  ),

                ],
              ),
            );
          }
          else {
            return new Container();
          }
        });
  }
}

class ChangeCity extends StatelessWidget {

  var _cityFieldController =  new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Change City'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
                'images/white_snow.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),

          new ListView(
            children: <Widget>[
            new ListTile(
              title: new TextField(
                decoration: new InputDecoration(
                  hintText: 'Enter City',
                ),
                controller: _cityFieldController,
                keyboardType: TextInputType.text,
              ),
            ),
              new ListTile(
              title: new FlatButton(
                  onPressed: () {
                    Navigator.pop(context,{
                      'enter': _cityFieldController.text,
                    });
                  },
                  color:Colors.red ,
                  textColor: Colors.white,
                  child: new Text("Get Weather"),),
    )
            ],
          ),


        ],
      ),
    );
  }
}

//a textstyle for city
TextStyle cityStyle() {
  return new TextStyle(
      color: Colors.white,
      fontSize: 22.9,
      fontStyle: FontStyle.italic);
}

TextStyle extraData()
{
  return new TextStyle(
      color: Colors.white70,
      fontSize: 17.0,
      fontStyle: FontStyle.normal);
}

TextStyle tempStyle() {
  return TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9,
  );
}