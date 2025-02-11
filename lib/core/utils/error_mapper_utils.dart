import '../constant/app_enums.dart';

class ErrorMapperUtils {
  static String errMessage({
    required ImplEvent implEvent,
  }) {
    switch (implEvent) {
      case ImplEvent.openCamera:
        return "Failed to open the camera. Please ensure the device allows camera access.";
      case ImplEvent.openScanner:
        return "Failed to open the scanner. Please ensure the device allows camera access.";
      case ImplEvent.getAccessCamera:
        return "The app requires permission to access the camera. Please enable camera access.";
      case ImplEvent.getAccessLocation:
        return "The app requires permission to access the location. Please enable location access.";
      case ImplEvent.loginFailed:
        return "Incorrect email or password.";
      case ImplEvent.fetchFailed:
        return "Failed to fetch data, please check your connection.";
      case ImplEvent.successShowAllData:
        return "All data has been displayed";

      case ImplEvent.successSaveQr:
        return "QR code save to gallery";

      case ImplEvent.failedSaveQr:
        return "Failed to save QR code";

      case ImplEvent.failedToValidateAddAsset:
        return "All data must be filled";
      case ImplEvent.failedToAddAsset:
        return "Opps...";
      default:
        return "";
    }
  }
}
