import 'package:flutter/material.dart';
import 'package:face_attendence/components/dashboard/attendence.dart';
import 'package:face_attendence/components/dashboard/mainbutton.dart';
import 'package:face_attendence/view/register.dart';
import 'package:face_attendence/view/mark_attendance.dart';
import 'package:face_attendence/components/appBar.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    void navigateRegisterStudent() async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Register()),
      );
      setState(() {});
    }

    void navigateTakeAttendance() async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MarkAttendance()),
      );
      setState(() {});
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(title: "Attendence system",  back: false, currentContext: context),
      body: Column(
      children: [
        SizedBox(
          width: size.width,
          height: size.height - 160,
          child: Attendence(size: size),
        ),
        Divider(),
        Row(
          children: [
            MainButton(name: "Register", action: navigateRegisterStudent, width: size.width / 2),
            MainButton(
              name: "Mark Attendance",
              action: navigateTakeAttendance,
              width: size.width / 2,
            ),
          ],
        ),
      ],
    ),
    );
  }
}
