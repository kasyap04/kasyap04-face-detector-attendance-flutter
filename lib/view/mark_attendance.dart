import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_attendence/components/attendance/camera_preview.dart';
import 'package:face_attendence/components/attendance/present_preview.dart';
import 'package:face_attendence/utils/attendence.dart';
import 'package:flutter/material.dart';
import 'package:face_attendence/components/appBar.dart';


class MarkAttendance extends StatefulWidget{
  const MarkAttendance({super.key}) ;

  @override
  State<MarkAttendance> createState() => MarkAttendanceState() ;
}


class MarkAttendanceState extends State<MarkAttendance> {
  final AttendenceUtils utils = AttendenceUtils() ;
  late CameraController controller;
  int openCameraIndex = -1 ;
  int attantTries = 0 ;
  late File studentImage ;
  Map<dynamic, dynamic> studentDetails = {} ;


  void turnCameraOn() async {
    List<CameraDescription> cameras = await availableCameras();
    int ci = cameras.length > 1 ? 1 : 0 ;
    controller = CameraController(cameras[ci], ResolutionPreset.high);
    controller.initialize().then((_){
      if(!mounted){
        return ;
      }
      setState(() {
        if(cameras.length > 1){
          openCameraIndex = 1 ;
        } else{
          openCameraIndex = 0 ;
        }
      });
      startCaptureImages() ;
    }).catchError((Object e){
      if(e is CameraException){
        
      }
    }) ;
  }


  Future<void> startCaptureImages() async {
    if([0, 1].contains(openCameraIndex) && attantTries <= 10){
      XFile taken = await controller.takePicture() ;
      File image = File(taken.path) ;
      attantTries ++ ;
      Map result = await utils.makeAttendance(image) ;
      if(result['status']){
        setState(() {
          studentDetails = result ;
          studentImage = image ;
        });
      } else {
        await startCaptureImages() ;
      }
    }

    if(attantTries >= 10){
      setState(() {});
    }
  }


  void resetCamera() {
    setState(() {
        studentDetails = {} ;
        attantTries = 0 ;
        openCameraIndex = -1 ;
      });
  }

  List<Widget> getDisplayWidget(Size size){
    if(attantTries >= 10){
      return [DummyCamera(
        size: size, 
        displayText: "Click to open camera",
        onPresses: resetCamera) ] ;
    }

    if(studentDetails.isNotEmpty){
      return [
        Image.file(studentImage, height: 300,),
        const Padding(padding: EdgeInsets.only(bottom: 50)),
        StudentPresentPreview(name: studentDetails['name'], rollNo: studentDetails['roll_no'],),
        const Padding(padding: EdgeInsets.only(bottom: 50)),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Center(child: Text('Present', style: TextStyle(fontSize: 40, color: Colors.green))),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        OutlinedButton(onPressed: resetCamera, child: Text("Next"))
      ] ;
    }

    if([0, 1].contains(openCameraIndex)){
      return [SizedBox(
            height: size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CameraPreview(controller),
            ),
          )] ;
    }


    return [DummyCamera(size: size, displayText: "Opening camera..",)] ;

  }
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context){
    if(openCameraIndex == -1){
      turnCameraOn() ;
    }

    Size size = MediaQuery.of(context).size ;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(back: true, title: 'Take attendence', currentContext: context),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: getDisplayWidget(size),
      ),
    ) ;
  }
}