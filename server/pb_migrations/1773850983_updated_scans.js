/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_3789704380")

  collection.fields.addAt(6, new Field({
    "hidden": false,
    "id": "bool4251777245",
    "name": "is_favorite",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "bool"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_3789704380")

  collection.fields.removeById("bool4251777245")

  return app.save(collection)
})
