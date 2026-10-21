import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PushDeviceInfo {
  final String? deviceId;
  final String appVersion;
  final String platform;

  const PushDeviceInfo({this.deviceId, required this.appVersion, required this.platform});
}

Future<PushDeviceInfo> getPushDeviceInfo() async {
  final pkg = await PackageInfo.fromPlatform();
  final version = '${pkg.version}+${pkg.buildNumber}';

  if (Platform.isAndroid) {
    return PushDeviceInfo(
      deviceId: await const AndroidId().getId(),
      appVersion: version,
      platform: 'android',
    );
  }
  if (Platform.isIOS) {
    final ios = await DeviceInfoPlugin().iosInfo;
    return PushDeviceInfo(
      deviceId: ios.identifierForVendor,
      appVersion: version,
      platform: 'ios',
    );
  }
  return PushDeviceInfo(appVersion: version, platform: Platform.operatingSystem);
}
