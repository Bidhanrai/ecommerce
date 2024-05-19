const admin = require("firebase-admin");
admin.initializeApp();

exports.fetchProducts = require("./general").fetchProducts;
