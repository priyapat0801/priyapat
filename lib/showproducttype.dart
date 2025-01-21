import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onlineap_mink/showfiltertype.dart';

//Method หลักทีRun
void main() {
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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 164, 196)),
        useMaterial3: true,
      ),
      home: showproducttype(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class showproducttype extends StatefulWidget {
  @override
  State<showproducttype> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showproducttype> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
  // สร้าง reference ไปยัง Firebase Realtime Database
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<String> categories = []; // List เพื่อเก็บประเภทสินค้าต่างๆ

  Future<void> fetchCategories() async {
    try {
      //ใส่โค้ดที่ต้องการกรองข้อมูลตรงนี้
// ดึงข้อมูลจาก Realtime Database
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        Set<String> categorySet = Set(); // ใช้ Set เพื่อหลีกเลี่ยงการซ้ำ
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          // ตรวจสอบว่ามีข้อมูลประเภทสินค้าหรือไม่
          if (product.containsKey('category')) {
            categorySet.add(product['category']); //ดึงcategory
          }
        });
        setState(() {
          categories = categorySet.toList(); //อัปเดตรายการประเภท
        });
      } else {
        print("ไม่พบข้อมูลสินค้าในฐานข้อมูล");
      }
    } catch (e) {
      print("Error loading categories: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

//ฟังก์ชันสำหรับการเปิดแอปพลิเคชั่นมาแล้วรันเลย
  @override
  void initState() {
    super.initState();
    fetchCategories(); // เรียกใช้เมื่อ Widget ถูกสร้าง
  }

//ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ประเภทสินค้า',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255)), // กำหนดสีของข้อความ
        ),
        backgroundColor: Color.fromARGB(255, 124, 10, 54), // ใส่สีที่ต้องการ
      ),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  EdgeInsets.all(10), // ระยะห่างระหว่าง AppBar และเนื้อหาภายใน
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // จํานวนคอลัมน์
                  crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
                  mainAxisSpacing: 10, // ระยะห่างระหว่างแถว
                ),
                itemCount: categories.length, // จํานวนรายการ
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              showfiltertype(category: category),
                        ),
                      );
//รอใส่codeว่ากดแล้วเกิดอะไรขึ้น
                    },
                    child: Card(
                      elevation: 5, // ความสูงของเงา (ช่วยเพิ่มมิติ)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // ขอบมน
                      ),
                      child: Center(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(16.0), // เพิ่มระยะขอบภายใน
                          child: SizedBox(
                            width: 100, // กำหนดความกว้างของการ์ด
                            height: 80, // กำหนดความสูงของการ์ด
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 16, // ขนาดฟอนต์
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          10), // ระยะห่างระหว่างข้อความและไอคอน
                                  Icon(
                                    Icons.shopping_cart, // ไอคอนรถเข็น
                                    size: 30, // ขนาดของไอคอน
                                    color: Color.fromARGB(
                                        255, 158, 6, 52), // สีของไอคอน
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
