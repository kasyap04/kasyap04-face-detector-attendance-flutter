import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_attendence/components/attendance/camera_preview.dart';
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
  int attant_tries = 0 ;

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
    print('working----------------------') ;
    if([0, 1].contains(openCameraIndex) && attant_tries <= 10){
      XFile taken = await controller.takePicture() ;
      File image = File(taken.path) ;
      attant_tries ++ ;
      print("TAKEN $image") ;
      Map result = await utils.makeAttendance(image) ;
      if(!result['status']){
        await startCaptureImages() ;
      }
    }
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
        children: [
          [0, 1].contains(openCameraIndex) ?
          SizedBox(
            height: size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CameraPreview(controller),
            ),
          )
          : DummyCamera(size: size)
        ],
      ),
    ) ;
  }
}