import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:pocketbase/pocketbase.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.scan, required this.onTap});

  final RecordModel scan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String name = scan.getStringValue('name', 'Inconnu');
    final String barcode = scan.getStringValue('barcode', '');
    final String imageUrl = scan.getStringValue('image_url', '');
    final String nutriscore = scan.getStringValue('nutriscore', 'unknown');

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
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                      barcode,
                      style: const TextStyle(
                        color: AppColors.grey2,
                        fontSize: 13,
                      ),
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
          ],
        ),
      ),
    );
  }
}
