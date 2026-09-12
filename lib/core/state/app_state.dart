import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import '../services/local_store.dart';
import '../utils/jalali.dart';

class CravingLog {
  const CravingLog({
    required this.at,
    required this.intensity,
    required this.trigger,
    required this.intervention,
    required this.passed,
  });

  final DateTime at;
  final int intensity;
  final String trigger;
  final String intervention;
  final bool passed;

  Map<String, dynamic> toJson() => {
        'at': at.toIso8601String(),
        'intensity': intensity,
        'trigger': trigger,
        'intervention': intervention,
        'passed': passed,
      };

  factory CravingLog.fromJson(Map<String, dynamic> json) => CravingLog(
        at: _date(json['at'], DateTime.now()),
        intensity: _int(json['intensity'], 1),
        trigger: _string(json['trigger'], 'نامشخص'),
        intervention: _string(json['intervention'], 'بدون راهکار ثبت‌شده'),
        passed: _bool(json['passed'], false),
      );
}

class SlipLog {
  const SlipLog({required this.at, required this.count, required this.reason});
  final DateTime at;
  final int count;
  final String reason;

  Map<String, dynamic> toJson() => {'at': at.toIso8601String(), 'count': count, 'reason': reason};
  factory SlipLog.fromJson(Map<String, dynamic> json) => SlipLog(
        at: _date(json['at'], DateTime.now()),
        count: _int(json['count'], 1),
        reason: _string(json['reason'], ''),
      );
}

class JournalEntry {
  const JournalEntry({required this.at, required this.mood, required this.note});
  final DateTime at;
  final String mood;
  final String note;

  Map<String, dynamic> toJson() => {'at': at.toIso8601String(), 'mood': mood, 'note': note};
  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
        at: _date(json['at'], DateTime.now()),
        mood: _string(json['mood'], 'معمولی'),
        note: _string(json['note'], ''),
      );
}

class UserFeedbackItem {
  const UserFeedbackItem({
    required this.at,
    required this.category,
    required this.message,
    this.contact,
  });

  final DateTime at;
  final String category;
  final String message;
  final String? contact;

  Map<String, dynamic> toJson() => {
        'at': at.toIso8601String(),
        'category': category,
        'message': message,
        'contact': contact,
      };

  factory UserFeedbackItem.fromJson(Map<String, dynamic> json) => UserFeedbackItem(
        at: _date(json['at'], DateTime.now()),
        category: _string(json['category'], 'سایر'),
        message: _string(json['message'], ''),
        contact: json['contact']?.toString(),
      );
}

class HopePost {
  HopePost({
    required this.id,
    required this.authorAlias,
    required this.message,
    required this.smokeFreeDays,
    required this.createdAt,
    required this.verifiedProgress,
    this.savedMoneyToman,
    this.goalTitle,
    this.hopeCount = 0,
    this.reactedByMe = false,
    this.reported = false,
  });

  final String id;
  final String authorAlias;
  final String message;
  final int smokeFreeDays;
  final DateTime createdAt;
  final bool verifiedProgress;
  final int? savedMoneyToman;
  final String? goalTitle;
  int hopeCount;
  bool reactedByMe;
  bool reported;

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorAlias': authorAlias,
        'message': message,
        'smokeFreeDays': smokeFreeDays,
        'createdAt': createdAt.toIso8601String(),
        'verifiedProgress': verifiedProgress,
        'savedMoneyToman': savedMoneyToman,
        'goalTitle': goalTitle,
        'hopeCount': hopeCount,
        'reactedByMe': reactedByMe,
        'reported': reported,
      };

  factory HopePost.fromJson(Map<String, dynamic> json) => HopePost(
        id: _string(json['id'], 'post-${DateTime.now().microsecondsSinceEpoch}'),
        authorAlias: _string(json['authorAlias'], 'کاربر نفس'),
        message: _string(json['message'], ''),
        smokeFreeDays: _int(json['smokeFreeDays'], 0),
        createdAt: _date(json['createdAt'], DateTime.now()),
        verifiedProgress: _bool(json['verifiedProgress'], false),
        savedMoneyToman: json['savedMoneyToman'] is num ? (json['savedMoneyToman'] as num).toInt() : null,
        goalTitle: json['goalTitle']?.toString(),
        hopeCount: _int(json['hopeCount'], 0),
        reactedByMe: _bool(json['reactedByMe'], false),
        reported: _bool(json['reported'], false),
      );
}

