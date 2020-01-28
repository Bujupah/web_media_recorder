import 'package:flutter/material.dart';
import 'package:web_media_recorder/web_media_recorder.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: WebMediaRecorder(),
    );
  }
}


class WebMediaRecorder extends StatefulWidget {
  @override
  _WebMediaRecorderState createState() => _WebMediaRecorderState();
}

class _WebMediaRecorderState extends State<WebMediaRecorder> {
  WebRecorder webRecorder;
  bool isRecording;
  
  @override
  void initState() {
    super.initState();
    webRecorder = WebRecorder(
      whenRecorderStart: whenRecorderStart,
      whenRecorderStop: whenRecorderStop,
      whenReceiveData: receiveData
    );
  }

  @override
  void dispose(){
    super.dispose();
    webRecorder.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FlatButton(
          onPressed: () {
            webRecorder.openRecorder();
          },
          child: Text(
            !WebRecorder.isNotRecording ? "Stop":"Start",
            style: Theme.of(context).textTheme.display1
          ),
          color: Colors.blue,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          splashColor: Colors.blueAccent,
        ),
      ),
    );
  }

  receiveData(data){
    // audio data as Uint8List
    print(data);
  }

  whenRecorderStart(){
    print('Recorder Started');
    setState(() {});
  }

  whenRecorderStop(){
    print('Recorder Stopped'); 
    setState(() {});
  }
}