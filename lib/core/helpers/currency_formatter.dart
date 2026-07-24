abstract final class CurrencyFormatter {
  static String formatIdr(num amount, {bool includePrefix = true}) {
    final rounded = amount.round();
    final formatted = rounded.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );

    return includePrefix ? 'Rp $formatted' : formatted;
  }
}
