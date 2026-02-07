import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:iman_mate_mobile_app/features/prayer/repositories/prayer_repository.dart';
import 'package:iman_mate_mobile_app/features/prayer/services/prayer_local_service.dart';
import 'package:iman_mate_mobile_app/features/prayer/services/location_service.dart';
import 'package:iman_mate_mobile_app/features/prayer/services/prayer_api_service.dart';
import 'package:iman_mate_mobile_app/features/prayer/models/prayer_models.dart';
import 'package:iman_mate_mobile_app/features/prayer/models/performance_models.dart';

// Generate Mocks
@GenerateMocks([PrayerLocalService, LocationLocalService, PrayerApiService])
import 'prayer_repository_test.mocks.dart';

void main() {
  late PrayerRepository repository;
  late MockPrayerLocalService mockLocalService;
  late MockLocationLocalService mockLocationService;
  late MockPrayerApiService mockApiService;

  setUp(() {
    mockLocalService = MockPrayerLocalService();
    mockLocationService = MockLocationLocalService();
    mockApiService = MockPrayerApiService();
    repository = PrayerRepository(mockLocalService, mockLocationService, mockApiService);
  });

  group('PrayerRepository Tests', () {
    test('transformAndSavePrayers should parse and save data correctly', () async {
      final date = DateTime(2026, 2, 1);
      final dateStr = "2026-02-01";
      final apiData = {
        dateStr: PrayerTimesModel(
          fajr: "05:00", sunrise: "06:30", dhuhr: "12:00",
          asr: "15:00", maghrib: "18:00", isha: "19:30"
        )
      };

      when(mockLocalService.getPrayerDay(any)).thenReturn(null);
      
      await repository.transformAndSavePrayers(2, 2026, apiData);

      verify(mockLocalService.savePrayerDay(any)).called(1);
    });

    test('markPrayer should update status and calculate score', () async {
      final date = DateTime(2026, 2, 1);
      final prayerDay = PrayerDayModel(
        date: date,
        timings: PrayerTimesModel(fajr: "05:00", sunrise: "06:30", dhuhr: "12:00", asr: "15:00", maghrib: "18:00", isha: "19:30"),
        statuses: {'Fajr': PrayerStatus.none},
        dailyScore: 0,
      );

      when(mockLocalService.getPrayerDay(date)).thenReturn(prayerDay);
      when(mockLocalService.getConfig()).thenReturn(PrayerScoreConfigModel(onTimePoints: 10));
      when(mockLocalService.getDaysForMonth(2, 2026)).thenReturn([prayerDay]); 

      await repository.markPrayer(date, 'Fajr', PrayerStatus.onTime);

      verify(mockLocalService.savePrayerDay(argThat(
        predicate<PrayerDayModel>((day) => day.dailyScore == 10.0 && day.statuses['Fajr'] == PrayerStatus.onTime)
      ))).called(1);
    });
  });
}
