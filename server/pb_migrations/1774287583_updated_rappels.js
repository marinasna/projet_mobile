/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_1758851292")

  collection.fields.removeById("text1056778892")

  collection.fields.removeById("text3711786323")

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_1758851292")

  collection.fields.addAt(15, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text1056778892",
    "max": 0,
    "min": 0,
    "name": "lien_vers_la_fiche_rappel",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  collection.fields.addAt(18, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text3711786323",
    "max": 0,
    "min": 0,
    "name": "conditionnements",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  return app.save(collection)
})
