import 'dart:math';
import 'package:flutter/material.dart';
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
}

class SlipLog {
  const SlipLog({required this.at, required this.count, required this.reason});
  final DateTime at;
  final int count;
  final String reason;
}

class JournalEntry {
  const JournalEntry({required this.at, required this.mood, required this.note});
  final DateTime at;
  final String mood;
  final String note;
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
}

enum JourneyDayStatus { beforeJourney, future, smokeFree, craving, slip }

enum AccountProvider { guest, phone, google }

class NafasAppState extends ChangeNotifier {
  NafasAppState() {
    _seedHopeWall();
  }

  bool onboardingComplete = false;
  int cigarettesPerDay = 10;
  int cigarettesPerPack = 20;
  int packPriceToman = 85000;
  DateTime quitJourneyStartedAt = DateTime.now();
  DateTime currentStreakStartedAt = DateTime.now();
  String goalTitle = 'سفر رویایی';
  int goalAmountToman = 10000000;
  bool hasGoal = true;
  bool remindersEnabled = true;
  bool riskyTimeRemindersEnabled = true;
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
    _rememberCustom(customTriggers, normalizedTrigger, const {
      'استرس', 'بعد غذا', 'قهوه', 'جمع دوستان', 'بی‌حوصلگی', 'عادت',
    });
    _rememberCustom(customInterventions, normalizedIntervention, const {
      'آب بنوش', 'کمی قدم بزن', 'تنفس آرام', 'تغییر فضا',
    });
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

  void updateSmokingProfile({
    required int perDay,
    required int perPack,
    required int packPrice,
    required String quitReason,
  }) {
    cigarettesPerDay = max(1, perDay);
    cigarettesPerPack = max(1, perPack);
    packPriceToman = max(0, packPrice);
    personalQuitReason = quitReason.trim();
    notifyListeners();
  }

  void updateIdentity({
    required String name,
    required String mobileValue,
    required String emailValue,
  }) {
    displayName = name.trim();
    mobile = mobileValue.trim();
    email = emailValue.trim();
    notifyListeners();
  }

  void updateCommunityProfile({
    required String alias,
    required bool shareProgressByDefault,
    required bool shareSavingsByDefault,
  }) {
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

  void resetForDemo() {
    onboardingComplete = false;
    cigarettesPerDay = 10;
    cigarettesPerPack = 20;
    packPriceToman = 85000;
    quitJourneyStartedAt = DateTime.now();
    currentStreakStartedAt = DateTime.now();
    goalTitle = 'سفر رویایی';
    goalAmountToman = 10000000;
    hasGoal = true;
    remindersEnabled = true;
    riskyTimeRemindersEnabled = true;
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
    _seedHopeWall();
    notifyListeners();
  }

  void _seedHopeWall() {
    final now = DateTime.now();
    hopePosts.addAll([
      HopePost(id: 'seed-1', authorAlias: 'مسافر ۴۳', message: 'هفته اول برای من سخت‌ترین بخش بود. چیزی که کمک کرد این بود که فقط به امروز فکر کنم، نه به «برای همیشه».', smokeFreeDays: 43, createdAt: now.subtract(const Duration(minutes: 24)), verifiedProgress: true, hopeCount: 128),
      HopePost(id: 'seed-2', authorAlias: 'نفس آرام', message: 'پولی که قبلاً خرج سیگار می‌کردم رو کنار گذاشتم و بالاخره برای خودم یک هدفون خریدم. دیدن نتیجه واقعی خیلی انگیزه داد.', smokeFreeDays: 81, createdAt: now.subtract(const Duration(hours: 3)), verifiedProgress: true, savedMoneyToman: 6400000, goalTitle: 'هدفون', hopeCount: 214),
      HopePost(id: 'seed-3', authorAlias: 'روز هفتم', message: 'امروز فقط روز هفتممه؛ اومدم بگم اگه روز اولی هستی، اون چند دقیقه هوس می‌گذره. واقعاً می‌گذره.', smokeFreeDays: 7, createdAt: now.subtract(const Duration(hours: 7)), verifiedProgress: true, hopeCount: 96),
    ]);
  }
}

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
