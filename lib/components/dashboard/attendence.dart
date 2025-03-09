import 'package:flutter/material.dart';
import 'package:intl/intl.dart' ;
import 'package:face_attendence/utils/attendence.dart';


class Attendence extends StatefulWidget {
  const Attendence({super.key, required this.size});
  final Size size;

  @override
  State<Attendence> createState() => AttendenceState();
}

class AttendenceState extends State<Attendence> {
  String todayDate = "select date";
  String? actualDate ;
  DateTime? selectedDate;

  AttendenceUtils attendenceUtils = AttendenceUtils() ;

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now() ;
    var formatter = DateFormat('dd MMM, yyyy');
    todayDate = formatter.format(today);
    actualDate = DateFormat("yyyy-MM-dd").format(today) ;
  } 

  void onDatePressed() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    );

    if(pickedDate != null){
      setState(() {
        todayDate = DateFormat('dd MMM, yyyy').format(pickedDate) ;
        actualDate = DateFormat("yyyy-MM-dd").format(pickedDate) ;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: widget.size.width,
      child: Column(
        children: [
          TextButton(onPressed: onDatePressed, child: Row(
            children: [
              Text(todayDate),
              const Padding(padding: EdgeInsets.only(left: 5)),
              Icon(Icons.calendar_month)
            ])
          ),

          SizedBox(
            height: widget.size.height - 210,
            width: widget.size.width - 20,
            child: FutureBuilder(
              future: attendenceUtils.getAttendence(actualDate), 
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return Center(child: Text("Loading attendence...", style: TextStyle(color: Colors.grey))) ;
                }

                dynamic result = snapshot.data ;
                if(result.isEmpty){
                  return Center(child: Text("No attendence for $todayDate", style: TextStyle(color: Colors.grey))) ;
                }

                List<TableRow> tableRows = [TableRow(
                    children: [
                      Text("S.no", style: TextStyle(color: Colors.grey)),
                      Text("Name", style: TextStyle(color: Colors.grey)),
                      Text("Roll no", style: TextStyle(color: Colors.grey)),
                      Text("attendence", style: TextStyle(color: Colors.grey))
                    ]
                  )] ;
                for(int i = 0; i < result.length; i++){
                  tableRows.add(TableRow(
                    children: [
                      Text((i + 1).toString()),
                      Text(result[i]['name']),
                      Text(result[i]['roll_no']),
                      Text(result[i]['attendence'])
                    ]
                  )) ;
                  
                }

                return ListView(
                  children: [Table(
                    columnWidths: {
                      0: FractionColumnWidth(0.2),
                      1: FractionColumnWidth(0.2),
                      2: FractionColumnWidth(0.3)
                    },
                  children: tableRows,
                ) ],
                );
                
              }
          )
          )
              
        ],
      ),
    );
  }
}
