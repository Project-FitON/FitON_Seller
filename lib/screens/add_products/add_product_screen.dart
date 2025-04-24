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
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management App',
      theme: ThemeData(
        primaryColor: const Color(0xFF1A0A33),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const ProductPages(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProductPages extends StatefulWidget {
  const ProductPages({Key? key}) : super(key: key);

  @override
  State<ProductPages> createState() => _ProductPagesState();
}

class _ProductPagesState extends State<ProductPages> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3; // Total number of pages

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top curved header
          ClipPath(
            clipper: CurvedBottomClipper(),
            child: Container(
              height: 200,
              color: const Color(0xFF1A0A33),
              width: double.infinity,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Text(
                    'EDIT PRODUCT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Main content with PageView for swiping
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildProductInfoPage(),
                _buildProductCategoryPage(),
                _buildProductPricingPage(),
              ],
            ),
          ),
          
          // Bottom Navigation
          _buildBottomNavigation(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1A0A33),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildProductInfoPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Photo Section
          Center(
            child: Container(
              height: 250,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                  style: BorderStyle.dashed,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.camera_alt, size: 40),
                  SizedBox(height: 10),
                  Text(
                    'Main Photo',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Title Field
          const Text(
            'Garment Title',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 30),
          // Additional Fields can be added here
        ],
      ),
    );
  }

  Widget _buildProductCategoryPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Category Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _buildCategoryButton('🎉 Party Wear', false),
                _buildCategoryButton('👔 Casual Wear', true),
                _buildCategoryButton('👔 Office/Formal Wear', false),
                _buildCategoryButton('👓 New Trends', false),
                _buildCategoryButton('👘 Traditional Wear', false),
                _buildCategoryButton('👚 Seasonal Wear', false),
                _buildCategoryButton('👙 Sleep Wear', false),
                _buildCategoryButton('👟 Sports Wear', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String title, bool isSelected) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF1A0A33) : Colors.white,
        side: BorderSide(
          color: isSelected ? const Color(0xFF1A0A33) : Colors.grey,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildProductPricingPage() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing & Inventory',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          // Pricing fields would go here
          TextField(
            decoration: InputDecoration(
              labelText: 'Price',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Quantity',
              prefixIcon: Icon(Icons.inventory),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {},
              tooltip: 'Dash',
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
              tooltip: 'Orders',
            ),
            const SizedBox(width: 40), // Space for FAB
            IconButton(
              icon: const Icon(Icons.monetization_on),
              onPressed: () {},
              tooltip: 'Income',
            ),
            IconButton(
              icon: const Icon(Icons.store),
              onPressed: () {},
              tooltip: 'Shop',
            ),
          ],
        ),
      ),
    );
  }
}

// Custom clipper for curved header
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2, 
      size.height, 
      size.width, 
      size.height - 40
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
import 'package:flutter/material.dart';

class ProductSizePage extends StatefulWidget {
  const ProductSizePage({Key? key}) : super(key: key);

  @override
  State<ProductSizePage> createState() => _ProductSizePageState();
}

class _ProductSizePageState extends State<ProductSizePage> {
  // Set to hold selected sizes
  final Set<String> _selectedSizes = {'S'};
  
