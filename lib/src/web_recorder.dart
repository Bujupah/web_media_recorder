
import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:flutter/material.dart';


/// This class is using [html.MediaRecorder] natively and parse its data to the flutter
/// ```
/// class WebRecorder {
///   static bool isNotRecording = true;
/// 
///   final Function whenRecorderStart; 
///   final Function whenRecorderStop;
///   final Function whenReceiveData;
///   
///   openRecorder();
/// }
/// ```
class WebRecorder {
  static bool isNotRecording = true;
  static html.MediaRecorder recorder;

  final Function whenRecorderStart; 
  final Function whenRecorderStop;
  final Function whenReceiveData;


  /// @param whenRecorderStart is the function to use when recording starts.
  /// @param whenRecorderStop is the function to use when recording finishs.
  /// @param whenReceiveData is the function to use to return data from.
  /// 
  WebRecorder({@required this.whenRecorderStart, @required this.whenRecorderStop, @required this.whenReceiveData});

  /// A switcher function to start/stop audio recording.
  /// ```
  /// openRecorder(){
  ///   WebRecorder.isNotRecording = !WebRecorder.isNotRecording;
  ///   if(WebRecorder.isNotRecording)
  ///     stopRecoring().whenComplete(whenRecorderStop);
  ///   else
  ///     html.window.navigator
  ///     .getUserMedia(audio: true)
  ///     .then((stream) {
  ///         recorder = html.MediaRecorder(stream);
  ///         recorder.addEventListener('dataavailable', hundlerFunctionStream);
  ///     })
  ///     .whenComplete((){
  ///       startRecording().whenComplete(whenRecorderStart);
  ///     })
  ///     .catchError((e)=> print);
  /// }
  /// ```
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

  /// A function hundler that waits for [html.MediaStream] data
  /// and then transform it to a [html.Blob] with [js.JsObject]
  /// subsequently read it with [html.FileReader] to transform
  /// into [Uint8List] data
  /// ```  
  /// hundlerFunctionStream(event) async{
  ///   html.FileReader reader = html.FileReader();
  ///   html.Blob blob = js.JsObject.fromBrowserObject(event)['data'];
  ///   reader.readAsArrayBuffer(blob);
  ///   reader.onLoadEnd.listen((e) async {
  ///     setData(reader.result);
  ///   });
  /// }
  /// ```
  hundlerFunctionStream(event) async{
    html.FileReader reader = html.FileReader();
    html.Blob blob = js.JsObject.fromBrowserObject(event)['data'];
    reader.readAsArrayBuffer(blob);
    reader.onLoadEnd.listen((e) async {
      setData(reader.result);
    });
  }

  /// Send [html.AudioRecorder] data to the created function [whenReceiveData].
  setData(data) => whenReceiveData(data);

  /// Dispose this [html.MediaRecorder]
  dispose(){
    WebRecorder.recorder.removeEventListener('dataavailable', hundlerFunctionStream);
    WebRecorder.recorder = null;
  }
}