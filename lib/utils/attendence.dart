import 'dart:io';

import 'package:intl/intl.dart' ;
import 'package:face_attendence/utils/api.dart';


class AttendenceUtils{
  static ApiService api = ApiService() ;


  Future<dynamic> getAttendence(String? date) async {
    date ??= DateFormat("yyyy-MM-dd").format(DateTime.now());
    
    Map<String, dynamic> data = {
      "date": date
    } ;

    List<Map> attendence = [] ;

    dynamic result = await api.post("attendence/", data) ;
    if(result['status'] != true){
      return attendence ;
    }
  
    List students = result['data']['students'] ;
    List attend = result['data']['attendence'] ;
    
    for(Map<String, dynamic> stu in students){
      if(attend.contains(stu['id'])){
        attendence.add({
          'name': stu['name'],
          'attendence': 'Present'
        }) ;
      } else {
        attendence.add({
          'name': stu['name'],
          'attendence': 'Absent'
        }) ;
      }
    }

    return attendence ;
  }

  Future<Map> registerStudents(List<File> images, String name, String rollNo) async {
    Map<String, dynamic> data = {
      "name": name,
      "roll_no": rollNo
    } ;
    Map result = await api.withUploadImage("register/", images, data) ;
    return result ;
  }

  
  Future<Map> makeAttendance(File image) async {
    Map result = await api.checkAttendance("attendence/check", image) ;
    return result ;
  }

}