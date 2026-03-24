
function runFullSync() {
    console.log("-----------------------------------------");
    console.log("Starting FULL RappelSync (16k+ records)...");

    const collection = $app.findCollectionByNameOrId("rappels");
    if (!collection) {
        console.error("CRITICAL: Collection 'rappels' not found. Is it created?");
        return;
    }

    let lastGtin = "";
    let totalSynced = 0;
    let hasMore = true;
    const limit = 100;

    while (hasMore) {
        try {
            let url = "https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/rappelconso-v2-gtin-trie/records" +
                "?limit=" + limit +
                "&order_by=gtin" +
                (lastGtin ? "&where=gtin%20%3E%20%22" + lastGtin + "%22" : "");

            const response = $http.send({ url: url, method: "GET", timeout: 60 });

            if (response.statusCode !== 200) {
                console.error("API Error: HTTP " + response.statusCode);
                break;
            }

            const data = JSON.parse(response.raw);
            const records = data.results || [];

            if (records.length === 0) {
                hasMore = false;
                break;
            }

            for (let item of records) {
                const gtinStr = item.gtin ? item.gtin.toString().trim() : "";
                if (!gtinStr || !item.numero_fiche) continue;

                let record;
                try {
                    record = $app.findFirstRecordByFilter("rappels", "numero_fiche = {:nf} && gtin = {:gtin}", {
                        nf: item.numero_fiche,
                        gtin: gtinStr
                    });
                } catch (e) {
                    record = new Record(collection);
                }

                record.set("gtin", gtinStr);
                record.set("numero_fiche", item.numero_fiche);
                record.set("libelle", item.libelle);
                record.set("marque_produit", item.marque_produit);
                record.set("distributeurs", item.distributeurs);
                record.set("zone_geographique_de_vente", item.zone_geographique_de_vente);
                record.set("motif_rappel", item.motif_rappel);
                record.set("risques_encourus", item.risques_encourus);
                record.set("description_complementaire_risque", item.description_complementaire_risque);
                record.set("conduites_a_tenir", item.conduites_a_tenir);
                record.set("informations_complementaires", item.informations_complementaires);
                record.set("liens_vers_les_images", item.liens_vers_les_images);
                record.set("lien_vers_affichette_pdf", item.lien_vers_affichette_pdf);
                record.set("date_debut_commercialisation", item.date_debut_commercialisation);
                record.set("date_fin_commercialisation", item.date_fin_commercialisation);

                $app.save(record);
                lastGtin = gtinStr;
                totalSynced++;
            }

            if (totalSynced % 500 === 0) {
                console.log("Progress: " + totalSynced + " records synced...");
            }

            if (records.length < limit) {
                hasMore = false;
            }

        } catch (err) {
            console.error("Batch error: " + err.message);
            hasMore = false;
        }
    }

    console.log(" Full Sync finished. Total: " + totalSynced + " records.");
}

cronAdd("sync_rappels_job", "0 0,12 * * *", () => {
    runFullSync();
});

routerAdd("GET", "/api/sync-rappels", (c) => {
    runFullSync();
    return c.json(200, { message: "Sync process started manually." });
});

console.log("RappelSync Hook Ready (16k Dataset Keysets)");
