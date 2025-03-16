import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  // Selected filter
  String selectedFilter = '5 Star';

  // Controller for reply text
  final TextEditingController _replyController = TextEditingController();

  // For tracking liked reviews and replies
  Set<String> likedItems = {};

  // For tracking expanded replies
  Set<String> expandedReplies = {};

  // For storing selected images URLs (using network images instead of local files)
  List<String> selectedImages = [];

  // For tracking which review is being replied to
  String? replyingTo;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Purple top area containing app bar and filters
          Container(
            color: const Color(0xFF2D1A45), // Dark purple background
            child: SafeArea(
              bottom: false, // Don't apply bottom safe area here
              child: Column(
                children: [
                  _buildAppBar(),
                  _buildRatingFilters(),
                ],
              ),
            ),
          ),
          // White bottom area containing reviews list and input
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: _buildReviewsList(),
                  ),
                  _buildReplyInput(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const Text(
            'REVIEWS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF3D2A55),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '4.8',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    ...List.generate(4, (index) => const Icon(Icons.star, color: Colors.amber, size: 16)),
                    const Icon(Icons.star_half, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      '2.3k reviews',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingFilters() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(Icons.grid_view, '', isSelected: selectedFilter == ''),
          _buildFilterChip(Icons.star, '5 Star', isSelected: selectedFilter == '5 Star'),
          _buildFilterChip(Icons.star, '4 Star', isSelected: selectedFilter == '4 Star', badgeCount: 2),
          _buildFilterChip(Icons.star, '3 Star', isSelected: selectedFilter == '3 Star', badgeCount: 4),
          _buildFilterChip(Icons.star, '2 Star', isSelected: selectedFilter == '2 Star'),
          _buildFilterChip(Icons.star, '1 Star', isSelected: selectedFilter == '1 Star'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(IconData icon, String label, {required bool isSelected, int? badgeCount}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3D2A55) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3D2A55)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            if (label.isNotEmpty) const SizedBox(width: 4),
            if (label.isNotEmpty)
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            if (badgeCount != null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        _buildReviewCard(
          id: 'review1',
          username: 'Dinushi Herath',
          rating: 4,
          timeAgo: '2d ago',
          reviewText: 'Love the quality of the dress! Perfect fit and amazing fabric.',
          likeCount: likedItems.contains('review1') ? 125 : 124,
          hasImages: true,
          replyCount: 8,
          hasSellerReply: true,
        ),
        const SizedBox(height: 12),
        _buildReviewCard(
          id: 'review2',
          username: 'Vishwajith Perera',
          rating: 5,
          timeAgo: '4d ago',
          reviewText: 'The shipping was super fast and the packaging was excellent!',
          likeCount: likedItems.contains('review2') ? 18 : 17,
          hasImages: false,
          replyCount: 0,
          hasSellerReply: false,
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String id,
    required String username,
    required int rating,
    required String timeAgo,
    required String reviewText,
    required int likeCount,
    required bool hasImages,
    required int replyCount,
    required bool hasSellerReply,
  }) {
    final sellerReplyId = id + '_seller';
    final isLiked = likedItems.contains(id);
    final isSellerReplyLiked = likedItems.contains(sellerReplyId);
    final isRepliesExpanded = expandedReplies.contains(id);
    final isSellerRepliesExpanded = expandedReplies.contains(sellerReplyId);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://placekitten.com/100/100?image=${username.hashCode}'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          ...List.generate(
                            rating,
                                (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
                          ),
                          ...List.generate(
                            5 - rating,
                                (index) => const Icon(Icons.star_border, color: Colors.amber, size: 16),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeAgo,
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
                IconButton(
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : null),
                  onPressed: () {
                    setState(() {
                      if (likedItems.contains(id)) {
                        likedItems.remove(id);
                      } else {
                        likedItems.add(id);
                      }
                    });
                  },
                ),
                Text(
                  '$likeCount',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              reviewText,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          if (hasImages)
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Show full-size image when tapped
                      _showFullSizeImage('https://picsum.photos/seed/${username.hashCode + index}/800/1200');
                    },
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage('https://picsum.photos/seed/${username.hashCode + index}/200/300'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      replyingTo = id;
                    });
                  },
                  child: const Text('Reply'),
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                if (replyCount > 0)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (expandedReplies.contains(id)) {
                          expandedReplies.remove(id);
                        } else {
                          expandedReplies.add(id);
                        }
                      });
                    },
                    child: Text(
                      isRepliesExpanded ? '- Hide Replies -' : '- View $replyCount More Replies -',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isRepliesExpanded)
            Container(
              margin: const EdgeInsets.only(left: 40, right: 12, bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Previous replies would appear here...',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          if (hasSellerReply)
            Container(
              margin: const EdgeInsets.only(left: 40, right: 12, bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage('https://placekitten.com/100/100?image=15'),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'My Fashion',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Seller',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Thank you for your lovely feedback! We\'re glad you loved it.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            replyingTo = sellerReplyId;
                          });
                        },
                        child: const Text('Reply'),
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (expandedReplies.contains(sellerReplyId)) {
                              expandedReplies.remove(sellerReplyId);
                            } else {
                              expandedReplies.add(sellerReplyId);
                            }
                          });
                        },
                        child: Text(
                          isSellerRepliesExpanded ? '- Hide Replies -' : '- View 1 Replies -',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                            isSellerReplyLiked ? Icons.favorite : Icons.favorite_border,
                            size: 16,
                            color: isSellerReplyLiked ? Colors.red : null
                        ),
                        onPressed: () {
                          setState(() {
                            if (likedItems.contains(sellerReplyId)) {
                              likedItems.remove(sellerReplyId);
                            } else {
                              likedItems.add(sellerReplyId);
                            }
                          });
                        },
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                      Text(
                        isSellerReplyLiked ? '101' : '100',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (isSellerRepliesExpanded)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reply to seller would appear here...',
                            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReplyInput() {
    String replyingToText = replyingTo != null ? 'Replying to review...' : 'Reply to review...';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false, // Don't apply top safe area here
        child: Column(
          children: [
            if (selectedImages.isNotEmpty)
              Container(
                height: 70,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(selectedImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImages.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage('https://placekitten.com/100/100?image=10'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _replyController,
                      decoration: InputDecoration(
                        hintText: replyingToText,
                        border: InputBorder.none,
                        hintStyle: const TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.photo_camera, color: Colors.grey),
                  onPressed: _pickImage,
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D1A45),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 16),
                    onPressed: () {
                      _sendReply();
                    },
                  ),
                ),
              ],
            ),
            if (replyingTo != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          replyingTo = null;
                          _replyController.clear();
                          selectedImages.clear();
                        });
                      },
                      child: const Text('Cancel Reply'),
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Image picker function (simplified without external dependencies)
  void _pickImage() {
    // Since we can't use image_picker, we'll simulate adding an image
    // In a real app, you would use image_picker or file_picker packages
    setState(() {
      // Add a placeholder image URL
      selectedImages.add('https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/200/200');
    });

    // Show a message that in a real app, this would open the gallery
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('In a real app, this would open the gallery to select an image'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Send reply function
  void _sendReply() {
    if (_replyController.text.isNotEmpty || selectedImages.isNotEmpty) {
      // Here you would typically send the reply to your backend
      // For now, we'll just show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reply sent${replyingTo != null ? ' to ${replyingTo!.contains("seller") ? "seller" : "review"}' : ''}'),
          duration: const Duration(seconds: 2),
        ),
      );

      // Clear input and reset state
      setState(() {
        _replyController.clear();
        selectedImages.clear();
        replyingTo = null;
      });
    }
  }

  // Show full size image
  void _showFullSizeImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}