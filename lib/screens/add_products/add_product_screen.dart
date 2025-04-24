import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Product',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: AddProductPage(),
    );
  }
}

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  int _selectedIndex = 0;
  final List<String> _sideNavOptions = [
    'Colors & Photos',
    'Style',
    'Category',
    'Sizes Available',
    'Stocks Availability',
    'price',
  ];

  void _onSideNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive values based on screen size
    double sideNavWidth = screenWidth < 600 ? screenWidth * 0.2 : 200;
    double iconSize = screenWidth < 600 ? screenWidth * 0.08 : 40;
    double containerSize = screenWidth < 600 ? screenWidth * 0.6 : 300;
    double fontSize = screenWidth < 600 ? screenWidth * 0.04 : 16;

    return Scaffold(
      extendBodyBehindAppBar: true, // Allow body to extend behind AppBar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 31, 7, 73),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(80.0), // Increased from 25.0
              bottomRight: Radius.circular(80.0), // Increased from 25.0
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.4),
            //     spreadRadius: 3,
            //     blurRadius: 8,
            //     offset: Offset(0, 4),
            //   ),
            // ],
          ),
          child: AppBar(
            title: Text(
              'ADD PRODUCT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              ),
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          // Side navigation that extends to the top
          Container(
            width: sideNavWidth,
            color: Colors.deepPurple.shade900,
            child: Column(
              children: [
                // Space for AppBar at top
                SizedBox(height: kToolbarHeight),

                // Make only this section scrollable with constrained height
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20), // Initial padding
                        for (int i = 0; i < _sideNavOptions.length; i++)
                          Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: 40,
                                ), // Increased spacing
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () => _onSideNavTap(i),
                                      child: Icon(
                                        Icons.add_circle_outline,
                                        color:
                                            _selectedIndex == i
                                                ? Colors.white
                                                : Colors.grey,
                                        size: iconSize,
                                      ),
                                    ),
                                    SizedBox(height: 12), // Increased spacing
                                    Text(
                                      _sideNavOptions[i],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:
                                            _selectedIndex == i
                                                ? Colors.white
                                                : Colors.grey,
                                        fontSize: fontSize * 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (i < _sideNavOptions.length - 1)
                                Column(
                                  children: [
                                    Divider(
                                      color: Colors.grey.withOpacity(0.3),
                                      height: 1,
                                    ),
                                    SizedBox(height: 10), // Space after divider
                                  ],
                                ),
                            ],
                          ),
                        SizedBox(height: 120), // Extra padding at bottom
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main content area
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: kToolbarHeight),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: containerSize,
                          height: containerSize,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black26,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, size: iconSize),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                'Main Photo',
                                style: TextStyle(fontSize: fontSize),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextField(
                        decoration: InputDecoration(labelText: 'Garment Title'),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      if (_selectedIndex == 0)
                        _buildColorsAndPhotosSection(screenWidth, screenHeight),
                      if (_selectedIndex == 1) _buildStyleSection(screenWidth),
                      if (_selectedIndex == 2)
                        _buildCategorySection(screenWidth),
                      if (_selectedIndex == 3)
                        _buildSizesAvailableSection(screenWidth),
                      if (_selectedIndex == 4)
                        _buildStocksAvailabilitySection(screenWidth),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          // Add navigation logic if needed
        },
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Dash'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Add'),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Income',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
        ],
      ),
    );
  }

  Widget _buildColorsAndPhotosSection(double screenWidth, double screenHeight) {
    double avatarRadius = screenWidth < 600 ? screenWidth * 0.06 : 36;
    double fontSize = screenWidth < 600 ? screenWidth * 0.045 : 18;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Colors & Photos',
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: screenHeight * 0.01),
        Row(
          children: [
            CircleAvatar(radius: avatarRadius, backgroundColor: Colors.red),
            SizedBox(width: screenWidth * 0.02),
            CircleAvatar(
              radius: avatarRadius,
              backgroundImage: AssetImage('assets/images/sample_photo.jpg'),
            ),
            SizedBox(width: screenWidth * 0.02),
            CircleAvatar(radius: avatarRadius, backgroundColor: Colors.green),
            SizedBox(width: screenWidth * 0.02),
            CircleAvatar(
              radius: avatarRadius,
              backgroundImage: AssetImage('assets/images/sample_photo.jpg'),
            ),
            SizedBox(width: screenWidth * 0.02),
            CircleAvatar(radius: avatarRadius, backgroundColor: Colors.blue),
            SizedBox(width: screenWidth * 0.02),
            CircleAvatar(
              radius: avatarRadius,
              backgroundImage: AssetImage('assets/images/sample_photo.jpg'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStyleSection(double screenWidth) {
    double fontSize = screenWidth < 600 ? screenWidth * 0.045 : 18;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Style',
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: screenWidth * 0.02),
        Wrap(
          spacing: screenWidth * 0.02,
          runSpacing: screenWidth * 0.02,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('Men\'s Wear'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
              ),
              child: Text('Women\'s Wear'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('Top Wear'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('Bottom Wear'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
              ),
              child: Text('Full Body Wear'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySection(double screenWidth) {
    double fontSize = screenWidth < 600 ? screenWidth * 0.045 : 18;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: screenWidth * 0.02),
        Wrap(
          spacing: screenWidth * 0.02,
          runSpacing: screenWidth * 0.02,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('Party Wear'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
              ),
              child: Text('Casual Wear'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('Office/Formal Wear'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('New Trends'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('Traditional Wear'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('Seasonal Wear'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('Under Wear'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('Sports Wear'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSizesAvailableSection(double screenWidth) {
    double fontSize = screenWidth < 600 ? screenWidth * 0.045 : 18;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sizes Available',
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: screenWidth * 0.02),
        Wrap(
          spacing: screenWidth * 0.02,
          runSpacing: screenWidth * 0.02,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('XS'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
              ),
              child: Text('S'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('M'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('L'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('XL'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('XXL'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text('XXXL'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStocksAvailabilitySection(double screenWidth) {
    double fontSize = screenWidth < 600 ? screenWidth * 0.045 : 18;
    double cellSize = screenWidth < 600 ? screenWidth * 0.08 : 40;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stocks Availability',
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: screenWidth * 0.02),
        DataTable(
          columnSpacing: screenWidth * 0.02,
          columns: [
            DataColumn(label: Text('Selected Sizes')),
            DataColumn(label: Text('Color 1')),
            DataColumn(label: Text('Color 2')),
            DataColumn(label: Text('Color 3')),
          ],
          rows: [
            DataRow(
              cells: [
                DataCell(Text('XS')),
                DataCell(
                  Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text('S')),
                DataCell(
                  Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    width: cellSize,
                    height: cellSize,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ],
            ),
            // Add more rows as needed...
          ],
        ),
      ],
    );
  }
}
