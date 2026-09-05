import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/app/config/munasakna_environment.dart';

void main() {
  test('current runtime remains standalone and real-data fail-closed', () {
    expect(MunasaknaEnvironment.developmentMode, isTrue);
    expect(MunasaknaEnvironment.isLocalOnly, isTrue);
    expect(MunasaknaEnvironment.hasLogin, isFalse);
    expect(MunasaknaEnvironment.usesExternalDatabase, isFalse);
    expect(MunasaknaEnvironment.sendsPersonalData, isFalse);
    expect(MunasaknaEnvironment.usesExternalAnalytics, isFalse);
    expect(MunasaknaEnvironment.usesRealPilgrimData, isFalse);
    expect(MunasaknaEnvironment.persistsRawActivationToken, isFalse);
    expect(MunasaknaEnvironment.storesHealthNotes, isFalse);
    expect(MunasaknaEnvironment.nusukBackendReady, isFalse);
    expect(MunasaknaEnvironment.appScopeAr, contains('رفيق مستقل'));
    expect(MunasaknaEnvironment.appScopeAr, contains('اختياري'));
    expect(
      MunasaknaEnvironment.appScopeAr,
      isNot(contains('تحت نظام نسك')),
    );
  });

  test('web shell preserves Flutter viewport ownership and truthful identity',
      () {
    final web = File('web/index.html').readAsStringSync();

    expect(web, isNot(contains('name="viewport"')));
    expect(web, contains('name="mobile-web-app-capable"'));
    expect(web, isNot(contains('name="apple-mobile-web-app-capable"')));
    expect(web, isNot(contains('تحت نظام نسك')));
    expect(web, contains('رفيق رقمي مستقل'));
  });

  test('platform manifests preserve current permission and transport boundary',
      () {
    final android =
        File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    final ios = File('ios/Runner/PrivacyInfo.xcprivacy').readAsStringSync();

    expect(android, contains('android.permission.RECORD_AUDIO'));
    expect(android, contains('android.permission.ACCESS_FINE_LOCATION'));
    expect(android, contains('android.permission.ACCESS_COARSE_LOCATION'));
    expect(android, contains('android:usesCleartextTraffic="false"'));

    expect(ios, contains('<key>NSPrivacyTracking</key>'));
    expect(ios, contains('<false/>'));
    expect(ios, contains('<key>NSPrivacyCollectedDataTypes</key>'));
    expect(ios, contains('<array/>'));
  });

  test('security and real-data boundary documents are source controlled', () {
    final threatModel =
        File('docs/SECURITY_PRIVACY_THREAT_MODEL_V1.md').readAsStringSync();
    final realData =
        File('docs/REAL_DATA_SECURITY_BOUNDARY_V1.md').readAsStringSync();

    expect(threatModel, contains('REAL_DATA=NO'));
    expect(threatModel, contains('raw activation token'));
    expect(realData, contains('OFFICIAL_PILGRIM_SEED'));
    expect(realData, contains('CAMPAIGN_OPERATIONAL_PACK'));
    expect(realData, contains('No scraping'));
  });
  test('privacy data map covers current retention deletion and store truth',
      () {
    final dataMap = File('docs/PRIVACY_DATA_MAP_V1.md').readAsStringSync();

    expect(dataMap, contains('PRIVACY_DATA_MAP=COMPLETE'));
    expect(dataMap, contains('manasikuna_1448_launch_snapshot_v1'));
    expect(dataMap, contains('Raw activation token'));
    expect(dataMap, contains('Location / coordinates'));
    expect(dataMap, contains('Microphone audio'));
    expect(dataMap, contains('Speech-recognition transcript'));
    expect(dataMap, contains('Retention / deletion'));
    expect(dataMap, contains('REAL_DATA=NO'));
    expect(dataMap, contains('REAL_NUSUK=NO'));
    expect(dataMap, contains('Store-declaration source of truth'));
  });
}
