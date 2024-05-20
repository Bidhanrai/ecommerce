const functions = require("firebase-functions");
const {fetchProducts, filterProducts} = require("./general");

exports.fetchProducts = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated",
        "The function must be called while authenticated.");
  }

  return await fetchProducts(data);
});

exports.filterProducts = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated",
        "The function must be called while authenticated.");
  }

  return await filterProducts(data);
});

