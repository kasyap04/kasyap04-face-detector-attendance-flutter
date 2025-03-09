import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'constant.dart';


class ApiService{
  static Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    } ;

  Future<Map> post(String path, Map<String, dynamic> body) async {
    try{
      dynamic uri = Uri.parse("$API$path");

      http.Response response = await http.post(
        uri,
        headers: headers,
        body: body
      ) ;

      late Map result ;

      if(response.statusCode == 200){
        result = jsonDecode(response.body) ;
      } else {
        result = {
          'status': false
        } ;
      }

      return result ;

    } catch(e){
      return {'status': false} ;
    }
  }


  Future<Map> withUploadImage(String path, List<File> images, Map<String, dynamic> data) async {
    try{
        final uri = Uri.parse("$API$path");

        final request = http.MultipartRequest('POST', uri) ;
        request.fields['name'] = data['name'] ;
        request.fields['roll_no'] = data['roll_no'] ;
        for(int i = 0; i < images.length; i++){
          request.files.add(
            await http.MultipartFile.fromPath("image$i", images[i].path)
          ) ;
        }

        final response = await request.send() ;
    
        final res = await response.stream.bytesToString() ;
        Map resData = jsonDecode(res) as Map ; 
        
        return resData ;  

    } catch(e){
        return {'status': false, 'msg': e.toString()} ;                                    
    }
  }



  Future<Map> checkAttendance(String path, File image) async {
    try{
      final uri = Uri.parse("$API$path");
      final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath("image", image.path)) ;

      final response = await request.send() ;
      final res = await response.stream.bytesToString() ;
      Map resData = jsonDecode(res) as Map ; 

      return resData ;
    }catch(e){
      return {'status': false, 'msg': e.toString()} ;  
    }
  }

}