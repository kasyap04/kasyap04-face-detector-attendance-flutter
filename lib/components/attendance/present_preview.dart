import 'package:face_attendence/utils/constant.dart';
import 'package:flutter/material.dart';


class StudentPresentPreview extends StatelessWidget{
  const StudentPresentPreview({super.key});


  Widget bigText(String text){
    return Text(text, style: TextStyle(fontSize: 28, color: primaryColor, fontWeight: FontWeight.bold),) ;
  }

  Widget smallText(String text){
    return Text(text, style: TextStyle(fontSize: 12, color: Colors.grey),) ;
  }

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            bigText("Vishnu"),
            smallText("Name")
          ],
        ),
        Column(
          children: [
            bigText("21"),
            smallText("Roll no")
          ],
        )
      ],
    ) ;
  }
}