enum JourneyDayStatus { beforeJourney, future, smokeFree, craving, slip }
enum AccountProvider { guest, phone, google }

class NafasAppState extends ChangeNotifier {
  NafasAppState();

  static const _storageKey = 'nafas_state_v2';

  bool hydrated = false;
  DateTime? lastLocalSaveAt;
  String? persistenceError;

  bool onboardingComplete = false;
  int cigarettesPerDay = 10;
  int cigarettesPerPack = 20;
  int packPriceToman = 85000;
  DateTime quitJourneyStartedAt = DateTime.now();
  DateTime currentStreakStartedAt = DateTime.now();
  String goalTitle = 'سفر رویایی';
  int goalAmountToman = 10000000;
  bool hasGoal = true;
  bool remindersEnabled = false;
  int reminderHour = 20;
  int reminderMinute = 0;
  bool riskyTimeRemindersEnabled = false;
  bool communityNotificationsEnabled = false;
  int selectedMainTab = 0;

  String displayName = '';
  String mobile = '';
  String email = '';
  String communityAlias = 'یک نفس تازه';
  bool communityShareProgressDefault = true;
  bool communityShareSavingsDefault = false;
  String personalQuitReason = '';
  AccountProvider accountProvider = AccountProvider.guest;

  String trustedContactName = '';
  String trustedContactPhone = '';

  final List<String> customTriggers = [];
  final List<String> customInterventions = [];
  final List<CravingLog> cravings = [];
  final List<SlipLog> slips = [];
  final List<JournalEntry> journalEntries = [];
  final List<HopePost> hopePosts = [];
  final List<UserFeedbackItem> feedbackItems = [];

  bool get isSignedIn => accountProvider != AccountProvider.guest;
  bool get localPersistenceDurable => NafasLocalStore.instance.isDurable;
  String get persistenceLabel => NafasLocalStore.instance.platformLabel;
  double get cigarettePrice => packPriceToman / max(1, cigarettesPerPack);
  Duration get streak => DateTime.now().difference(currentStreakStartedAt);
  int get smokeFreeDays => max(0, streak.inDays);
  int get cigarettesAvoided => max(0, (streak.inHours / 24 * cigarettesPerDay).floor());
  double get moneySaved => cigarettesAvoided * cigarettePrice;
  double get goalProgress => !hasGoal || goalAmountToman <= 0 ? 0.0 : (moneySaved / goalAmountToman).clamp(0.0, 1.0).toDouble();
  double get dailySpend => cigarettesPerDay * cigarettePrice;

  int get estimatedGoalDaysRemaining {
    if (!hasGoal || dailySpend <= 0) return 0;
    final remaining = max(0, goalAmountToman - moneySaved);
    return (remaining / dailySpend).ceil();
  }

  List<HopePost> get visibleHopePosts => hopePosts.where((post) => !post.reported).toList(growable: false);

