const functions = require("firebase-functions");
const {fetchProducts} = require("./general");

exports.fetchProducts = functions.https.onCall(async (data, context) => {
  // console.log(data);
  if(!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated.');
  }

  return await fetchProducts(data);
});
