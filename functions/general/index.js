const functions = require("firebase-functions");
const {fetchProducts} = require("./general");

exports.fetchProducts = functions.https.onCall(async (data, context) => {
  // console.log(data);
  // checkAuthentication(context);

  return await fetchProducts(data);
});