  String? get topCravingTrigger {
    if (cravings.isEmpty) return null;
    final counts = <String, int>{};
    for (final craving in cravings) {
      counts[craving.trigger] = (counts[craving.trigger] ?? 0) + 1;
    }
    return (counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first.key;
  }

  String? get topHelpfulIntervention {
    final passed = cravings.where((item) => item.passed && item.intervention.trim().isNotEmpty);
    if (passed.isEmpty) return null;
    final counts = <String, int>{};
    for (final craving in passed) {
      counts[craving.intervention] = (counts[craving.intervention] ?? 0) + 1;
    }
    return (counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first.key;
  }

  String? get riskyTimeLabel {
    if (cravings.isEmpty) return null;
    final buckets = <String, int>{'صبح': 0, 'ظهر': 0, 'عصر': 0, 'شب': 0};
    for (final item in cravings) {
      final h = item.at.hour;
      final key = h >= 6 && h < 12 ? 'صبح' : h >= 12 && h < 17 ? 'ظهر' : h >= 17 && h < 22 ? 'عصر' : 'شب';
      buckets[key] = (buckets[key] ?? 0) + 1;
    }
    return (buckets.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first.key;
  }

  String? get latestMood {
    if (journalEntries.isEmpty) return null;
    final sorted = [...journalEntries]..sort((a, b) => b.at.compareTo(a.at));
    return sorted.first.mood;
  }

  Future<void> hydrate() async {
    try {
      final raw = await NafasLocalStore.instance.read(_storageKey);
      if (raw != null && raw.trim().isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is Map) _restore(Map<String, dynamic>.from(decoded));
      }
      persistenceError = null;
    } catch (error) {
      persistenceError = error.toString();
    } finally {
      hydrated = true;
      super.notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    if (hydrated) unawaited(_persist());
  }

  Future<void> _persist() async {
    try {
      await NafasLocalStore.instance.write(_storageKey, jsonEncode(_toJson()));
      lastLocalSaveAt = DateTime.now();
      persistenceError = null;
    } catch (error) {
      persistenceError = error.toString();
    }
  }

  Future<void> forceSave() => _persist();

  Map<String, dynamic> _toJson() => {
        'schema': 3,
        'onboardingComplete': onboardingComplete,
        'cigarettesPerDay': cigarettesPerDay,
        'cigarettesPerPack': cigarettesPerPack,
        'packPriceToman': packPriceToman,
        'quitJourneyStartedAt': quitJourneyStartedAt.toIso8601String(),
        'currentStreakStartedAt': currentStreakStartedAt.toIso8601String(),
        'goalTitle': goalTitle,
        'goalAmountToman': goalAmountToman,
        'hasGoal': hasGoal,
        'remindersEnabled': remindersEnabled,
        'reminderHour': reminderHour,
        'reminderMinute': reminderMinute,
        'riskyTimeRemindersEnabled': riskyTimeRemindersEnabled,
        'communityNotificationsEnabled': communityNotificationsEnabled,
        'selectedMainTab': selectedMainTab,
        'displayName': displayName,
        'mobile': mobile,
        'email': email,
        'communityAlias': communityAlias,
        'communityShareProgressDefault': communityShareProgressDefault,
        'communityShareSavingsDefault': communityShareSavingsDefault,
        'personalQuitReason': personalQuitReason,
        'accountProvider': accountProvider.name,
        'trustedContactName': trustedContactName,
        'trustedContactPhone': trustedContactPhone,
        'customTriggers': customTriggers,
        'customInterventions': customInterventions,
        'cravings': cravings.map((e) => e.toJson()).toList(),
        'slips': slips.map((e) => e.toJson()).toList(),
        'journalEntries': journalEntries.map((e) => e.toJson()).toList(),
        'hopePosts': hopePosts.map((e) => e.toJson()).toList(),
        'feedbackItems': feedbackItems.map((e) => e.toJson()).toList(),
      };

  void _restore(Map<String, dynamic> json) {
    onboardingComplete = _bool(json['onboardingComplete'], onboardingComplete);
    cigarettesPerDay = _int(json['cigarettesPerDay'], cigarettesPerDay);
    cigarettesPerPack = _int(json['cigarettesPerPack'], cigarettesPerPack);
    packPriceToman = _int(json['packPriceToman'], packPriceToman);
    quitJourneyStartedAt = _date(json['quitJourneyStartedAt'], quitJourneyStartedAt);
    currentStreakStartedAt = _date(json['currentStreakStartedAt'], currentStreakStartedAt);
    goalTitle = _string(json['goalTitle'], goalTitle);
    goalAmountToman = _int(json['goalAmountToman'], goalAmountToman);
    hasGoal = _bool(json['hasGoal'], hasGoal);
    final schema = _int(json['schema'], 1);
    remindersEnabled = schema >= 3 ? _bool(json['remindersEnabled'], remindersEnabled) : false;
    reminderHour = _int(json['reminderHour'], reminderHour).clamp(0, 23).toInt();
    reminderMinute = _int(json['reminderMinute'], reminderMinute).clamp(0, 59).toInt();
    riskyTimeRemindersEnabled = false;
    communityNotificationsEnabled = _bool(json['communityNotificationsEnabled'], communityNotificationsEnabled);
    selectedMainTab = _int(json['selectedMainTab'], selectedMainTab).clamp(0, 4).toInt();
    displayName = _string(json['displayName'], displayName);
    mobile = _string(json['mobile'], mobile);
    email = _string(json['email'], email);
    communityAlias = _string(json['communityAlias'], communityAlias);
    communityShareProgressDefault = _bool(json['communityShareProgressDefault'], communityShareProgressDefault);
    communityShareSavingsDefault = _bool(json['communityShareSavingsDefault'], communityShareSavingsDefault);
    personalQuitReason = _string(json['personalQuitReason'], personalQuitReason);
    trustedContactName = _string(json['trustedContactName'], trustedContactName);
    trustedContactPhone = _string(json['trustedContactPhone'], trustedContactPhone);

    final providerName = _string(json['accountProvider'], 'guest');
    accountProvider = AccountProvider.values.where((e) => e.name == providerName).firstOrNull ?? AccountProvider.guest;

    _restoreStringList(customTriggers, json['customTriggers']);
    _restoreStringList(customInterventions, json['customInterventions']);
    _restoreObjects(cravings, json['cravings'], CravingLog.fromJson);
    _restoreObjects(slips, json['slips'], SlipLog.fromJson);
    _restoreObjects(journalEntries, json['journalEntries'], JournalEntry.fromJson);
    _restoreObjects(feedbackItems, json['feedbackItems'], UserFeedbackItem.fromJson);

    if (json['hopePosts'] is List) {
      hopePosts.clear();
      for (final item in json['hopePosts'] as List) {
        if (item is Map) hopePosts.add(HopePost.fromJson(Map<String, dynamic>.from(item)));
      }
    }
  }

  void completeSetup({
    required int perDay,
    required int perPack,
    required int packPrice,
    required DateTime quitDate,
    required String goal,
    required int goalAmount,
    String quitReason = '',
  }) {
    cigarettesPerDay = max(1, perDay);
    cigarettesPerPack = max(1, perPack);
    packPriceToman = max(0, packPrice);
    quitJourneyStartedAt = quitDate;
    currentStreakStartedAt = quitDate;
    goalTitle = goal.trim().isEmpty ? 'هدف شخصی من' : goal.trim();
    goalAmountToman = max(1, goalAmount);
    personalQuitReason = quitReason.trim();
    hasGoal = true;
    onboardingComplete = true;
    notifyListeners();
  }

  void setTab(int index) {
    selectedMainTab = index.clamp(0, 4).toInt();
    notifyListeners();
  }

  void addCraving({
    required int intensity,
    required String trigger,
    required String intervention,
    required bool passed,
  }) {
    final normalizedTrigger = trigger.trim().isEmpty ? 'نامشخص' : trigger.trim();
    final normalizedIntervention = intervention.trim().isEmpty ? 'بدون راهکار ثبت‌شده' : intervention.trim();
    cravings.add(CravingLog(
      at: DateTime.now(),
      intensity: intensity,
      trigger: normalizedTrigger,
      intervention: normalizedIntervention,
      passed: passed,
    ));
    _rememberCustom(customTriggers, normalizedTrigger, const {'استرس', 'بعد غذا', 'قهوه', 'جمع دوستان', 'بی‌حوصلگی', 'عادت'});
    _rememberCustom(customInterventions, normalizedIntervention, const {'آب بنوش', 'کمی قدم بزن', 'تنفس آرام', 'تغییر فضا'});
    notifyListeners();
  }

  void _rememberCustom(List<String> target, String value, Set<String> defaults) {
    if (value.isEmpty || defaults.contains(value) || target.contains(value)) return;
    if (target.length >= 6) target.removeAt(0);
    target.add(value);
  }

  void recordSlip({required int count, required String reason}) {
    slips.add(SlipLog(at: DateTime.now(), count: max(1, count), reason: reason));
    currentStreakStartedAt = DateTime.now();
    notifyListeners();
  }

  void addJournalEntry({required String mood, required String note}) {
    journalEntries.add(JournalEntry(at: DateTime.now(), mood: mood, note: note.trim()));
    notifyListeners();
  }

  void updateGoal(String title, int amount) {
    goalTitle = title.trim().isEmpty ? goalTitle : title.trim();
    goalAmountToman = max(1, amount);
    hasGoal = true;
    notifyListeners();
  }

  void updateSmokingProfile({required int perDay, required int perPack, required int packPrice, required String quitReason}) {
    cigarettesPerDay = max(1, perDay);
    cigarettesPerPack = max(1, perPack);
    packPriceToman = max(0, packPrice);
    personalQuitReason = quitReason.trim();
    notifyListeners();
  }

  void updateIdentity({required String name, required String mobileValue, required String emailValue}) {
    displayName = name.trim();
    mobile = mobileValue.trim();
    email = emailValue.trim();
    notifyListeners();
  }

  void updateCommunityProfile({required String alias, required bool shareProgressByDefault, required bool shareSavingsByDefault}) {
    final trimmed = alias.trim();
    if (trimmed.isNotEmpty) communityAlias = trimmed;
    communityShareProgressDefault = shareProgressByDefault;
    communityShareSavingsDefault = shareSavingsByDefault;
    notifyListeners();
  }

  void markPhoneConnected(String mobileValue) {
    mobile = mobileValue.trim();
    accountProvider = AccountProvider.phone;
    notifyListeners();
  }

  void markGoogleConnected(String emailValue) {
    email = emailValue.trim();
    accountProvider = AccountProvider.google;
    notifyListeners();
  }

  void disconnectAccount() {
    accountProvider = AccountProvider.guest;
    notifyListeners();
  }

  void addFeedback({required String category, required String message, String? contact}) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;
    final normalizedContact = contact?.trim();
    feedbackItems.add(UserFeedbackItem(
      at: DateTime.now(),
      category: category,
      message: trimmed,
      contact: normalizedContact == null || normalizedContact.isEmpty ? null : normalizedContact,
    ));
    notifyListeners();
  }

  void removeGoal() {
    hasGoal = false;
    notifyListeners();
  }

  void toggleReminders(bool value) {
    remindersEnabled = value;
    notifyListeners();
  }

  void updateReminderTime({required int hour, required int minute}) {
    reminderHour = hour.clamp(0, 23).toInt();
    reminderMinute = minute.clamp(0, 59).toInt();
    notifyListeners();
  }

  void toggleRiskyTimeReminders(bool value) {
    riskyTimeRemindersEnabled = value;
    notifyListeners();
  }

  void toggleCommunityNotifications(bool value) {
    communityNotificationsEnabled = value;
    notifyListeners();
  }

  void updateTrustedContact({required String name, required String phone}) {
    trustedContactName = name.trim();
    trustedContactPhone = phone.trim();
    notifyListeners();
  }

  void updateCommunityAlias(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) communityAlias = trimmed;
    notifyListeners();
  }

  void addHopePost({required String message, bool shareProgress = true, bool shareSavings = false}) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;
    hopePosts.insert(0, HopePost(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      authorAlias: communityAlias,
      message: trimmed,
      smokeFreeDays: shareProgress ? smokeFreeDays : 0,
      createdAt: DateTime.now(),
      verifiedProgress: shareProgress,
      savedMoneyToman: shareSavings ? moneySaved.round() : null,
      goalTitle: shareSavings && hasGoal ? goalTitle : null,
    ));
    notifyListeners();
  }

