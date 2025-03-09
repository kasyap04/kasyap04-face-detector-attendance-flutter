import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


class RegistrationCamera extends StatefulWidget{
   const RegistrationCamera({super.key, 
    required this.controller, 
    required this.takePictutre, 
    required this.size,
    required this.cameraIndex, 
    required this.flipCamera,
    required this.clicksCount
  });

   final CameraController controller ;
   final void Function() takePictutre ;
   final void Function() flipCamera ;
   final Size size ;
   final int cameraIndex ;
   final int clicksCount ;

   @override
   State<RegistrationCamera> createState() => RegistrationCameraState() ;
}


class RegistrationCameraState extends State<RegistrationCamera> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Image taken: ${widget.clicksCount}/10"),
            IconButton(onPressed: widget.flipCamera, icon: Icon(Icons.flip_camera_ios_rounded))
          ],
        ),),
        SizedBox(
          height: widget.size.height - 190,
          child: CameraPreview(widget.controller),
        ),
        ElevatedButton(onPressed: widget.takePictutre, child: Text("Take picture")),
      ],
    ) ;
  }
  
}