  // Available sizes
  final List<String> _availableSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sizes Available Text with measuring icon
          Row(
            children: [
              const Icon(Icons.straighten, color: Colors.black54),
              const SizedBox(width: 10),
              Text(
                'Sizes Available',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Size buttons in a wrap layout
          Wrap(
            spacing: 12,
            runSpacing: 16,
            children: _buildSizeButtons(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSizeButtons() {
    List<Widget> buttons = [];
    
    // First row: XS, S, M, L
    buttons.add(_buildSizeButton('XS'));
    buttons.add(_buildSizeButton('S'));
    buttons.add(_buildSizeButton('M'));
    buttons.add(_buildSizeButton('L'));
    
    // Second row: XL, XXL, XXXL
    buttons.add(_buildSizeButton('XL'));
    buttons.add(_buildSizeButton('XXL'));
    buttons.add(_buildSizeButton('XXXL'));
    
    return buttons;
  }

  Widget _buildSizeButton(String size) {
    final bool isSelected = _selectedSizes.contains(size);
    
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedSizes.remove(size);
          } else {
            _selectedSizes.add(size);
          }
        });
      },
      child: Container(
        width: 70,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A0A33) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF1A0A33) : Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// To integrate this with your PageView, here's how you would modify the main ProductPages class:

class ProductPages extends StatefulWidget {
  const ProductPages({Key? key}) : super(key: key);

  @override
  State<ProductPages> createState() => _ProductPagesState();
}

class _ProductPagesState extends State<ProductPages> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4; // Increased for the new size page

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top curved header
          ClipPath(
            clipper: CurvedBottomClipper(),
            child: Container(
              height: 200,
              color: const Color(0xFF1A0A33),
              width: double.infinity,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Text(
                    'EDIT PRODUCT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Main content with PageView for swiping
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildProductInfoPage(),
                const ProductSizePage(), // Our new page
                _buildProductCategoryPage(),
                _buildProductPricingPage(),
              ],
            ),
          ),
          
          // Page indicators - optional
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_totalPages, (index) => 
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index 
                      ? const Color(0xFF1A0A33) 
                      : Colors.grey.shade300,
                ),
              )
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Bottom Navigation
          _buildBottomNavigation(),
        ],
      ),
      // [Rest of the scaffold code remains the same]
    );
  }

  // [Other methods from the previous implementation remain the same]
}

// Custom clipper for curved header
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2, 
      size.height, 
      size.width, 
      size.height - 40
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}import 'package:flutter/material.dart';

class StocksAvailabilityPage extends StatefulWidget {
  final List<String> selectedSizes;

  const StocksAvailabilityPage({
    Key? key, 
    required this.selectedSizes,
  }) : super(key: key);

  @override
  State<StocksAvailabilityPage> createState() => _StocksAvailabilityPageState();
}

class _StocksAvailabilityPageState extends State<StocksAvailabilityPage> {
  // Stock data map - size -> color -> quantity
  final Map<String, Map<String, int>> stockData = {
    'XS': {'Red': 2, 'Green': 2, 'Blue': 2},
    'S': {'Red': 2, 'Green': 2, 'Blue': 2},
    'M': {'Red': 2, 'Green': 2, 'Blue': 2},
    'L': {'Red': 2, 'Green': 2, 'Blue': 2},
    'XL': {'Red': 2, 'Green': 2, 'Blue': 2},
    'XXL': {'Red': 2, 'Green': 2, 'Blue': 2},
    'XXXL': {'Red': 2, 'Green': 2, 'Blue': 2},
  };

