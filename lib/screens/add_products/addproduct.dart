import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddProductPage(),
    );
  }
}

class AddProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: ClipPath(
          clipper: CustomAppBarClipper(),
          child: Container(
            color: Color(0xFF1E0A33),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  "ADD PRODUCT",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 150,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, style: BorderStyle.dashed),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 30, color: Colors.black54),
                    SizedBox(height: 5),
                    Text("Main Photo", style: GoogleFonts.poppins(color: Colors.black54)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: "Garment Title",
                hintStyle: GoogleFonts.poppins(color: Colors.black45),
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text("Category", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                categoryButton("\ud83c\udf89 Party Wear", false),
                categoryButton("\ud83d\udc55 Casual Wear", true),
                categoryButton("\ud83c\udf81 Office/Formal Wear", false),
                categoryButton("\ud83d\udc53 New Trends", false),
                categoryButton("\ud83d\udc57 Traditional Wear", false),
                categoryButton("\ud83c\udf75 Seasonal Wear", false),
                categoryButton("\ud83c\udf0a Sleep Wear", false),
                categoryButton("\u26f3 Sports Wear", false),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF1E0A33),
        unselectedItemColor: Colors.black54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dash"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 50, color: Color(0xFF1E0A33)), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Income"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Shop"),
        ],
      ),
    );
  }

  Widget categoryButton(String text, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF1E0A33) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black),
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}