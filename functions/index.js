const admin = require("firebase-admin");
admin.initializeApp();

exports.fetchProducts = require("./general").fetchProducts;
exports.filterProducts = require("./general").filterProducts;
