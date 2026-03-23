import 'package:pocketbase/pocketbase.dart';

class Rappel {
  final String gtin;
  final String numeroFiche;
  final String? libelle;
  final String? marqueProduit;
  final String? distributeurs;
  final String? zoneGeographiqueDeVente;
  final String? motifRappel;
  final String? risquesEncourus;
  final String? descriptionComplementaireRisque;
  final String? conduitesATenir;
  final String? informationsComplementaires;
  final String? liensVersLesImages;
  final String? lienVersAffichettePdf;
  final String? dateDebutCommercialisation;
  final String? dateFinCommercialisation;

  Rappel({
    required this.gtin,
    required this.numeroFiche,
    this.libelle,
    this.marqueProduit,
    this.distributeurs,
    this.zoneGeographiqueDeVente,
    this.motifRappel,
    this.risquesEncourus,
    this.descriptionComplementaireRisque,
    this.conduitesATenir,
    this.informationsComplementaires,
    this.liensVersLesImages,
    this.lienVersAffichettePdf,
    this.dateDebutCommercialisation,
    this.dateFinCommercialisation,
  });

  factory Rappel.fromRecord(RecordModel record) {
    return Rappel(
      gtin: record.getStringValue('gtin'),
      numeroFiche: record.getStringValue('numero_fiche'),
      libelle: record.getStringValue('libelle'),
      marqueProduit: record.getStringValue('marque_produit'),
      distributeurs: record.getStringValue('distributeurs'),
      zoneGeographiqueDeVente: record.getStringValue('zone_geographique_de_vente'),
      motifRappel: record.getStringValue('motif_rappel'),
      risquesEncourus: record.getStringValue('risques_encourus'),
      descriptionComplementaireRisque:
          record.getStringValue('description_complementaire_risque'),
      conduitesATenir: record.getStringValue('conduites_a_tenir'),
      informationsComplementaires:
          record.getStringValue('informations_complementaires'),
      liensVersLesImages: record.getStringValue('liens_vers_les_images'),
      lienVersAffichettePdf: record.getStringValue('lien_vers_affichette_pdf'),
      dateDebutCommercialisation:
          record.getStringValue('date_debut_commercialisation'),
      dateFinCommercialisation:
          record.getStringValue('date_fin_commercialisation'),
    );
  }

  /// Retourne la première URL d'image si disponible
  String? get firstImageUrl {
    if (liensVersLesImages == null || liensVersLesImages!.isEmpty) return null;
    // Les URLs sont parfois séparées par des '|' ou des virgules
    return liensVersLesImages!.split('|').first.trim();
  }

  /// Liste des conduites à tenir (split par '|')
  List<String> get conduitesATenirList {
    if (conduitesATenir == null || conduitesATenir!.isEmpty) return [];
    return conduitesATenir!.split('|').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
}
