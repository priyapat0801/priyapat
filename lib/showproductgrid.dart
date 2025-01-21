import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
      home: showproductgrid(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class showproductgrid extends StatefulWidget {
  @override
  State<showproductgrid> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showproductgrid> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
// สร้าง reference ไปยัง Firebase Realtime Database
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      //ใส่โค้ดที่ต้องการกรองข้อมูลตรงนี้
// ดึงข้อมูลจาก Realtime Database
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
// วนลูปเพื่อแปลงข้อมูลเป็ น Map
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // เก็บ key สําหรับการอ้างอิง (เช่นการแก้ไข/ลบ)
          loadedProducts.add(product);
        });
        // **เรียงลําดับข้อมูลตามราคา จากมากไปน้อย**
        loadedProducts.sort((a, b) => a['price'].compareTo(b['price']));
// อัปเดต state เพื่อแสดงข้อมูล
        setState(() {
          products = loadedProducts;
        });
        print(
            "จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ"); // Debugging
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล"); // กรณีไม่มีข้อมูล
      }
    } catch (e) {
      print("Error loading products: $e"); // แสดงข้อผิดพลาดทาง Console
// แสดง Snackbar เพื่อแจ้งเตือนผู้ใช้
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

//ฟังก์ชันสำหรับการเปิดแอปพลิเคชั่นมาแล้วรันเลย
  @override
  void initState() {
    super.initState();
    fetchProducts(); // เรียกใช้เมื่อ Widget ถูกสร้าง
  }

//ฟังก์ชันที่ใช้ลบ
  void deleteProduct(String key, BuildContext context) {
//คําสั่งลบโดยอ้างถึงตัวแปร dbRef ที่เชือมต่อตาราง product ไว้
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
      fetchProducts();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  //ฟังก์ชันถามยืนยันก่อนลบ
  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิ ด Dialog โดยการแตะนอกพื้นที่
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?'),
          actions: [
// ปุ่ มยกเลิก
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('ไม่ลบ',
                  style:
                      TextStyle(color: const Color.fromARGB(255, 85, 13, 8))),
            ),
// ปุ่ มยืนยันการลบ
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
                deleteProduct(key, context); // เรียกฟังก์ชันลบข้อมูล
//ข้อความแจ้งว่าลบเรียบร้อย
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('ลบ',
                  style:
                      TextStyle(color: const Color.fromARGB(255, 85, 13, 8))),
            ),
          ],
        );
      },
    );
  }

//ฟังก์ชันแสดง AlertDialog หน้าจอเพื่อแก้ไขข้อมูล
  void showEditProductDialog(Map<String, dynamic> product) {
    //ตัวอย่างประกาศตัวแปรเพื่อเก็บค่าข้อมูลเดิมที่เก็บไว้ในฐานข้อมูล ดึงมาเก็บไว้ตัวแปรที่กําหนด
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    final TextEditingController quantityController =
        TextEditingController(text: product['quantity'].toString());
    // กำหนดค่าเริ่มต้นสำหรับประเภทสินค้า
    String? selectedCategory = product['category'];
    DateTime? productionDate =
        DateTime.tryParse(product['productionDate'] ?? "");
    TextEditingController dateController = TextEditingController(
      text: productionDate == null
          ? ''
          : '${productionDate.day}/${productionDate.month}/${productionDate.year}',
    );
    // รายการประเภทสินค้า
    final categories = ['Electronics', 'Clothing', 'Food', 'Books'];

    //สร้าง dialog เพื่อแสดงข้อมูลเก่าและให้กรอกข้อมูลใหม่เพื่อแก้ไข
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController, //ดึงข้อมูลชื่อเก่ามาแสดงผลจาก
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory, // แสดงประเภทสินค้าที่เลือกไว้
                  decoration: InputDecoration(
                    labelText: 'ประเภทสินค้า', // ป้าย label
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  items:
                      categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextField(
                  controller:
                      descriptionController, //ดึงข้อมูลรายละเอียดเก่ามาแสดงผล
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                TextField(
                  controller: priceController, //ดึงข้อมูลราคาเก่ามาแสดงผล
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                TextField(
                  controller: quantityController, //ดึงข้อมูลราคาเก่ามาแสดงผล
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวน'),
                ),
                TextField(
                  controller: dateController, // แสดงวันที่ผลิต
                  decoration: InputDecoration(
                    labelText: 'วันที่ผลิต',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        // เปิด DatePicker เมื่อผู้ใช้คลิกที่ไอคอน
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: productionDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null &&
                            pickedDate != productionDate) {
                          setState(() {
                            productionDate = pickedDate;
                            dateController.text =
                                '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                          });
                        }
                      },
                    ),
                  ),
                  readOnly: true, // ทำให้ไม่สามารถแก้ไขข้อมูลตรงนี้ได้โดยตรง
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
// เตรียมข้อมูลที่แก้ไขแล้ว
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price': int.parse(priceController.text),
                  'quantity': int.parse(priceController.text),
                  'category': selectedCategory,
                  'productionDate': productionDate?.toIso8601String(),
                };

                dbRef
                    .child(
                      product['key'],
                    )
                    .update(updatedData)
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  fetchProducts(); // เรียกใช้ฟังก์ชันเพื่อโหลดข้อมูลใหม่เพื่อแสดงผลหลังการแก้ไขเช่น fetchProducts
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                });
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

//ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แสดงข้อมูลสินค้า',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255)), // กำหนดสีของข้อความ
        ),
        backgroundColor: Color.fromARGB(255, 124, 10, 54), // ใส่สีที่ต้องการ
      ),
      body: products.isEmpty
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
                itemCount: products.length, // จํานวนรายการ
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
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
                          child: Column(
                            children: [
                              Text(
                                product['name'],
                                style: TextStyle(
                                  fontSize: 16, // ขนาดฟอนต์
                                  fontWeight:
                                      FontWeight.bold, // ความหนาของฟอนต์
                                  color: const Color.fromARGB(
                                      255, 0, 0, 0), // สีของฟอนต์
                                ),
                              ),
                              SizedBox(height: 8), // เพิ่มระยะห่าง
                              
                                Text(
                                  'รายละเอียดสินค้า: ${product['description']}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: const Color.fromARGB(255, 3, 3, 3),
                                    height: 1.25,
                                  ),
                                ),
                              
                              SizedBox(height: 8), // เพิ่มระยะห่าง
                              Spacer(), // เพิ่มระยะห่างและผลักราคาลงด้านล่างสุด
                              Text(
                                'ราคา : ${product['price']} บาท',
                                style: TextStyle(
                                  fontSize: 14, // ขนาดฟอนต์
                                  color: const Color.fromARGB(
                                      255, 0, 0, 0), // สีของฟอนต์
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // กดปุ่มลบแล้วจะให้เกิดอะไรขึ้น
                                      showDeleteConfirmationDialog(
                                          product['key'], context);
                                    },
                                    icon: Icon(Icons.delete),
                                    color: const Color.fromARGB(
                                        255, 124, 10, 54), // สีของไอคอน
                                    iconSize: 18,
                                    tooltip: 'ลบสินค้า',
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // กดปุ่มแก้ไขแล้วจะให้เกิดอะไรขึ้น
                                      showEditProductDialog(
                                          product); // เปด Dialog แกไขสินคา
                                    },
                                    icon: Icon(Icons.edit),
                                    color: const Color.fromARGB(
                                        255, 124, 10, 54), // สีของไอคอน
                                    iconSize: 18,
                                    tooltip: 'แก้ไขสินค้า',
                                  ),
                                ],
                              ),
                            ],
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
