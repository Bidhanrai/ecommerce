const {requestGetCollection, requestGet} = require("../helper");

exports.fetchProducts = async (data) => {
  const products = await requestGetCollection({
    collection: "products",
    lastProductId: data.lastProductId,
    brandId: data.brandId,
  });

  const promiseAll = [];

  products.forEach((product) => {
    promiseAll.push(
        requestGet({
          collection: "reviews",
          doc: product.id,
        }),
    );
  });

  const reviews = await Promise.all(promiseAll);

  // console.log(JSON.stringify(reviews));


  const response = products.map((product, productIndex) => {
    const review = reviews[productIndex];
    let totalStar = 0;
    const totalReviews = review.data.length;

    review.data.forEach((rev)=> {
      totalStar+=rev["reviewStar"];
    });

    return {
      ...product,
      // reviews: review.data,
      averageStar: totalReviews == 0?0:totalStar/totalReviews,
      totalReviewCount: totalReviews,
    };
  });

  return response;
};
