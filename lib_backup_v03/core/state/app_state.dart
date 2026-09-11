import 'dart:math';
import 'package:flutter/material.dart';

class CravingLog {
  const CravingLog({required this.at, required this.intensity, required this.trigger, required this.passed});
  final DateTime at;
  final int intensity;
  final String trigger;
  final bool passed;
}

class SlipLog {
  const SlipLog({required this.at, required this.count, required this.reason});
  final DateTime at;
  final int count;
  final String reason;
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
  int selectedMainTab = 0;
  String communityAlias = 'یک نفس تازه';
  final List<CravingLog> cravings = [];
  final List<SlipLog> slips = [];
  final List<HopePost> hopePosts = [];

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

  void completeSetup({
    required int perDay,
    required int perPack,
    required int packPrice,
    required DateTime quitDate,
    required String goal,
    required int goalAmount,
  }) {
    cigarettesPerDay = max(1, perDay);
    cigarettesPerPack = max(1, perPack);
    packPriceToman = max(0, packPrice);
    quitJourneyStartedAt = quitDate;
    currentStreakStartedAt = quitDate;
    goalTitle = goal.trim().isEmpty ? 'هدف شخصی من' : goal.trim();
    goalAmountToman = max(1, goalAmount);
    hasGoal = true;
    onboardingComplete = true;
    notifyListeners();
  }

  void setTab(int index) {
    selectedMainTab = index.clamp(0, 4).toInt();
    notifyListeners();
  }

  void addCraving({required int intensity, required String trigger, required bool passed}) {
    cravings.add(CravingLog(at: DateTime.now(), intensity: intensity, trigger: trigger, passed: passed));
    notifyListeners();
  }

  void recordSlip({required int count, required String reason}) {
    slips.add(SlipLog(at: DateTime.now(), count: max(1, count), reason: reason));
    currentStreakStartedAt = DateTime.now();
    notifyListeners();
  }

  void updateGoal(String title, int amount) {
    goalTitle = title.trim().isEmpty ? goalTitle : title.trim();
    goalAmountToman = max(1, amount);
    hasGoal = true;
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

  void updateCommunityAlias(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) communityAlias = trimmed;
    notifyListeners();
  }

  void addHopePost({required String message, bool shareProgress = true, bool shareSavings = false}) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;
    hopePosts.insert(
      0,
      HopePost(
        id: 'local-${DateTime.now().microsecondsSinceEpoch}',
        authorAlias: communityAlias,
        message: trimmed,
        smokeFreeDays: shareProgress ? smokeFreeDays : 0,
        createdAt: DateTime.now(),
        verifiedProgress: shareProgress,
        savedMoneyToman: shareSavings ? moneySaved.round() : null,
        goalTitle: shareSavings && hasGoal ? goalTitle : null,
        hopeCount: 0,
      ),
    );
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
    selectedMainTab = 0;
    cravings.clear();
    slips.clear();
    communityAlias = 'یک نفس تازه';
    hopePosts.clear();
    _seedHopeWall();
    notifyListeners();
  }

  void _seedHopeWall() {
    final now = DateTime.now();
    hopePosts.addAll([
      HopePost(
        id: 'seed-1',
        authorAlias: 'مسافر ۴۳',
        message: 'هفته اول برای من سخت‌ترین بخش بود. چیزی که کمک کرد این بود که فقط به امروز فکر کنم، نه به «برای همیشه».',
        smokeFreeDays: 43,
        createdAt: now.subtract(const Duration(minutes: 24)),
        verifiedProgress: true,
        hopeCount: 128,
      ),
      HopePost(
        id: 'seed-2',
        authorAlias: 'نفس آرام',
        message: 'پولی که قبلاً خرج سیگار می‌کردم رو کنار گذاشتم و بالاخره برای خودم یک هدفون خریدم. دیدن نتیجه واقعی خیلی انگیزه داد.',
        smokeFreeDays: 81,
        createdAt: now.subtract(const Duration(hours: 3)),
        verifiedProgress: true,
        savedMoneyToman: 6400000,
        goalTitle: 'هدفون',
        hopeCount: 214,
      ),
      HopePost(
        id: 'seed-3',
        authorAlias: 'روز هفتم',
        message: 'امروز فقط روز هفتممه؛ اومدم بگم اگه روز اولی هستی، اون چند دقیقه هوس می‌گذره. واقعاً می‌گذره.',
        smokeFreeDays: 7,
        createdAt: now.subtract(const Duration(hours: 7)),
        verifiedProgress: true,
        hopeCount: 96,
      ),
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
