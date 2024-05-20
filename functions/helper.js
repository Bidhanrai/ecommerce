const admin = require("firebase-admin");
const db = admin.firestore();

const serverErrorResponse = () => {
  // console.error(err); // Log the error
  throw new Error("Something went wrong on the server.");
};

const requestGetCollection = async ({collection, lastProductId, payload}) => {
  const result = [];

  const {brandId, color, gender, price, sortBy} = payload;

  let lastProductDoc = {};
  if (lastProductId) {
    lastProductDoc = await db.collection("products").doc(lastProductId).get();
    lastProductDoc = lastProductDoc.data();
  }

  let query = db.collection(collection)
      .limit(10);

  if (brandId) {
    query = query.where("brand", "==", brandId);
  }

  if (color) {
    query = query.where("color", "array-contains", color);
  }

  if (gender) {
    query = query.where("gender", "==", gender);
  }

  if (price) {
    query = query.where("price", ">=", price.min);
    query = query.where("price", "<=", price.max);
  }


  if (sortBy == "Lowest price") {
    query = query.orderBy("price", "asc");
    if (lastProductId) {
      query = query.orderBy("id");
      query = query.startAfter(lastProductDoc.price, lastProductId);
    }
  } else if (sortBy == "Most recent") {
    query = query.orderBy("createdDate", "desc");
    if (lastProductId) {
      query = query.orderBy("id");
      query = query.startAfter(lastProductDoc.createdDate, lastProductId);
    }
  } 
  // else if (sortBy == "Highest reviews") {
  //   console.log("Highest review");
  // } 
  else {
    if (lastProductId) {
      query = query.orderBy("id").startAfter(lastProductId);
    } else {
      query = query.orderBy("id");
    }
  }


  await query.get()
      .then((querySnapshot) => {
        querySnapshot.forEach((documentSnapshot) => {
          result.push(documentSnapshot.data());
        });
      });

  return result;
};


const requestGet = async ({collection, doc}) => {
  return db
      .collection(collection)
      .doc(doc)
      .get()
      .then((documentSnapshot) => {
        if (documentSnapshot.exists) {
          const document = documentSnapshot.data();
          return document;
        } else {
          return {data: []};
        }
      })
      .catch(serverErrorResponse);
};


module.exports = {requestGetCollection, requestGet};
