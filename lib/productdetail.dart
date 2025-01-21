import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final Map<String, dynamic> product; // รับข้อมูลสินค้า

  const ProductDetail({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] ?? 'รายละเอียดสินค้า'),
        backgroundColor: Color.fromARGB(255, 124, 10, 54),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['name'] ?? 'ไม่มีชื่อสินค้า',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),
            Text(
              'รายละเอียด : ${product['description'] ?? 'ไม่มีรายละเอียด'}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'ราคา : ${product['price']} บาท',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'จำนวน : ${(product['quantity'])}',
              style: TextStyle(fontSize: 16),
            ),
            // สามารถเพิ่มส่วนต่าง ๆ ของรายละเอียดสินค้าได้ เช่น รูปภาพ, ปริมาณสินค้า ฯลฯ
          ],
        ),
      ),
    );
  }
}
