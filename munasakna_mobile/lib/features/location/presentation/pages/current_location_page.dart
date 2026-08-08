import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class CurrentLocationPage extends StatefulWidget {
  const CurrentLocationPage({super.key});

  @override
  State<CurrentLocationPage> createState() => _CurrentLocationPageState();
}

class _CurrentLocationPageState extends State<CurrentLocationPage> {
  Position? _position;
  String? _message;
  bool _loading = false;

  Future<void> _locate() async {
    setState(() {
      _loading = true;
      _message = null;
    });
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _message = 'خدمة الموقع غير مفعّلة على الجهاز.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() => _message = 'لم يتم منح إذن الموقع. يمكنك تفعيله من إعدادات الجهاز.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      setState(() => _position = position);
    } catch (error) {
      setState(() => _message = 'تعذر تحديد الموقع: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'موقعي الحالي',
      headerIcon: Icons.my_location_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'تحديد الموقع عند الطلب',
            subtitle: 'لا يعمل الموقع في الخلفية ولا يُرسل خارج الجهاز في هذه النسخة.',
            icon: Icons.my_location_outlined,
            trailing: const MunasaknaStatusChip(label: 'بإذن منك', icon: Icons.lock_outline),
            children: [
              const Text('استخدم هذه الخدمة لمعرفة إحداثياتك الحالية عند الحاجة للتواصل مع المشرف أو الطوارئ.'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _loading ? null : _locate,
                icon: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.location_searching_outlined),
                label: Text(_loading ? 'جاري التحديد...' : 'تحديد موقعي'),
              ),
              if (_message != null) ...[
                const SizedBox(height: 12),
                Text(_message!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              if (_position != null) ...[
                const SizedBox(height: 16),
                _LocationResult(position: _position!),
              ],
            ],
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'طريقة المشاركة الآمنة',
            icon: Icons.privacy_tip_outlined,
            children: [
              Text('شارك الإحداثيات فقط مع المشرف أو جهة موثوقة. لا ترسل موقعك في مجموعات عامة أو لأشخاص غير معروفين.'),
            ],
          ),
          const SizedBox(height: 12),
          const InfoSectionCard(
            title: 'عند الضياع',
            icon: Icons.signpost_outlined,
            children: [
              Text('ابق في مكان آمن، حدّد موقعك، تواصل مع المشرف، ثم انتظر التوجيه. لا تتحرك عكس اتجاه الحشود.'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LocationResult extends StatelessWidget {
  const _LocationResult({required this.position});
  final Position position;

  @override
  Widget build(BuildContext context) {
    final latitude = position.latitude.toStringAsFixed(6);
    final longitude = position.longitude.toStringAsFixed(6);
    final accuracy = position.accuracy.toStringAsFixed(0);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectableText('خط العرض: $latitude\nخط الطول: $longitude\nالدقة التقريبية: $accuracy متر', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('يمكنك نسخ الإحداثيات ومشاركتها يدويًا عند الحاجة.', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
