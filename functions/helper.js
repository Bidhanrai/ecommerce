const admin = require("firebase-admin");
const db = admin.firestore();

const serverErrorResponse = () => {
  // console.error(err); // Log the error
  throw new Error("Something went wrong on the server.");
};

const requestGetCollection = async ({collection, lastProductId, brandId}) => {
  if (brandId != null) {
    const result = [];
    await db.collection(collection)
        .limit(10)
        .where("brand", "==", brandId)
        .orderBy("id")
        .startAfter(lastProductId)
        .get()
        .then((querySnapshot) => {
          querySnapshot.forEach((documentSnapshot) => {
            result.push(documentSnapshot.data());
          });
        });
    return result;
  } else {
    const result = [];
    await db.collection(collection)
        .limit(10)
        .orderBy("id")
        .startAfter(lastProductId)
        .get()
        .then((querySnapshot) => {
        // console.log("Total data: ", querySnapshot.size);

          querySnapshot.forEach((documentSnapshot) => {
            result.push(documentSnapshot.data());
          });
        });
    return result;
  }
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
