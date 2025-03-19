import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ReviewsScreen extends StatefulWidget {
  final String shopId;

  const ReviewsScreen({
    Key? key,
    required this.shopId,
  }) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;
  double _averageRating = 0;
  Map<int, int> _ratingDistribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
      final supabase = Supabase.instance.client;
      
      // Fetch reviews with product and buyer information
      final response = await supabase
          .from('reviews')
          .select('''
            *,
            products (
              name,
              image_url
            ),
            buyers (
              name,
              profile_photo
            )
          ''')
          .eq('shop_id', widget.shopId)
          .order('created_at', ascending: false);

      if (mounted) {
        final reviews = List<Map<String, dynamic>>.from(response);
        
        // Calculate average rating and distribution
        double totalRating = 0;
        Map<int, int> distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
        
        for (var review in reviews) {
          final rating = review['rating'] as int;
          totalRating += rating;
          distribution[rating] = (distribution[rating] ?? 0) + 1;
        }

        setState(() {
          _reviews = reviews;
          _isLoading = false;
          _averageRating = reviews.isEmpty ? 0 : totalRating / reviews.length;
          _ratingDistribution = distribution;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading reviews: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top App Bar
          Container(
            width: double.infinity,
            height: 140,
            decoration: const BoxDecoration(
              color: Color(0xFF1A0038),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'REVIEWS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          child: Text(
                            '${_reviews.length} Reviews',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Reviews Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadReviews,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Rating Summary Card
                        _buildRatingSummaryCard(),
                        const SizedBox(height: 20),

                        // Reviews List
                        ..._reviews.map((review) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildReviewCard(review),
                        )).toList(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A0038),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        size: 20,
                        color: index < _averageRating.round()
                            ? Colors.amber
                            : Colors.grey[300],
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Based on ${_reviews.length} reviews',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Rating Distribution
          ...[5, 4, 3, 2, 1].map((rating) {
            final count = _ratingDistribution[rating] ?? 0;
            final percentage = _reviews.isEmpty ? 0.0 
                : (count / _reviews.length * 100);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(
                    '$rating',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.star, size: 12, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFF1A0038),
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final product = review['products'] as Map<String, dynamic>;
    final buyer = review['buyers'] as Map<String, dynamic>;
    final rating = review['rating'] as int;
    final comment = review['comment'] as String;
    final createdAt = DateTime.parse(review['created_at']);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product and Buyer Info
          Row(
            children: [
              // Product Image
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(product['image_url'] ?? ''),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? 'Unknown Product',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage(
                            buyer['profile_photo'] ?? '',
                          ),
                          onBackgroundImageError: (_, __) {},
                        ),
                        const SizedBox(width: 4),
                        Text(
                          buyer['name'] ?? 'Unknown Buyer',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                DateFormat('MMM d, y').format(createdAt),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Rating
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star,
                size: 16,
                color: index < rating ? Colors.amber : Colors.grey[300],
              );
            }),
          ),
          const SizedBox(height: 8),
          
          // Review Comment
          Text(
            comment,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
