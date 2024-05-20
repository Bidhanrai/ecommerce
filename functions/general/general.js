const {requestGetCollection, requestGet} = require("../helper");

exports.fetchProducts = async (data) => {
  const products = await requestGetCollection({
    collection: "products",
    lastProductId: data.lastProductId,
    payload: data.payload,
  });

  const reviewPromises = [];

  products.forEach((product) => {
    reviewPromises.push(
        requestGet({
          collection: "reviews",
          doc: product.id,
        }),
    );
  });

  const reviews = await Promise.all(reviewPromises);

  const response = products.map((product, productIndex) => {
    const review = reviews[productIndex];
    let totalStar = 0;
    let averageStar = 0;
    const totalReviewCount = review.data.length;

    review.data.forEach((rev) => {
      totalStar += rev.reviewStar;
    });
    averageStar = totalStar / totalReviewCount || 0;

    return {
      ...product,
      averageStar: averageStar,
      totalReviewCount: totalReviewCount,
    };
  });

  return response;
};


exports.filterProducts = async (data) => {
  // final Brand? selectedBrand;
//   final SortBy? selectedSortBy;

  // {"price": {"min": "sdaf", "max": "safs"}}}
  const products = await requestGetCollection({
    collection: "products",
    lastProductId: data.lastProductId,
    payload: data.payload,
  });

  const reviewPromises = [];

  products.forEach((product) => {
    reviewPromises.push(
        requestGet({
          collection: "reviews",
          doc: product.id,
        }),
    );
  });

  const reviews = await Promise.all(reviewPromises);

  const response = products.map((product, productIndex) => {
    const review = reviews[productIndex];
    let totalStar = 0;
    let averageStar = 0;
    const totalReviewCount = review.data.length;

    review.data.forEach((rev) => {
      totalStar += rev.reviewStar;
    });
    averageStar = totalStar / totalReviewCount || 0;

    return {
      ...product,
      averageStar: averageStar,
      totalReviewCount: totalReviewCount,
    };
  });

  return response;
};
