import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.scan, required this.onTap});

  final RecordModel scan;
  final VoidCallback onTap;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String _displayBrand = '';

  @override
  void initState() {
    super.initState();
    _initBrand();
  }

  void _initBrand() {
    final String brandRaw = widget.scan.getStringValue('brands', '');
    final String brandFallback = widget.scan.getStringValue('brand', 'Marque inconnue');
    _displayBrand = brandRaw.isNotEmpty ? brandRaw : brandFallback;
    
    if (_displayBrand == 'Marque inconnue') {
      final barcode = widget.scan.getStringValue('barcode', '');
      if (barcode.isNotEmpty) {
        _fetchBrandWithRetry(barcode, 3);
      }
    }
  }

  Future<void> _fetchBrandWithRetry(String barcode, int retries) async {
    await Future.delayed(Duration(milliseconds: 100 + (barcode.hashCode % 500)));
    try {
      final product = await OpenFoodFactsAPI().getProduct(barcode);
      if (product != null && product.brands != null && product.brands!.isNotEmpty) {
        if (mounted) {
          setState(() {
            _displayBrand = product.brands!.join(', ');
          });
        }
      }
    } catch (e) {
      if (retries > 0 && mounted) {
        await Future.delayed(const Duration(milliseconds: 800));
        _fetchBrandWithRetry(barcode, retries - 1);
      } else {
        debugPrint('ProductCard _fetchBrandWithRetry failure: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.scan.getStringValue('name', 'Inconnu');
    final String imageUrl = widget.scan.getStringValue('image_url', '');
    final String nutriscore = widget.scan.getStringValue('nutriscore', 'unknown');

    Color dotColor = Colors.grey;
    switch (nutriscore.toLowerCase()) {
      case 'a':
        dotColor = Colors.green;
        break;
      case 'b':
        dotColor = Colors.lightGreen;
        break;
      case 'c':
        dotColor = Colors.yellow;
        break;
      case 'd':
        dotColor = Colors.orange;
        break;
      case 'e':
        dotColor = Colors.red;
        break;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 24.0, bottom: 16.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 100),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 132.0,
                  top: 16.0,
                  bottom: 16.0,
                  right: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _displayBrand,
                      style: const TextStyle(
                        color: AppColors.grey2,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    if (nutriscore != 'unknown' && nutriscore.isNotEmpty)
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: dotColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Nutriscore : ${nutriscore.toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.grey3,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -20,
              left: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        color: AppColors.grey1,
                        child: const Icon(Icons.fastfood, color: Colors.grey),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
