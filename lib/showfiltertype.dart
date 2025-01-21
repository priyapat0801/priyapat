import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'productdetail.dart';

class showfiltertype extends StatefulWidget {
  final String category; // รับค่าประเภทสินค้า

  const showfiltertype({required this.category, Key? key}) : super(key: key);

  @override
  _showfiltertypeState createState() => _showfiltertypeState();
}

class _showfiltertypeState extends State<showfiltertype> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> filteredProducts = [];

  Future<void> fetchFilteredProducts() async {
    try {
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> productsList = [];
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          if (product.containsKey('category') &&
              product['category'] == widget.category) {
            productsList.add(product);
          }
           // **เรียงลําดับข้อมูลตามราคา จากมากไปน้อย**
       productsList.sort((a, b) => a['price'].compareTo(b['price']));
        });
        
        setState(() {
          filteredProducts = productsList;
        });
      } else {
        print("ไม่พบข้อมูลสินค้าในฐานข้อมูล");
      }
    } catch (e) {
      print("Error loading filtered products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFilteredProducts();
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MMMM/yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สินค้าในหมวด ${widget.category}', style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255)),),
        backgroundColor: Color.fromARGB(255, 124, 10, 54),
      ),
      body: filteredProducts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        product['name'] ?? 'ไม่มีชื่อสินค้า',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(children: [
                        Text('รายละเอียดสินค้า : ${product['description']}'),
                        Text(
                            'วันที่ผลิตสินค้า : ${formatDate(product['productionDate'])}'),
                        Text('จำนวน : ${(product['quantity'])}')
                      ]),
                      trailing: Text('ราคา : ${product['price']} บาท',style: TextStyle(
                            fontSize: 14),),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetail(product: product),
                          ),
                        );
                        // เพิ่มการกระทำเมื่อกดที่สินค้า
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
