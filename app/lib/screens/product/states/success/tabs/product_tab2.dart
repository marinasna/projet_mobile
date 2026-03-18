import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
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
          Center(
            child: Text(
              'Repères nutritionnels pour 100g',
              style: context.theme.title3.copyWith(color: AppColors.grey2),
            ),
          ),
          const SizedBox(height: 40),
          
          _buildNutrientRow(
            label: 'Matières grasses / lipides',
            nutriment: nutrition?.fat,
            level: levels?.fat,
          ),
          const SizedBox(height: 20),
          _buildNutrientRow(
            label: 'Acides gras saturés',
            nutriment: nutrition?.saturatedFat,
            level: levels?.saturatedFat,
          ),
          const SizedBox(height: 20),
          _buildNutrientRow(
            label: 'Sucres',
            nutriment: nutrition?.sugar,
            level: levels?.sugars,
          ),
          const SizedBox(height: 20),
          _buildNutrientRow(
            label: 'Sel',
            nutriment: nutrition?.salt,
            level: levels?.salt,
          ),
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
          levelColor = AppColors.greenScoreA; // Vert
          levelText = 'Faible quantité';
          break;
        case 'moderate':
          levelColor = Colors.orange; // Orange
          levelText = 'Quantité modérée';
          break;
        case 'high':
          levelColor = AppColors.greenScoreE; // Rouge
          levelText = 'Quantité élevée';
          break;
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.blue, 
              fontWeight: FontWeight.w600,
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
                style: const TextStyle(
                  color: AppColors.grey3,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                levelText,
                style: TextStyle(
                  color: levelColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

