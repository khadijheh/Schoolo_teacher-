import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

class TranslationHelper {
  static final Map<String, String> _translationCache = {};
  static final Set<String> _loggedMissingTranslations = {};

  static String translateDynamicText(String text) {
    if (text.isEmpty) return text;
    
    // التحقق من الذاكرة المؤقتة أولاً
    if (_translationCache.containsKey(text)) {
      return _translationCache[text]!;
    }

    // 1. التحقق من الترجمة المباشرة أولاً
    try {
      final directTranslation = text.tr();
      if (directTranslation != text) {
        _translationCache[text] = directTranslation;
        return directTranslation;
      }
    } catch (_) {}

    // 2. إنشاء مفتاح ترجمة موحد
    final unifiedKey = _createUnifiedKey(text);

    // 3. محاولة الترجمة باستخدام المفتاح الموحد
    try {
      final translated = unifiedKey.tr();
      if (translated != unifiedKey) {
        _translationCache[text] = translated;
        return translated;
      }
    } catch (_) {}

    // 4. تسجيل النصوص المفقودة (لأغراض التطوير فقط)
    if (!_loggedMissingTranslations.contains(text)) {
      _loggedMissingTranslations.add(text);
      debugPrint('⚠️ Missing Translation for: "$text" | Suggested Key: "$unifiedKey"');
    }

    // 5. العودة للنص الأصلي إذا لم توجد ترجمة
    return text;
  }

  static String _createUnifiedKey(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\u0600-\u06FF]'), '_') // دعم العربية
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  // يمكن إضافة هذه الدالة لتحميل ترجمات مخصصة من API
  static Future<void> loadCustomTranslations() async {
    // مثال:
    // final translations = await ApiService.fetchTranslations();
    // _translationCache.addAll(translations);
  }
}