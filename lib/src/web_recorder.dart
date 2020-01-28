
import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:flutter/material.dart';

class WebRecorder {
  static bool isNotRecording = true;
  static html.AudioElement audioElement;
  static html.MediaRecorder recorder;

  final Function whenRecorderStart; // Function to call when recording starts
  final Function whenRecorderStop; // Function to call when recording finishs
  final Function whenReceiveData;

  WebRecorder({@required this.whenRecorderStart, @required this.whenRecorderStop, @required this.whenReceiveData}){
    WebRecorder.audioElement = html.AudioElement();
  }

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
    WebRecorder.audioElement = null;
    WebRecorder.recorder.removeEventListener('dataavailable', hundlerFunctionStream);
    WebRecorder.recorder = null;
  }
}