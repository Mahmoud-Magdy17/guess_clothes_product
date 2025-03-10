import 'dart:typed_data';

import 'models/prediction_model.dart';
import 'base_clothes_prediction.dart';
import 'dress_trousers_bag_prediction.dart';
import 'shirt_tshirt_shoes_model_prediction.dart';

class ClothesPrediction extends BaseClothesPrediction {
  ShirtTshirtShoesModelPrediction shirtTshirtShoesPrediction =
      ShirtTshirtShoesModelPrediction();
  DressTrousersBagPrediction dressTrousersBagPrediction =
      DressTrousersBagPrediction();
  String? predictionResult;
  Future<void> predictImageType(Uint8List image) async {
    shirtTshirtShoesPrediction.prediction =
        await shirtTshirtShoesPrediction.predict(
      imageUint8: image,
    );
    dressTrousersBagPrediction.prediction =
        await dressTrousersBagPrediction.predict(
      imageUint8: image,
    );
    predictionResult = getFinalResultPrediction(
      firstPrediction: dressTrousersBagPrediction.prediction,
      secondPrediction: shirtTshirtShoesPrediction.prediction,
    );
  }

  String? getFinalResultPrediction({
    required PredictionModel? firstPrediction,
    required PredictionModel? secondPrediction,
  }) {
    if (firstPrediction == null || secondPrediction == null) {
      return null;
    }
    if (firstPrediction.predictionValues![firstPrediction.predictionResult!] <
            90 &&
        secondPrediction.predictionValues![secondPrediction.predictionResult!] <
            90) {
      return "no valid clothes";
    }
    if (firstPrediction.predictionValues![firstPrediction.predictionResult!] >
        secondPrediction
            .predictionValues![secondPrediction.predictionResult!]) {
      return firstPrediction.lables![firstPrediction.predictionResult!];
    } else {
      return secondPrediction.lables![secondPrediction.predictionResult!];
    }
  }
}
