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

    const headerStyle = TextStyle(
      fontFamily: 'Avenir',
      fontWeight: FontWeight.w500, 
      fontSize: 12,
      color: AppColors.blue,
    );

    final divider = Divider(color: AppColors.grey1.withOpacity(0.5), height: 1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey1.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  const Expanded(flex: 5, child: SizedBox()),
                  const _VerticalSeparator(),
                  Expanded(
                    flex: 2, 
                    child: Text('Pour 100g', style: headerStyle, textAlign: TextAlign.center)
                  ),
                  const _VerticalSeparator(),
                  Expanded(
                    flex: 2, 
                    child: Text('Par part', style: headerStyle, textAlign: TextAlign.center)
                  ),
                ],
              ),
            ),
            divider,
            _buildTableRow('Énergie', nutrition.energy),
            divider,
            _buildTableRow('Matières grasses', nutrition.fat),
            divider,
            _buildTableRow('dont Acides gras saturés', nutrition.saturatedFat, isIndented: true),
            divider,
            _buildTableRow('Glucides', nutrition.carbohydrate),
            divider,
            _buildTableRow('dont Sucres', nutrition.sugar, isIndented: true),
            divider,
            _buildTableRow('Fibres alimentaires', nutrition.fiber),
            divider,
            _buildTableRow('Protéines', nutrition.proteins),
            divider,
            _buildTableRow('Sel', nutrition.salt),
            divider,
            _buildTableRow('Sodium', nutrition.sodium),
          ],
        ),
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

    final labelStyle = TextStyle(
      color: AppColors.blue,
      fontFamily: 'Avenir',
      fontWeight: isIndented ? FontWeight.w400 : FontWeight.w500,
      fontSize: 15,
    );

    final valueStyle = const TextStyle(
      color: AppColors.blue,
      fontFamily: 'Avenir',
      fontWeight: FontWeight.w400,
      fontSize: 15,
    );

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(
                top: 6.0, 
                bottom: 6.0, 
                left: isIndented ? 30.0 : 15.0
              ),
              child: Text(
                label,
                style: labelStyle,
              ),
            ),
          ),
          const _VerticalSeparator(),
          Expanded(
            flex: 2,
            child: Text(
              per100g,
              textAlign: TextAlign.center,
              style: valueStyle,
            ),
          ),
          const _VerticalSeparator(),
          Expanded(
            flex: 2,
            child: Text(
              perServing,
              textAlign: TextAlign.center,
              style: valueStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalSeparator extends StatelessWidget {
  const _VerticalSeparator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      color: AppColors.grey1.withOpacity(0.5),
    );
  }
}