  void toggleHopeReaction(String id) {
    final post = hopePosts.where((item) => item.id == id).firstOrNull;
    if (post == null) return;
    post.reactedByMe = !post.reactedByMe;
    post.hopeCount = max(0, post.hopeCount + (post.reactedByMe ? 1 : -1));
    notifyListeners();
  }

  void reportHopePost(String id) {
    final post = hopePosts.where((item) => item.id == id).firstOrNull;
    if (post == null) return;
    post.reported = true;
    notifyListeners();
  }

  JourneyDayStatus journeyStatusFor(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final start = DateTime(quitJourneyStartedAt.year, quitJourneyStartedAt.month, quitJourneyStartedAt.day);
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    if (day.isBefore(start)) return JourneyDayStatus.beforeJourney;
    if (day.isAfter(normalizedToday)) return JourneyDayStatus.future;
    if (slips.any((item) => sameCalendarDay(item.at, day))) return JourneyDayStatus.slip;
    if (cravings.any((item) => sameCalendarDay(item.at, day))) return JourneyDayStatus.craving;
    return JourneyDayStatus.smokeFree;
  }

  int cravingsOn(DateTime date) => cravings.where((item) => sameCalendarDay(item.at, date)).length;
  int slipsOn(DateTime date) => slips.where((item) => sameCalendarDay(item.at, date)).fold(0, (sum, item) => sum + item.count);
  List<JournalEntry> journalOn(DateTime date) => journalEntries.where((item) => sameCalendarDay(item.at, date)).toList(growable: false);

