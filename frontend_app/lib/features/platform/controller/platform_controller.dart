import '../model/platform.dart';
import '../service/platform_service.dart';

class PlatformController {
  final PlatformService _service = PlatformService();

  Future<List<PlatformTrend>> getPlatformTrends(String platform, [String? countryCode]) async {
    return await _service.getPlatformTrends(platform, countryCode);
  }
}