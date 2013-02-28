require(["./lib/gamecs/utils/matrix"], function(Matrix) {
  test("matrix calculation tests", function() {
    result = Matrix.add2([2, 3], [4, 6]);
    deepEqual( result, [[6, 9]], "Passed!" );

    result = Matrix.multiply2([[2, 3]], [[4], [6]]);
    deepEqual( result, [[26]], "Passed!" );

    result = Matrix.multiply2([[4], [6]], [[2, 3]]);
    deepEqual( result, [[8, 12], [12, 18]], "Passed!" );

    result = Matrix.multiply2([[1, 2], [3, 4]], [[5, 6], [7, 8]]);
    console.log(result);
    deepEqual( result, [[8, 12], [12, 18]], "Passed!" );
  });
});

