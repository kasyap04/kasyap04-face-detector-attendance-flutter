import 'package:flutter/material.dart';

class InputRegisterFields extends StatelessWidget{
  const InputRegisterFields({super.key, required this.controller, required this.labelText});
  final TextEditingController controller ;
  final String labelText ;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 10), 
      child:TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
          )
        ),
    ) ;
  }

}