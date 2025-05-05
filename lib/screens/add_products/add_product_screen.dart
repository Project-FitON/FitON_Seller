import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'dart:io';
import 'package:fiton_seller/screens/nav/side_menu.dart';

class AddProductScreen extends StatefulWidget {
  final String shopId;

  const AddProductScreen({super.key, required this.shopId});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _sizeChartController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String _selectedGender = 'Unisex';
  String _selectedCategory = 'T-shirt';
  String _selectedWear = 'Casual';
  List<String> _imageUrls = [];
  bool _isLoading = false;
  Map<String, Map<String, String>> _sizeMeasurements = {
    'S': {'chest': '', 'length': '', 'shoulder': ''},
    'M': {'chest': '', 'length': '', 'shoulder': ''},
    'L': {'chest': '', 'length': '', 'shoulder': ''},
    'XL': {'chest': '', 'length': '', 'shoulder': ''},
  };

  final List<String> _genderOptions = ['Men', 'Women', 'Unisex'];
  final List<String> _categoryOptions = [
    'T-shirt',
    'Office',
    'Sport',
    'Casual',
    'Formal',
  ];
  final List<String> _wearOptions = [
    'Casual',
    'Formal',
    'Sport',
    'Beach',
    'Party',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _sizeChartController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      setState(() => _isLoading = true);

      // Step 1: Pick image
      print('Attempting to pick image...');
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        print('No image selected');
        setState(() => _isLoading = false);
        return;
      }

      print('Image picked: ${image.path}');
      print('Image name: ${image.name}');

      // Step 2: Read file
      print('Reading image file...');
      final bytes = await image.readAsBytes();
      print('File size: ${bytes.length} bytes');

      // Step 3: Prepare upload
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileExt = image.name.split('.').last.toLowerCase();
      // Using the correct path structure: bucket 'fiton' and folder 'products'
      final String path = 'products/$fileName.$fileExt';

      print('Uploading to path: $path');
      print('File extension: $fileExt');

      // Step 4: Upload to Supabase
      print('Starting upload to Supabase...');
      try {
        final storageResponse = await Supabase.instance.client.storage
            .from('fiton') // Changed to correct bucket name 'fiton'
            .uploadBinary(
              path,
              bytes,
              fileOptions: FileOptions(contentType: 'image/$fileExt'),
            );

        print('Upload successful: $storageResponse');

        // Step 5: Get public URL
        final imageUrl = Supabase.instance.client.storage
            .from('fiton') // Changed to correct bucket name 'fiton'
            .getPublicUrl(path);

        print('Generated public URL: $imageUrl');

        if (mounted) {
          setState(() {
            _imageUrls.add(imageUrl);
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image uploaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (uploadError) {
        print('Upload error: $uploadError');
        throw Exception('Failed to upload: $uploadError');
      }
    } catch (e) {
      print('Error in _pickImages: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one product image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response =
          await Supabase.instance.client
              .from('products')
              .insert({
                'shop_id': widget.shopId,
                'name': _nameController.text,
                'gender': _selectedGender,
                'category': _selectedCategory,
                'images': _imageUrls,
                'price': double.parse(_priceController.text),
                'stock': int.parse(_stockController.text),
                'likes': 0,
                'orders_count': 0,
                'size_chart': _sizeChartController.text,
                'size_measurements': _sizeMeasurements,
                'wish': 0,
                'wear': _selectedWear,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              })
              .select()
              .single();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving product: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B0331),
        title: const Text('Add Product', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Images Section
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            _imageUrls.isEmpty
                                ? Center(
                                  child: TextButton.icon(
                                    onPressed: _pickImages,
                                    icon: const Icon(Icons.add_photo_alternate),
                                    label: const Text('Add Product Image'),
                                  ),
                                )
                                : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _imageUrls.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == _imageUrls.length) {
                                      return Center(
                                        child: IconButton(
                                          onPressed: _pickImages,
                                          icon: const Icon(
                                            Icons.add_photo_alternate,
                                          ),
                                          tooltip: 'Add another image',
                                        ),
                                      );
                                    }
                                    return Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.network(
                                            _imageUrls[index],
                                            width: 150,
                                            height: 180,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Container(
                                                width: 150,
                                                height: 180,
                                                color: Colors.grey[200],
                                                child: const Icon(
                                                  Icons.error_outline,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _imageUrls.removeAt(index);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                      ),
                      const SizedBox(height: 16),

                      // Basic Information
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a product name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Price and Stock
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                labelText: 'Price',
                                border: OutlineInputBorder(),
                                prefixText: '\$',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a price';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _stockController,
                              decoration: const InputDecoration(
                                labelText: 'Stock',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter stock quantity';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Dropdowns
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedGender,
                              decoration: const InputDecoration(
                                labelText: 'Gender',
                                border: OutlineInputBorder(),
                              ),
                              items:
                                  _genderOptions.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedGender = newValue!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                border: OutlineInputBorder(),
                              ),
                              items:
                                  _categoryOptions.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedCategory = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Wear Type
                      DropdownButtonFormField<String>(
                        value: _selectedWear,
                        decoration: const InputDecoration(
                          labelText: 'Wear Type',
                          border: OutlineInputBorder(),
                        ),
                        items:
                            _wearOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedWear = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Size Chart
                      TextFormField(
                        controller: _sizeChartController,
                        decoration: const InputDecoration(
                          labelText: 'Size Chart Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Size Measurements
                      const Text(
                        'Size Measurements',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      for (var size in _sizeMeasurements.keys) ...[
                        Text(
                          'Size $size',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Chest',
                                  border: OutlineInputBorder(),
                                  suffixText: 'cm',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  _sizeMeasurements[size]!['chest'] = value;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Length',
                                  border: OutlineInputBorder(),
                                  suffixText: 'cm',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  _sizeMeasurements[size]!['length'] = value;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Shoulder',
                                  border: OutlineInputBorder(),
                                  suffixText: 'cm',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  _sizeMeasurements[size]!['shoulder'] = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _saveProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B0331),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Save Product'),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
    );
  }
}
