abstract final class ApiConstants {
  static const baseUrl = 'https://api.waslninow.com/';
  static const mediaBaseUrl = 'https://dash.waslninow.com/';

  /// Resolves a relative media path against [mediaBaseUrl].
  /// Returns null for null/empty paths; passes through absolute http(s) URLs.
  static String? resolveMediaUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return '$mediaBaseUrl$path';
  }
}
