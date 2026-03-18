import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';

class ProductTab3 extends StatelessWidget {
  const ProductTab3({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();
    final nutrition = product.nutritionFacts;

    if (nutrition == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Tableau nutritionnel indisponible'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(flex: 5, child: SizedBox()),
              Expanded(
                flex: 2, 
                child: Text('Pour 100g', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.right)
              ),
              Expanded(
                flex: 2, 
                child: Text('Par part', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.right)
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(),
          _buildTableRow('Énergie', nutrition.energy, isIndented: false),
          const Divider(),
          _buildTableRow('Matières grasses', nutrition.fat, isIndented: false),
          const Divider(),
          _buildTableRow('dont Acides gras saturés', nutrition.saturatedFat, isIndented: true),
          const Divider(),
          _buildTableRow('Glucides', nutrition.carbohydrate, isIndented: false),
          const Divider(),
          _buildTableRow('dont Sucres', nutrition.sugar, isIndented: true),
          const Divider(),
          _buildTableRow('Fibres alimentaires', nutrition.fiber, isIndented: false),
          const Divider(),
          _buildTableRow('Protéines', nutrition.proteins, isIndented: false),
          const Divider(),
          _buildTableRow('Sel', nutrition.salt, isIndented: false),
          const Divider(),
          _buildTableRow('Sodium', nutrition.sodium, isIndented: false),
        ],
      ),
    );
  }

  Widget _buildTableRow(String label, Nutriment? nutriment, {bool isIndented = false}) {
    final per100g = nutriment != null && nutriment.per100g != null 
        ? '${nutriment.per100g} ${nutriment.unit}' 
        : '?';
    
    final perServing = nutriment != null && nutriment.perServing != null 
        ? '${nutriment.perServing} ${nutriment.unit}' 
        : '?';

    return Padding(
      padding: EdgeInsets.only(
        top: 8.0, 
        bottom: 8.0, 
        left: isIndented ? 20.0 : 0.0
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: isIndented ? FontWeight.normal : FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              per100g,
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.grey3, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              perServing,
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.grey3, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
