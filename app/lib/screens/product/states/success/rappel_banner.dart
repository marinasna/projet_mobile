import 'package:flutter/material.dart';
import 'package:formation_flutter/model/rappel.dart';

class RappelBanner extends StatelessWidget {
  const RappelBanner({super.key, required this.rappel, this.onTap});

  final Rappel rappel;
  final VoidCallback? onTap;

  // Couleur de fond : #FF0000 à 36% d'opacité
  static const Color _backgroundColor = Color(0x5CFF0000);
  // Couleur de premier plan : #A60000 à 100%
  static const Color _foregroundColor = Color(0xFFA60000);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: Ink(
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Ce produit fait l\'objet d\'un rappel produit',
                    style: const TextStyle(
                      color: _foregroundColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                const Icon(
                  Icons.arrow_forward,
                  color: _foregroundColor,
                  size: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
