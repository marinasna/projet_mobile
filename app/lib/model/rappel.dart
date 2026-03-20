class Rappel {
  final String gtin;
  final String numeroFiche;
  final String? libelle;
  final String? marqueProduit;
  final String? modelesOuReferences;
  final String? categorieProduit;
  final String? sousCategoriseProduit;
  final String? natureJuridiqueRappel;
  final String? dateDebutCommercialisation;
  final String? dateFinCommercialisation;
  final String? distributeurs;
  final String? zoneGeographiqueDeVente;
  final String? motifRappel;
  final String? risquesEncourus;
  final String? descriptionComplementaireRisque;
  final String? conduitesATenir;
  final String? informationsComplementaires;
  final String? liensVersLesImages;
  final String? lienVersAffichettePdf;
  final String? lienVersLaFicheRappel;
  final String? datePublication;
  final String? dateFinProcedure;
  final String? numeroContact;
  final String? modalitesCompensation;
  final String? temperatureConservation;
  final String? marqueSalubrite;
  final String? identificationProduits;
  final String? conditionnements;

  Rappel({
    required this.gtin,
    required this.numeroFiche,
    this.libelle,
    this.marqueProduit,
    this.modelesOuReferences,
    this.categorieProduit,
    this.sousCategoriseProduit,
    this.natureJuridiqueRappel,
    this.dateDebutCommercialisation,
    this.dateFinCommercialisation,
    this.distributeurs,
    this.zoneGeographiqueDeVente,
    this.motifRappel,
    this.risquesEncourus,
    this.descriptionComplementaireRisque,
    this.conduitesATenir,
    this.informationsComplementaires,
    this.liensVersLesImages,
    this.lienVersAffichettePdf,
    this.lienVersLaFicheRappel,
    this.datePublication,
    this.dateFinProcedure,
    this.numeroContact,
    this.modalitesCompensation,
    this.temperatureConservation,
    this.marqueSalubrite,
    this.identificationProduits,
    this.conditionnements,
  });

  factory Rappel.fromJson(Map<String, dynamic> json) {
    return Rappel(
      gtin: json['gtin']?.toString() ?? '',
      numeroFiche: json['numero_fiche'] as String? ?? '',
      libelle: json['libelle'] as String?,
      marqueProduit: json['marque_produit'] as String?,
      modelesOuReferences: json['modeles_ou_references'] as String?,
      categorieProduit: json['categorie_produit'] as String?,
      sousCategoriseProduit: json['sous_categorie_produit'] as String?,
      natureJuridiqueRappel: json['nature_juridique_rappel'] as String?,
      dateDebutCommercialisation:
          json['date_debut_commercialisation'] as String?,
      dateFinCommercialisation:
          json['date_date_fin_commercialisation'] as String?,
      distributeurs: json['distributeurs'] as String?,
      zoneGeographiqueDeVente: json['zone_geographique_de_vente'] as String?,
      motifRappel: json['motif_rappel'] as String?,
      risquesEncourus: json['risques_encourus'] as String?,
      descriptionComplementaireRisque:
          json['description_complementaire_risque'] as String?,
      conduitesATenir: json['conduites_a_tenir_par_le_consommateur'] as String?,
      informationsComplementaires:
          json['informations_complementaires_publiques'] as String?,
      liensVersLesImages: json['liens_vers_les_images'] as String?,
      lienVersAffichettePdf: json['lien_vers_affichette_pdf'] as String?,
      lienVersLaFicheRappel: json['lien_vers_la_fiche_rappel'] as String?,
      datePublication: json['date_publication'] as String?,
      dateFinProcedure: json['date_de_fin_de_la_procedure_de_rappel'] as String?,
      numeroContact: json['numero_contact'] as String?,
      modalitesCompensation: json['modalites_de_compensation'] as String?,
      temperatureConservation: json['temperature_conservation'] as String?,
      marqueSalubrite: json['marque_salubrite'] as String?,
      identificationProduits: json['identification_produits'] as String?,
      conditionnements: json['conditionnements'] as String?,
    );
  }

  /// Retourne la première URL d'image si disponible
  String? get firstImageUrl {
    if (liensVersLesImages == null || liensVersLesImages!.isEmpty) return null;
    return liensVersLesImages!.split('|').first.trim();
  }

  /// Retourne toutes les URLs d'images
  List<String> get imageUrls {
    if (liensVersLesImages == null || liensVersLesImages!.isEmpty) return [];
    return liensVersLesImages!
        .split('|')
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toList();
  }

  /// Retourne les conduites à tenir sous forme de liste
  List<String> get conduitesATenirList {
    if (conduitesATenir == null || conduitesATenir!.isEmpty) return [];
    return conduitesATenir!
        .split('|')
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toList();
  }
}
