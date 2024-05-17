String removeTrailingZeros(double number) {
  String result = number.toString();
  if (result.contains('.')) {
    result = result.replaceAll(RegExp(r'0*$'), ''); // Removes trailing zeros
    if (result.endsWith('.')) {
      result = result.substring(0, result.length - 1); // Removes the decimal point if it's the last character
    }
  }
  return result;
}