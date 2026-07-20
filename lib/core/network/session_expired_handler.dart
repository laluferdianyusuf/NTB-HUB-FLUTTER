Future<void> Function()? onSessionExpired;

Future<void> notifySessionExpired() async {
  await onSessionExpired?.call();
}
