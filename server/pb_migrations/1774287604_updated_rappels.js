/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_1758851292")

  collection.fields.removeById("text2420462245")

  collection.fields.removeById("text1636247659")

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_1758851292")

  collection.fields.addAt(15, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text2420462245",
    "max": 0,
    "min": 0,
    "name": "date_publication",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  collection.fields.addAt(16, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text1636247659",
    "max": 0,
    "min": 0,
    "name": "identification_produits",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  return app.save(collection)
})
