import 'package:flutter/material.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:provider/provider.dart';

class ProductTab1 extends StatelessWidget {
  const ProductTab1({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = context.read<Product>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionTitle(context, 'Ingrédients'),
        const SizedBox(height: 15.0),
        _buildInfoText(product.ingredients?.join(', ') ?? 'Non spécifié'),
        
        const SizedBox(height: 30.0),
        
        _buildSectionTitle(context, 'Substances allergènes'),
        const SizedBox(height: 15.0),
        _buildInfoText(
          product.allergens?.isNotEmpty == true 
            ? product.allergens!.join(', ') 
            : 'Aucune'
        ),
        
        const SizedBox(height: 30.0),
        
        _buildSectionTitle(context, 'Additifs'),
        const SizedBox(height: 15.0),
        _buildInfoText(
          product.additives?.isNotEmpty == true 
            ? product.additives!.values.join(', ') // Affiche les noms des additifs
            : 'Aucune'
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF6F6F8), // Très gris clair tirant sur le bleu
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.blue, 
          fontFamily: 'Avenir',
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.blue, 
          fontFamily: 'Avenir',
          fontSize: 15.0, 
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ),
    );
  }
}