  void resetAllData() {
    onboardingComplete = false;
    cigarettesPerDay = 10;
    cigarettesPerPack = 20;
    packPriceToman = 85000;
    quitJourneyStartedAt = DateTime.now();
    currentStreakStartedAt = DateTime.now();
    goalTitle = 'سفر رویایی';
    goalAmountToman = 10000000;
    hasGoal = true;
    remindersEnabled = false;
    reminderHour = 20;
    reminderMinute = 0;
    riskyTimeRemindersEnabled = false;
    communityNotificationsEnabled = false;
    selectedMainTab = 0;
    displayName = '';
    mobile = '';
    email = '';
    accountProvider = AccountProvider.guest;
    personalQuitReason = '';
    cravings.clear();
    slips.clear();
    journalEntries.clear();
    feedbackItems.clear();
    customTriggers.clear();
    customInterventions.clear();
    trustedContactName = '';
    trustedContactPhone = '';
    communityAlias = 'یک نفس تازه';
    communityShareProgressDefault = true;
    communityShareSavingsDefault = false;
    hopePosts.clear();
    notifyListeners();
  }

  Future<void> clearAllLocalData() async {
    await NafasLocalStore.instance.remove(_storageKey);
    resetAllData();
  }

  @Deprecated('Use resetAllData')
  void resetForDemo() => resetAllData();

