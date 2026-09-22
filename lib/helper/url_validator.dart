class UrlValidator {
  // static bool isValidUrl(String url) {
  //   return !RegExp(r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?', caseSensitive: false).hasMatch(url);
  // }
  static bool isValidUrl(String url) {
    return RegExp(r'^https?:\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?$', caseSensitive: false,).hasMatch(url);
  }
}