  // Available colors with their actual color values
  final Map<String, Color> colorMap = {
    'Red': Color(0xFF8B0000),
    'Green': Color(0xFF006400),
    'Blue': Color(0xFF00008B),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stocks Availability Title with warehouse icon
          Row(
            children: [
              Icon(Icons.warehouse, color: Colors.black54),
              SizedBox(width: 10),
              Text(
                'Stocks Availability',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          // Stock chart
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFE6EEFA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Header row with color circles
                _buildHeaderRow(),
                
                // Divider
                Divider(height: 1, thickness: 1, color: Colors.grey[300]),
                
                // Size rows
                ...getAllSizes().map((size) => _buildSizeRow(size)).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Get all available sizes (either from selected sizes or all sizes if none selected)
  List<String> getAllSizes() {
    if (widget.selectedSizes.isEmpty) {
      return ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
    }
    return widget.selectedSizes;
  }

  // Build the header row with color circles
  Widget _buildHeaderRow() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xFFE6EEFA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          // Selected Sizes Cell
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              child: Text(
                'Selected\nSizes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          
          // Color circles cells
          ...colorMap.entries.map((entry) => 
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: entry.value,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).toList(),
        ],
      ),
    );
  }

  // Build a row for each size
  Widget _buildSizeRow(String size) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Size Cell
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              child: Text(
                size,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          
          // Quantity cells for each color
          ...colorMap.keys.map((color) => 
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _showQuantityEditor(size, color);
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    stockData[size]?[color]?.toString().padLeft(2, '0') ?? '00',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ),
            ),
          ).toList(),
        ],
      ),
    );
  }

  // Show quantity editor dialog
  void _showQuantityEditor(String size, String color) {
    int currentQuantity = stockData[size]?[color] ?? 0;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Stock Quantity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$size - $color'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: currentQuantity > 0 ? () {
                    setState(() {
                      currentQuantity--;
                      Navigator.pop(context);
                      
                      // Update the stock data
                      if (stockData.containsKey(size)) {
                        stockData[size]![color] = currentQuantity;
                      } else {
                        stockData[size] = {color: currentQuantity};
                      }
                    });
                  } : null,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    currentQuantity.toString().padLeft(2, '0'),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      currentQuantity++;
                      Navigator.pop(context);
                      
                      // Update the stock data
                      if (stockData.containsKey(size)) {
                        stockData[size]![color] = currentQuantity;
                      } else {
                        stockData[size] = {color: currentQuantity};
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

// To integrate with your PageView, add this class to your pages
class ProductInventoryPage extends StatelessWidget {
  final List<String> selectedSizes;
  
  const ProductInventoryPage({
    Key? key,
    required this.selectedSizes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Product info section (could be reused from your other pages)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Photo Section
                Center(
                  child: Container(
                    height: 250,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                        style: BorderStyle.dashed,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.camera_alt, size: 40),
                        SizedBox(height: 10),
                        Text(
                          'Main Photo',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Title Field
                const Text(
                  'Garment Title',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const TextField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          
          // Stocks Availability Chart
          StocksAvailabilityPage(selectedSizes: selectedSizes),
        ],
      ),
    );
  }
}

// In your main PageView, you would add this page like:
// PageView(
//   children: [
//     _buildProductInfoPage(),
//     const ProductSizePage(),  // from previous example
//     ProductInventoryPage(selectedSizes: _selectedSizes),
//     _buildProductCategoryPage(),
//   ],
// )
import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool isInches = true;
  bool isSingleMode = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Purple header
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1A0033),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "ADD PRODUCT",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    // Main photo container
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.dashed,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.camera_alt, size: 40),
                              SizedBox(height: 10),
                              Text("Main Photo"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Size Chart section
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Size Chart header
                          Row(
                            children: const [
                              Icon(Icons.grid_on),
                              SizedBox(width: 10),
                              Text(
                                "Size Chart",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Units selection
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Units In",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildUnitSelectionButton("cm", !isInches),
                                  const SizedBox(width: 10),
                                  _buildUnitSelectionButton("Inches", isInches),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Size Input Method
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Size Input Method",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildInputMethodButton("Ranges", !isSingleMode),
                                  const SizedBox(width: 10),
                                  _buildInputMethodButton("Single", isSingleMode),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Main Measurements Table
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Main Measurements",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildMainMeasurementsTable(),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // Additional Measurements Table
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Additional Measurements (Optional)",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildAdditionalMeasurementsTable(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Left sidebar icons
              Positioned(
                left: 0,
                top: 300,
                child: Container(
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A0033),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    children: [
                      _sidebarIcon(Icons.chat_bubble_outline),
                      _sidebarIcon(Icons.label_outline),
                      _sidebarIcon(Icons.local_shipping_outlined),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Sidebar icon widget
  Widget _sidebarIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }
  
  // Unit selection button
  Widget _buildUnitSelectionButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (text == "cm") {
            isInches = false;
          } else {
            isInches = true;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A0033) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1A0033)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1A0033),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  // Input method button
  Widget _buildInputMethodButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (text == "Ranges") {
            isSingleMode = false;
          } else {
            isSingleMode = true;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A0033) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1A0033)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1A0033),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  // Main measurements table
  Widget _buildMainMeasurementsTable() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE6EEFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Table(
        border: TableBorder.all(
          color: Colors.white,
          width: 1,
        ),
        children: [
          _buildTableHeader(['Selected Sizes', 'Bust', 'Waist', 'Hips', 'Length']),
          ...List.generate(
            7,
            (index) => _buildTableRow([
              _getSizeLabel(index),
              '02',
              '02',
              '02',
              '02',
            ]),
          ),
        ],
      ),
    );
  }
  
  // Additional measurements table
  Widget _buildAdditionalMeasurementsTable() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE6EEFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Table(
        border: TableBorder.all(
          color: Colors.white,
          width: 1,
        ),
        children: [
          _buildTableHeader(['Selected Sizes', 'Sleeve Length', 'Inseam', '+']),
          ...List.generate(
            7,
            (index) => _buildTableRow([
              _getSizeLabel(index),
              '02',
              '02',
              '',
            ]),
          ),
        ],
      ),
    );
  }
  
  // Table header row
  TableRow _buildTableHeader(List<String> cells) {
    return TableRow(
      children: cells.map((cell) {
        return TableCell(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              cell,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }
  
  // Table data row
  TableRow _buildTableRow(List<String> cells) {
    return TableRow(
      children: cells.map((cell) {
        return TableCell(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: cell.isEmpty
                  ? null
                  : GestureDetector(
                      onTap: () {
                        _showSizeInputDialog();
                      },
                      child: Text(
                        cell,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  // Get size label based on index
  String _getSizeLabel(int index) {
    switch (index) {
      case 0: return 'XS';
      case 1: return 'S';
      case 2: return 'M';
      case 3: return 'L';
      case 4: return 'XL';
      case 5: return 'XXL';
      case 6: return 'XXXL';
      default: return '';
    }
  }
  
  // Show size input dialog when cell is tapped
  void _showSizeInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Measurement"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter value in ${isInches ? 'inches' : 'cm'}",
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A0033),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Here we would normally save the value to the appropriate cell
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
  
  // Show size chart dialog
  void showSizeChart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1A0033),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Size Chart",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Main Measurements",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildMainMeasurementsTable(),
                      const SizedBox(height: 20),
                      const Text(
                        "Additional Measurements",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildAdditionalMeasurementsTable(),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A0033),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Close",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage example
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddProductPage(),
    );
  }
}
import 'package:flutter/material.dart';

class MeasurementTypesPopup extends StatefulWidget {
  final List<String> initialSelected;
  final Function(List<String>) onSelectionChanged;

  const MeasurementTypesPopup({
    Key? key,
    this.initialSelected = const ["Waist", "Hips"],
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _MeasurementTypesPopupState createState() => _MeasurementTypesPopupState();
}

class _MeasurementTypesPopupState extends State<MeasurementTypesPopup> {
  late List<String> selectedMeasurements;

  @override
  void initState() {
    super.initState();
    selectedMeasurements = List.from(widget.initialSelected);
  }

  void toggleSelection(String measurement) {
    setState(() {
      if (selectedMeasurements.contains(measurement)) {
        selectedMeasurements.remove(measurement);
      } else {
        selectedMeasurements.add(measurement);
      }
      widget.onSelectionChanged(selectedMeasurements);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Measurement Types (${selectedMeasurements.length} Selected)",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Body figure with measurement indicators
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              height: 350,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Body outline
                  CustomPaint(
                    size: const Size(200, 350),
                    painter: BodyOutlinePainter(),
                  ),
                  
                  // Chest measurement (light blue)
                  MeasurementLine(
                    top: 110,
                    left: 85,
                    width: 100,
                    color: Colors.cyan,
                    label: "CHEST",
                    labelRight: true,
                  ),
                  
                  // Sleeve measurement (orange)
                  MeasurementLine(
                    top: 125,
                    left: 185,
                    width: 40,
                    color: Colors.orange,
                    label: "SLEEVE",
                    labelRight: true,
                    isVertical: true,
                  ),
                  
                  // Waist measurement (green)
                  MeasurementLine(
                    top: 160,
                    left: 93,
                    width: 85,
                    color: Colors.green,
                    label: "WAIST",
                    labelRight: true,
                  ),
                  
                  // Hips measurement (purple)
                  MeasurementLine(
                    top: 200,
                    left: 90,
                    width: 90,
                    color: Colors.deepPurple,
                    label: "HIPS",
                    labelRight: true,
                  ),
                  
                  // Inseam measurement (red)
                  MeasurementLine(
                    top: 220,
                    left: 160,
                    width: 100,
                    color: Colors.red,
                    label: "INSEAM",
                    labelRight: true,
                    isVertical: true,
                  ),
                ],
              ),
            ),
          ),
          
          // Measurement type selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSelectionChip("Shoulders"),
                _buildSelectionChip("Waist"),
                _buildSelectionChip("Hips"),
                _buildSelectionChip("Inseam"),
                _buildSelectionChip("Sleeve"),
                _buildSelectionChip("Neck"),
                _buildSelectionChip("+"),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  
  Widget _buildSelectionChip(String label) {
    final isSelected = selectedMeasurements.contains(label);
    
    return GestureDetector(
      onTap: () => toggleSelection(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A0033) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1A0033)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1A0033),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Custom widget for the measurement lines and labels
class MeasurementLine extends StatelessWidget {
  final double top;
  final double left;
  final double width;
  final Color color;
  final String label;
  final bool labelRight;
  final bool isVertical;

  const MeasurementLine({
    Key? key,
    required this.top,
    required this.left,
    required this.width,
    required this.color,
    required this.label,
    this.labelRight = false,
    this.isVertical = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!labelRight) 
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          Container(
            width: isVertical ? 2 : width,
            height: isVertical ? width : 2,
            color: color,
          ),
          if (labelRight) 
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Custom painter for the body outline
class BodyOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    final path = Path();
    
    // Head
    path.addOval(Rect.fromCenter(
      center: Offset(size.width / 2, 50),
      width: 30,
      height: 35,
    ));
    
    // Neck
    path.moveTo(size.width / 2 - 8, 68);
    path.lineTo(size.width / 2 - 15, 90);
    
    path.moveTo(size.width / 2 + 8, 68);
    path.lineTo(size.width / 2 + 15, 90);
    
    // Shoulders and arms
    path.moveTo(size.width / 2 - 15, 90);
    path.lineTo(size.width / 2 - 40, 100);
    path.lineTo(size.width / 2 - 45, 170);
    
    path.moveTo(size.width / 2 + 15, 90);
    path.lineTo(size.width / 2 + 40, 100);
    path.lineTo(size.width / 2 + 45, 170);
    
    // Torso
    path.moveTo(size.width / 2 - 40, 100);
    path.lineTo(size.width / 2 - 35, 160);
    path.lineTo(size.width / 2 - 40, 200);
    
    path.moveTo(size.width / 2 + 40, 100);
    path.lineTo(size.width / 2 + 35, 160);
    path.lineTo(size.width / 2 + 40, 200);
    
    // Legs
    path.moveTo(size.width / 2 - 40, 200);
    path.lineTo(size.width / 2 - 30, 320);
    
    path.moveTo(size.width / 2 + 40, 200);
    path.lineTo(size.width / 2 + 30, 320);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Usage example
void showMeasurementTypesPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => MeasurementTypesPopup(
      initialSelected: ["Waist", "Hips"],
      onSelectionChanged: (selectedMeasurements) {
        print("Selected: $selectedMeasurements");
        // Handle selected measurements
      },
    ),
  );
}
import 'package:flutter/material.dart';

class FemaleMeasurementTypesPopup extends StatefulWidget {
  final List<String> initialSelected;
  final Function(List<String>) onSelectionChanged;

  const FemaleMeasurementTypesPopup({
    Key? key,
    this.initialSelected = const ["Waist", "Bust"],
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _FemaleMeasurementTypesPopupState createState() => _FemaleMeasurementTypesPopupState();
}

class _FemaleMeasurementTypesPopupState extends State<FemaleMeasurementTypesPopup> {
  late List<String> selectedMeasurements;

  @override
  void initState() {
    super.initState();
    selectedMeasurements = List.from(widget.initialSelected);
  }

  void toggleSelection(String measurement) {
    setState(() {
      if (selectedMeasurements.contains(measurement)) {
        selectedMeasurements.remove(measurement);
      } else {
        selectedMeasurements.add(measurement);
      }
      widget.onSelectionChanged(selectedMeasurements);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Measurement Types (${selectedMeasurements.length} Selected)",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Body figure with measurement indicators
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              height: 350,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Female body outline
                  CustomPaint(
                    size: const Size(200, 350),
                    painter: FemaleBodyOutlinePainter(),
                  ),
                  
                  // Sleeve measurement (orange)
                  MeasurementLine(
                    top: 125,
                    left: 185,
                    width: 40,
                    color: Colors.orange,
                    label: "SLEEVE",
                    labelRight: true,
                    isVertical: false,
                  ),
                  
                  // Bust measurement (pink/red)
                  MeasurementLine(
                    top: 140,
                    left: 85,
                    width: 100,
                    color: Colors.pink,
                    label: "BUST",
                    labelRight: true,
                  ),
                  
                  // Waist measurement (green)
                  MeasurementLine(
                    top: 180,
                    left: 93,
                    width: 85,
                    color: Colors.green,
                    label: "WAIST",
                    labelRight: true,
                  ),
                  
                  // Hips measurement (purple)
                  MeasurementLine(
                    top: 220,
                    left: 90,
                    width: 90,
                    color: Colors.deepPurple,
                    label: "HIPS",
                    labelRight: true,
                  ),
                  
                  // Inseam measurement (violet)
                  MeasurementLine(
                    top: 240,
                    left: 160,
                    width: 100,
                    color: Colors.purple,
                    label: "INSEAM",
                    labelRight: true,
                    isVertical: true,
                    angle: -15,
                  ),
                ],
              ),
            ),
          ),
          
          // Measurement type selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSelectionChip("Bust"),
                _buildSelectionChip("Waist"),
                _buildSelectionChip("Hips"),
                _buildSelectionChip("Inseam"),
                _buildSelectionChip("Sleeve"),
                _buildSelectionChip("Neck"),
                _buildSelectionChip("+"),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  
  Widget _buildSelectionChip(String label) {
    final isSelected = selectedMeasurements.contains(label);
    
    return GestureDetector(
      onTap: () => toggleSelection(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A0033) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1A0033)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1A0033),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Custom widget for the measurement lines and labels
class MeasurementLine extends StatelessWidget {
  final double top;
  final double left;
  final double width;
  final Color color;
  final String label;
  final bool labelRight;
  final bool isVertical;
  final double angle;

  const MeasurementLine({
    Key? key,
    required this.top,
    required this.left,
    required this.width,
    required this.color,
    required this.label,
    this.labelRight = false,
    this.isVertical = false,
    this.angle = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Transform.rotate(
        angle: angle * 3.14159 / 180, // Convert degrees to radians
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!labelRight) 
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            Container(
              width: isVertical ? 2 : width,
              height: isVertical ? width : 2,
              color: color,
            ),
            if (labelRight) 
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for the female body outline
class FemaleBodyOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    final path = Path();
    
    // Head
    path.addOval(Rect.fromCenter(
      center: Offset(size.width / 2, 50),
      width: 30,
      height: 35,
    ));
    
    // Neck
    path.moveTo(size.width / 2 - 8, 68);
    path.lineTo(size.width / 2 - 10, 85);
    
    path.moveTo(size.width / 2 + 8, 68);
    path.lineTo(size.width / 2 + 10, 85);
    
    // Shoulders and arms
    path.moveTo(size.width / 2 - 10, 85);
    path.lineTo(size.width / 2 - 35, 95);
    path.lineTo(size.width / 2 - 40, 140);
    path.lineTo(size.width / 2 - 30, 190);
    
    path.moveTo(size.width / 2 + 10, 85);
    path.lineTo(size.width / 2 + 35, 95);
    path.lineTo(size.width / 2 + 40, 140);
    path.lineTo(size.width / 2 + 30, 190);
    
    // Bust
    path.moveTo(size.width / 2 - 25, 120);
    path.quadraticBezierTo(
      size.width / 2, 135,
      size.width / 2 + 25, 120,
    );
    
    // Waist
    path.moveTo(size.width / 2 - 30, 190);
    path.lineTo(size.width / 2 - 20, 180);
    path.quadraticBezierTo(
      size.width / 2, 175,
      size.width / 2 + 20, 180,
    );
    path.lineTo(size.width / 2 + 30, 190);
    
    // Hips
    path.moveTo(size.width / 2 - 30, 190);
    path.quadraticBezierTo(
      size.width / 2 - 35, 220,
      size.width / 2 - 25, 240,
    );
    
    path.moveTo(size.width / 2 + 30, 190);
    path.quadraticBezierTo(
      size.width / 2 + 35, 220,
      size.width / 2 + 25, 240,
    );
    
    // Legs
    path.moveTo(size.width / 2 - 25, 240);
    path.lineTo(size.width / 2 - 20, 320);
    
    path.moveTo(size.width / 2 + 25, 240);
    path.lineTo(size.width / 2 + 20, 320);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Usage example
void showFemaleMeasurementTypesPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => FemaleMeasurementTypesPopup(
      initialSelected: ["Bust", "Waist"],
      onSelectionChanged: (selectedMeasurements) {
        print("Selected: $selectedMeasurements");
        // Handle selected measurements
      },
    ),
  );
}

// Example of how to use this in a widget
class MeasurementSelectionPage extends StatelessWidget {
  const MeasurementSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Size Chart"),
        backgroundColor: const Color(0xFF1A0033),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A0033),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: () => showFemaleMeasurementTypesPopup(context),
          child: const Text("Select Measurement Types"),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessagingMethodsSection extends StatelessWidget {
  const MessagingMethodsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 16.0),
          child: Row(
            children: [
              Icon(Icons.chat_bubble_outline, size: 24.0, color: Colors.black),
              const SizedBox(width: 8.0),
              Text(
                'Messaging Methods',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMessagingOption(
              context: context,
              title: 'WhatsApp',
              icon: FontAwesomeIcons.whatsapp,
              color: Color(0xFF25D366),
              backgroundColor: Color(0xFFE6EEFF),
              onTap: () {
                // Handle WhatsApp tap
                print('WhatsApp tapped');
              },
            ),
            _buildMessagingOption(
              context: context,
              title: 'Telegram',
              icon: FontAwesomeIcons.telegram,
              color: Color(0xFF0088CC),
              backgroundColor: Color(0xFFE6EEFF),
              onTap: () {
                // Handle Telegram tap
                print('Telegram tapped');
              },
            ),
            _buildMessagingOption(
              context: context,
              title: 'Instagram',
              icon: FontAwesomeIcons.instagram,
              color: Color(0xFFE1306C),
              backgroundColor: Color(0xFFE6EEFF),
              onTap: () {
                // Handle Instagram tap
                print('Instagram tapped');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessagingOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PricingSection extends StatefulWidget {
  const PricingSection({super.key});

  @override
  State<PricingSection> createState() => _PricingSectionState();
}

class _PricingSectionState extends State<PricingSection> {
  final TextEditingController _originalPriceController = TextEditingController(text: '0.00');
  final TextEditingController _discountedPriceController = TextEditingController(text: '0.00');

  @override
  void dispose() {
    _originalPriceController.dispose();
    _discountedPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 16.0),
          child: Row(
            children: [
              Icon(Icons.local_offer_outlined, size: 24.0, color: Colors.black),
              const SizedBox(width: 8.0),
              Text(
                'Pricing',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Original Price',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _originalPriceController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              '\$',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          // Handle price change
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Discounted Price',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _discountedPriceController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              '\$',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          // Handle discounted price change
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: EditProductScreen(),
  ));
}

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool showDeliverySection = false;
  bool isCashOnDelivery = false;
  bool isCardPayment = false;
  TextEditingController deliveryFeeController = TextEditingController(text: "0.00");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showDeliverySection = !showDeliverySection;
                });
              },
              child: Text("Toggle Delivery Section"),
            ),
            SizedBox(height: 20),
            if (showDeliverySection) buildDeliverySection(),
          ],
        ),
      ),
    );
  }

  Widget buildDeliverySection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text("Delivery", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 12),
          buildDeliveryFeeInput(),
          buildToggleOption("Cash on Delivery", isCashOnDelivery, (value) {
            setState(() {
              isCashOnDelivery = value;
            });
          }),
          buildToggleOption("Card Payment", isCardPayment, (value) {
            setState(() {
              isCardPayment = value;
            });
          }),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // Handle product update
            },
            child: Text("Update Product", style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget buildDeliveryFeeInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.local_shipping, color: Colors.deepPurple),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: deliveryFeeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Delivery Fee",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildToggleOption(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.payment, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 16)),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }
}

