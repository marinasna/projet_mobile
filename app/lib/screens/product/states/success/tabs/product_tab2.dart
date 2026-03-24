import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';

class ProductTab2 extends StatelessWidget {
  const ProductTab2({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();
    final nutrition = product.nutritionFacts;
    final levels = product.nutrientLevels;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          
          const Divider(color: AppColors.grey1, height: 1),
          _buildNutrientRow(
            label: 'Matières grasses / lipides',
            nutriment: nutrition?.fat,
            level: levels?.fat,
          ),
          const Divider(color: AppColors.grey1, height: 1),
          _buildNutrientRow(
            label: 'Acides gras saturés',
            nutriment: nutrition?.saturatedFat,
            level: levels?.saturatedFat,
          ),
          const Divider(color: AppColors.grey1, height: 1),
          _buildNutrientRow(
            label: 'Sucres',
            nutriment: nutrition?.sugar,
            level: levels?.sugars,
          ),
          const Divider(color: AppColors.grey1, height: 1),
          _buildNutrientRow(
            label: 'Sel',
            nutriment: nutrition?.salt,
            level: levels?.salt,
          ),
          const Divider(color: AppColors.grey1, height: 1),
        ],
      ),
    );
  }

  Widget _buildNutrientRow({
    required String label,
    required Nutriment? nutriment,
    required String? level,
  }) {
    final valueText = nutriment != null && nutriment.per100g != null
        ? '${nutriment.per100g}${nutriment.unit}' 
        : '?';

    Color levelColor = AppColors.grey2;
    String levelText = 'Inconnu';

    if (level != null) {
      switch (level.toLowerCase()) {
        case 'low':
          levelColor = AppColors.nutrientLevelLow;
          levelText = 'Faible quantité';
          break;
        case 'moderate':
          levelColor = AppColors.nutrientLevelModerate;
          levelText = 'Quantité modérée';
          break;
        case 'high':
          levelColor = AppColors.nutrientLevelHigh;
          levelText = 'Quantité élevée';
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0), // Increased spacing
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.blue, 
                fontFamily: 'Avenir',
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  valueText,
                  style: TextStyle(
                    color: levelColor,
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Text(
                  levelText,
                  style: TextStyle(
                    color: levelColor,
                    fontFamily: 'Avenir',
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

