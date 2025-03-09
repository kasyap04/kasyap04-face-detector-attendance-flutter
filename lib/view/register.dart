import 'dart:async';
import 'dart:io';

import 'package:face_attendence/components/dashboard/registration_camera.dart';
import 'package:face_attendence/components/register/inputFeilds.dart';
import 'package:face_attendence/utils/attendence.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:face_attendence/components/appBar.dart';
import 'package:face_attendence/components/dashboard/mainbutton.dart';


class Register extends StatefulWidget{
  const Register({super.key});
  

  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  int openCameraIndex = -1;
  bool loading = false ;
  late CameraController controller;
  List<File> capturedImages = [] ;
  Timer? time ;
  TextEditingController nameController = TextEditingController() ;
  TextEditingController rollNoController = TextEditingController() ;
  int imageClickCount = 0 ;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    time?.cancel() ;
    super.dispose();
  }


  void flipCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    Map<int, int> camIndex = {
        1: 0,
        0: 1
      } ;
      int newIndex = camIndex[openCameraIndex] as int ;
    setState(() {
      if(cameras.length > 1){
        controller = CameraController(cameras[newIndex], ResolutionPreset.high) ;
        openCameraIndex = newIndex ;
      }
      
    });
  }


  void openCameraPressed() async {
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
    }).catchError((Object e){
      if(e is CameraException){
      }
    }) ;
  }



  void takePictutre() async {
    time = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      XFile image = await controller.takePicture() ;
      capturedImages.add(File(image.path)) ;

      setState(() {
        imageClickCount ++ ;
      });

      if(capturedImages.length == 10){
          time?.cancel() ;
          setState(() {
            openCameraIndex = -1 ;
          });
      }

    },) ;
  }

  void upload(BuildContext ctx) async {
    String name = nameController.text ;
    String rollNo = rollNoController.text ;

    if(name.isNotEmpty && rollNo.isNotEmpty){
      AttendenceUtils utils = AttendenceUtils() ;
      setState(() {
        loading = true ;
      });
      Map result = await utils.registerStudents(capturedImages, name, rollNo) ;
      setState(() {
        loading = false ;
      });

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(result['msg']))) ;
    }
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size ;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(title: "Register student", back: true, currentContext: context),
      body: openCameraIndex > -1 ? 
      RegistrationCamera(
        controller: controller, 
        takePictutre: takePictutre, 
        size: size, 
        cameraIndex: openCameraIndex,
        flipCamera: flipCamera,
        clicksCount: imageClickCount) : 
       ListView(
        children: [
          GridView.count(
            shrinkWrap: true,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          crossAxisCount: 4,
          padding: const EdgeInsets.all(8),
          children: List.generate(10, (index){
              try{
                return Image.file(capturedImages[index]) ;
              }catch(e){
                  return Container(
                    height: 200,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1)
                    ),
                    child: Icon(Icons.image),
                ) ;
              }
              
            }),
          ),
          capturedImages.length == 10 ?
          Column(
            children: [
              InputRegisterFields(controller: nameController, labelText: "Student name"),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 20), 
                child: InputRegisterFields(controller: rollNoController, labelText: "Roll number")),
              SizedBox(
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10), 
                  child: loading ? SizedBox(width: 40, height: 40, child: Center(child: CircularProgressIndicator()))
                  : MainButton(name: "REGISTER", action: () => upload(context), width: size.width)
                ),
              )
            ],
          )
          : ElevatedButton(onPressed: openCameraPressed, child: Text("Open camera")),
        ],
      ),
    ) ;
  }
}