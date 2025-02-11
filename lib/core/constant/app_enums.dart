enum ButtonEvent {
  cancel,

  primary,

  tertiary,

  secondary,

  alert
}

enum MessageEvent {
  error,

  success,

  info,
}

enum ImplEvent {
  openCamera,
  openScanner,
  getAccessCamera,
  getAccessLocation,
  loginFailed,
  fetchFailed,
  successShowAllData,
  successSaveQr,
  failedSaveQr,
  failedToValidateAddAsset,
  failedToAddAsset,
}

enum DeviceSizeEvent {
  width,

  height
}
