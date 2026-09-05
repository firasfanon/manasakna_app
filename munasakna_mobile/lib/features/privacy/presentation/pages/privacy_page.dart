import 'package:flutter/material.dart';

import '../../../../app/config/munasakna_environment.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MunasaknaAppScaffold(
      title: 'الخصوصية',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'وضع التطبيق الحالي',
            subtitle:
                'مناسكنا يعمل حاليًا كرفيق مستقل محليًا على الجهاز ضمن مرحلة التطوير بلا تسجيل دخول.',
            icon: Icons.privacy_tip_outlined,
            trailing: MunasaknaStatusChip(
              label: 'Standalone / Local',
              icon: Icons.verified_user_outlined,
            ),
            children: [
              Text(
                'لا يحتوي هذا الإصدار على تسجيل دخول أو حسابات مستخدمين أو قاعدة بيانات حجاج خارجية.',
              ),
              SizedBox(height: 8),
              Text(
                'لا يرسل مناسكنا بيانات حجاج حقيقية أو بيانات شخصية إلى خادم تابع له في هذه النسخة، ولا يستخدم تحليلات أو إعلانات خارجية.',
              ),
              SizedBox(height: 8),
              Text(
                'نسك مزود اختياري مستقبلي فقط عند وجود تكامل رسمي مصرح به؛ التطبيق الحالي لا يتصل بنسك.',
              ),
            ],
          ),
          SizedBox(height: 12),
          InfoSectionCard(
            title: 'البيانات المحلية',
            icon: Icons.phonelink_lock_outlined,
            children: [
              Text(
                'قد تُحفظ تفضيلات غير حساسة محليًا، كما تُحفظ لقطة الرحلة 1448 التجريبية Synthetic على الجهاز لدعم الاستعادة Offline-first.',
              ),
              SizedBox(height: 8),
              Text(
                'لا يُحفظ رمز التفعيل الخام ضمن لقطة الرحلة، ولا تحفظ هذه النسخة ملاحظات صحية شخصية.',
              ),
              SizedBox(height: 8),
              Text(
                'أي انتقال لاحق إلى بيانات حجاج حقيقية يحتاج تصميم تخزين آمن وسياسة احتفاظ وموافقة وصلاحيات مستقلة قبل التفعيل.',
              ),
            ],
          ),
          SizedBox(height: 12),
          InfoSectionCard(
            title: 'الأذونات وخدمات النظام',
            icon: Icons.admin_panel_settings_outlined,
            children: [
              Text(
                'الموقع: يُطلب فقط عند استخدام خدمة موقعي الحالي، ويُعرض محليًا ما لم يشارك المستخدم المعلومة بنفسه.',
              ),
              SizedBox(height: 8),
              Text(
                'الميكروفون: يُطلب فقط عند استخدام الإدخال الصوتي. التعرف على الكلام قد تنفذه خدمة النظام أو المتصفح وقد يخضع لمعالجة مزود المنصة وفق إعداداته وسياساته؛ مناسكنا لا يشغّل خادمًا خاصًا لاستقبال التسجيل الصوتي في هذه النسخة.',
              ),
              SizedBox(height: 8),
              Text(
                'قراءة النص صوتيًا تستخدم خدمة الصوت المتاحة في النظام أو المتصفح، ولا تضيف مناسكنا خدمة تتبع أو تحليلات لهذا الغرض.',
              ),
            ],
          ),
          SizedBox(height: 12),
          InfoSectionCard(
            title: 'حد البيانات الحقيقية',
            icon: Icons.shield_outlined,
            children: [
              Text(
                'REAL_DATA=NO في هذا الإصدار. أي OFFICIAL PILGRIM SEED أو Campaign Pack حقيقي يحتاج تفويضًا منفصلًا، تقليل بيانات، مصدرًا موثقًا، وضوابط وصول واحتفاظ ومراجعة خصوصية وأمان قبل الربط.',
              ),
            ],
          ),
          SizedBox(height: 12),
          InfoSectionCard(
            title: 'بيانات النشر',
            icon: Icons.app_settings_alt_outlined,
            children: [
              SelectableText(
                'Bundle / Package: ${MunasaknaEnvironment.packageId}',
              ),
              SizedBox(height: 8),
              Text(
                'إجابات المتاجر يجب أن تُراجع مقابل السلوك الفعلي لكل منصة، خصوصًا خدمة التعرف على الكلام التابعة للنظام أو المتصفح، ولا يجوز نسخ تصنيف سابق دون إعادة تحقق.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
