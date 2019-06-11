import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'utils.dart' as util;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic>  {

  Map results;
  Future showStuff(BuildContext context) async{
    results=await Navigator.of(context).push(new MaterialPageRoute<Map>(builder: (BuildContext){
      return new changeCity();
    }));

      util.defaultCity=results['info'];

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Mausam"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.menu),
              onPressed:(){ showStuff(context);})
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              "images/umbrella.png",
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9,20.9, 0.0),
            child: new Text(util.defaultCity.isEmpty?"New Delhi":"${util.defaultCity}",
            style: cityStyle(),),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(120.0, 170, 0.0, 0.0),
            child: new Image.asset(
              "images/light_rain.png"
            ),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(20.9,300, 0.0, 0.0),
            child: updateTempWidget("${util.defaultCity}")
          )
        ],
      ),

    );
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeather(util.appId, city),
        builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
          print(snapshot.toString());
          if(snapshot.hasData){
            Map content=snapshot.data;
            if(content['main']!=null)
            return new Container(
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text("Current Temp:${content["main"]["temp"].toString()}°C",
                    style: new TextStyle(color: Colors.white,fontSize: 19),),
                  ),
                  new ListTile(
                    title: new Text("Max Temp:${content["main"]["temp_max"].toString()}°C",
                      style: new TextStyle(color: Colors.white,fontSize: 19),
                    ),
                  ),
                  new ListTile(
                    title: new Text("Min Temp:${content["main"]["temp_min"].toString()}°C",
                      style: new TextStyle(color: Colors.white,fontSize: 19),
                    ),
                  ),
                  new ListTile(
                    title: new Text("Humidity:${content["main"]["humidity"].toString()}",
                      style: new TextStyle(color: Colors.white,fontSize: 19),
                    ),
                  )
                ],
              ),
            );
          else
            return Container(
              child: updateTempWidget("New Delhi"),
            );


          }else{
            return Container();
          }
        });
  }

Future<Map> getWeather(String appId,String city) async{
    String apiURL="http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${appId}&units=metric";
    http.Response response=await http.get(apiURL);
    return json.decode(response.body);
}
 TextStyle cityStyle() {
    return new TextStyle(
      color: Colors.white,
      fontSize: 25.9,
      fontStyle: FontStyle.italic
    );
 }


}

class changeCity extends StatelessWidget {
  TextEditingController citycontroller=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("City"),
        backgroundColor: Colors.redAccent,
      ),
      body: new Stack(
        children: <Widget>[
          new Image.asset("images/white_snow.png",
          width: 490,
          height: 1200,
          fit: BoxFit.fill,),
          Column(
            children: <Widget>[
              new TextField(
                textAlign: TextAlign.start,
                controller: citycontroller,
                decoration: new InputDecoration(
                  labelText: "Enter Your city",

                ),

              ),
              new RaisedButton(
                  child: new Text("Submit"),
                  color: Colors.redAccent,
                  onPressed:() {Navigator.pop(context,{
                    'info':citycontroller.text
                  });}),
            ],
          )
        ],
      ),
    );
  }
}
