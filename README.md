# Web Media Recording

A library to implement the browser [MediaRecorder](https://developer.mozilla.org/en-US/docs/Web/API/MediaRecorder) native features into the flutter web.

## Usage
```dart
  // Variables needed
  WebRecorder webRecorder;
  bool isRecording;
  
  // Usually initialized in initState
  webRecorder = WebRecorder(
    whenRecorderStart: whenRecorderStart,
    whenRecorderStop: whenRecorderStop,
    whenReceiveData: receiveData
  );
  
  // To be used to start/stop recording
  webRecorder.openRecorder(); 
  
  // A function that will return the audio data as Uint8List
  receiveData(data){
    // TODO Your logic to use this Uint8List audio data...
    print(data);
  }
  
  //Will give you the possibility to toggle a START/STOP Button
  whenRecorderStart(){
    print('Recorder Started');
    setState(() {}); 
  }
  whenRecorderStop(){
    print('Recorder Stopped'); 
    setState(() {}); 
  }
}

```

## Installation
Add this dependency your pubspec.yaml file:

```
dependencies:
  web_media_recorder: ^0.0.1
```

For more info visit [pub.dev](https://pub.dev/packages/web_media_recorder).

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/bujupah/web_media_recorder/issues


## If you wanna see my high level IQ functions go deeper
```dart

import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:flutter/material.dart';

class WebRecorder {
  static bool isNotRecording = true;
  static html.MediaRecorder recorder;

  final Function whenRecorderStart; // Function to call when recording starts
  final Function whenRecorderStop; // Function to call when recording finishs
  final Function whenReceiveData;

  WebRecorder({
      @required this.whenRecorderStart, 
      @required this.whenRecorderStop, 
      @required this.whenReceiveData
  });

  openRecorder(){
    WebRecorder.isNotRecording = !WebRecorder.isNotRecording;
    if(WebRecorder.isNotRecording)
      stopRecoring().whenComplete(whenRecorderStop);
    else
      html.window.navigator
      .getUserMedia(audio: true)
      .then((stream) {
          recorder = html.MediaRecorder(stream);
          recorder.addEventListener('dataavailable', hundlerFunctionStream);
      })
      .whenComplete((){
        startRecording().whenComplete(whenRecorderStart);
      })
      .catchError((e)=> print);
  }
  
  Future<void> startRecording(){
    WebRecorder.recorder.start();
    return Future.value(true);
  }

  Future<void> stopRecoring() async{
    WebRecorder.recorder.stop();
    return Future.value(true);
  }

  hundlerFunctionStream(event) async{
    html.FileReader reader = html.FileReader();
    html.Blob blob = js.JsObject.fromBrowserObject(event)['data'];
    reader.readAsArrayBuffer(blob);
    reader.onLoadEnd.listen((e) async {
      setData(reader.result);
    });
  }

  setData(data) => whenReceiveData(data);

  dispose(){
    WebRecorder.recorder.removeEventListener('dataavailable', hundlerFunctionStream);
    WebRecorder.recorder = null;
  }
}

```
## Negative IQ right ? 😂 😂
Do not forget to pull request into the repo if you see there is some lines of code must be changed, It would be my pleasure ❤️

## Getting Started
This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.