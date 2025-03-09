import 'package:flutter/material.dart';


class DummyCamera extends StatelessWidget{
  const DummyCamera({super.key, required this.size, required this.displayText, this.onPresses});
  final Size size ;
  final String displayText ;

  final void Function()? onPresses ;

  @override
  Widget build(BuildContext context){
    return Container(
      height: size.width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: InkWell(
        onTap: onPresses,
        child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, size: 50),
          Text(displayText)
        ],
      )),
      )
    ) ;
  }
}