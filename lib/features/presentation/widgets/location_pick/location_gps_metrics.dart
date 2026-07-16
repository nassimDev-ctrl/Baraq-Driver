/// مقاييس GPS المستخدمة في واجهة اختيار الموقع.
///
/// ## دقة الموقع (Location Accuracy)
/// القيمة تأتي مباشرة من نظام التشغيل عبر حزمة [geolocator]:
/// `Position.accuracy` بعد استدعاء `Geolocator.getCurrentPosition`.
///
/// - على Android: `Location.getAccuracy()` من GPS / Fused Location Provider.
/// - على iOS: `CLLocation.horizontalAccuracy` من Core Location.
///
/// المعنى: نصف قطر الدائرة (بالأمتار) الذي يُحتمل أن يكون فيه الجهاز
/// حول الإحداثيات المُرجَعة. مثال: `4` تعني ±4 أمتار تقريباً.
///
/// تُحدَّث حالياً عند:
/// - أول تحميل للموقع (`_loadCurrentLocationFirst`)
/// - الضغط على "استخدم موقعي الحالي" أو زر إعادة التمركز
///
/// لا تتغير عند سحب الخريطة يدوياً — لأن المستخدم يختار نقطة على الخريطة
/// وليس موقع GPS الحي للجهاز.
///
/// ## جودة الإشارة (Signal Quality Badge)
/// **ليست** قياساً حقيقياً لقوة شبكة الجوال أو عدد أقمار GPS.
/// هي تقدير بصري مبني على نفس قيمة [accuracyMeters]:
///
/// | الدقة (متر) | التصنيف        |
/// |-------------|----------------|
/// | ≤ 8         | ممتازة         |
/// | ≤ 20        | جيدة           |
/// | > 20        | متوسطة         |
/// | null        | جاري التحديد   |
enum GpsAccuracyQuality {
  detecting,
  excellent,
  good,
  fair,
}

abstract final class LocationGpsMetrics {
  static const excellentThresholdMeters = 8.0;
  static const goodThresholdMeters = 20.0;

  static GpsAccuracyQuality qualityFromAccuracy(double? accuracyMeters) {
    if (accuracyMeters == null) return GpsAccuracyQuality.detecting;
    if (accuracyMeters <= excellentThresholdMeters) {
      return GpsAccuracyQuality.excellent;
    }
    if (accuracyMeters <= goodThresholdMeters) {
      return GpsAccuracyQuality.good;
    }
    return GpsAccuracyQuality.fair;
  }

  static String qualityTranslationKey(GpsAccuracyQuality quality) {
    return switch (quality) {
      GpsAccuracyQuality.detecting => 'signal_quality_detecting',
      GpsAccuracyQuality.excellent => 'signal_quality_excellent',
      GpsAccuracyQuality.good => 'signal_quality_good',
      GpsAccuracyQuality.fair => 'signal_quality_fair',
    };
  }

  static String formatAccuracyMeters(double? accuracyMeters) {
    if (accuracyMeters == null) return '--';
    return accuracyMeters.round().toString();
  }
}
