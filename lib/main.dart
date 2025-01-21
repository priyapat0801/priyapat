import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onlineap_mink/showproducttype.dart';
import 'addproduct.dart';
import 'showproductgrid.dart';

//Method หลักทีRun
void main() async {
  //ทำตรงนี้หน้าเดียวเชื่อมกับfirebase
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDwmTMRxjFCEwyrRrYjA2J_VEUK_545A4o",
            authDomain: "onlinefirebase-b70cd.firebaseapp.com",
            databaseURL:
                "https://onlinefirebase-b70cd-default-rtdb.firebaseio.com",
            projectId: "onlinefirebase-b70cd",
            storageBucket: "onlinefirebase-b70cd.firebasestorage.app",
            messagingSenderId: "470291438854",
            appId: "1:470291438854:web:34a2db0fee8d5264709287",
            measurementId: "G-XP29KJ009Z"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

//Class stateless สั่งแสดงผลหนาจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 164, 196)),
        useMaterial3: true,
      ),
      home: Main(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป

//ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูหลัก'),
        backgroundColor: Color.fromARGB(255, 124, 10, 54),
        foregroundColor: Colors.white, // ใส่สีที่ต้องการ
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 249, 213, 223), // สีพื้นหลัง
        ),
        width: double.infinity, // กำหนดให้ครอบคลุมเต็มความกว้าง
        height: double
            .infinity, // กำหนดให้ครอบคลุมเต็มความสูงSingleChildScrollView(
//ส่วนการออกแบบหน้าจอ
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Center content vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Make buttons the same width
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 50.0,
                    right: 50.0,
                    top: 20.0), // เพิ่ม padding ด้านซ้ายและขวา
                child: Image.asset(
                  'assets/logo1.png', // ใส่ที่อยู่ของไฟล์รูปภาพ
                  width: 150, // ขนาดของรูปภาพ
                  height: 150, // ขนาดของรูปภาพ
                  fit: BoxFit.cover, // ให้รูปภาพเต็มขนาดที่กำหนด
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => addproduct()),
                    );
                  },
                  child: Text('จัดการข้อมูลสินค้า'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 124, 10, 54), // สีพื้นหลัง (พื้นหลังของปุ่ม)
                    foregroundColor:
                        Colors.white, // สีข้อความ (สีข้อความภายในปุ่ม)
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => showproductgrid()),
                    );
                  },
                  child: Text('แสดงข้อมูลสินค้า'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 124, 10, 54), // สีพื้นหลัง (พื้นหลังของปุ่ม)
                    foregroundColor:
                        Colors.white, // สีข้อความ (สีข้อความภายในปุ่ม)
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => showproducttype()),
                    );
                  },
                  child: Text('ประเภทสินค้า'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 124, 10, 54), // สีพื้นหลัง (พื้นหลังของปุ่ม)
                    foregroundColor:
                        Colors.white, // สีข้อความ (สีข้อความภายในปุ่ม)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