  @Deprecated('Use clearAllLocalData')
  Future<void> clearSavedPreview() => clearAllLocalData();

}

void _restoreStringList(List<String> target, dynamic raw) {
  if (raw is! List) return;
  target
    ..clear()
    ..addAll(raw.map((e) => e.toString()).where((e) => e.trim().isNotEmpty));
}

void _restoreObjects<T>(List<T> target, dynamic raw, T Function(Map<String, dynamic>) decoder) {
  if (raw is! List) return;
  target.clear();
  for (final item in raw) {
    if (item is Map) target.add(decoder(Map<String, dynamic>.from(item)));
  }
}

DateTime _date(dynamic value, DateTime fallback) => DateTime.tryParse(value?.toString() ?? '') ?? fallback;
int _int(dynamic value, int fallback) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? fallback;
bool _bool(dynamic value, bool fallback) => value is bool ? value : value?.toString() == 'true' ? true : value?.toString() == 'false' ? false : fallback;
String _string(dynamic value, String fallback) => value == null ? fallback : value.toString();

extension _IterableFirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}

class NafasScope extends InheritedNotifier<NafasAppState> {
  const NafasScope({super.key, required NafasAppState state, required super.child}) : super(notifier: state);

  static NafasAppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<NafasScope>();
    assert(scope != null, 'NafasScope not found');
    return scope!.notifier!;
  }
}
