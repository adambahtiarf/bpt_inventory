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

      default:
        return "";
    }
  }
}
