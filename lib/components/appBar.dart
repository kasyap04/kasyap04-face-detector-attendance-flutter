// ignore: file_names
import 'package:flutter/material.dart';
import 'package:face_attendence/utils/constant.dart';

// ignore: must_be_immutable
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarWidget({super.key, required this.back, this.currentContext, required this.title});

  final String title ;
  late BuildContext? currentContext ;
  final bool back ;

  @override
  Size get preferredSize => const Size.fromHeight(50) ;

  void goBack(){
    Navigator.of(currentContext!).pop() ;
  }

  @override
  Widget build(BuildContext context){
    return AppBar(
      elevation: 1,
      centerTitle: true,
      title: Text(title, style: TextStyle(color: primaryColor),),
      backgroundColor: Colors.white,
      leading: back ? IconButton(onPressed: goBack, icon:const Icon(Icons.arrow_back_ios), color: primaryColor,) : null,
    ) ;
  }

}