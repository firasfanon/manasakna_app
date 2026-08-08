import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/beta_readiness_widgets.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';
import '../../../nusuk_data/domain/services/nusuk_bridge_contract.dart';

class BetaReadinessPage extends StatelessWidget {
  const BetaReadinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MunasaknaAppScaffold(
      title: 'جاهزية بيتا',
      headerIcon: Icons.workspace_premium_outlined,
      bottomNavIndex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InfoSectionCard(
            title: 'Beta Readiness Batch 01',
            subtitle: 'تثبيت تجربة المستخدم، توحيد المكونات، ومراجعة الصفحات الداخلية دون تفعيل تسجيل الدخول.',
            icon: Icons.rocket_launch_outlined,
            trailing: const MunasaknaStatusChip(label: 'v2.8.3', icon: Icons.new_releases_outlined),
            children: const [
              Text(
                'هذه الصفحة تجمع بوابات الجاهزية الداخلية قبل الانتقال إلى Beta. التطبيق ما زال يعمل محليًا بلا حسابات، لكن عقود الربط مع نسك أصبحت أوضح وقابلة للتنفيذ لاحقًا.',
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 700;
              final cards = [
                const BetaReadinessMetricCard(
                  title: 'نضج المنتج',
                  value: 'Alpha مستقر',
                  subtitle: 'جاهز لمرحلة Beta داخلية بعد الربط والمراجعات.',
                  icon: Icons.insights_outlined,
                  color: MunasaknaTheme.haramGreen,
                ),
                const BetaReadinessMetricCard(
                  title: 'الاختبارات',
                  value: '5/5 ناجحة',
                  subtitle: 'Baseline v282 كان مستقرًا قبل هذه الدفعة.',
                  icon: Icons.checklist_rtl_outlined,
                  color: MunasaknaTheme.zamzamBlue,
                ),
                const BetaReadinessMetricCard(
                  title: 'الدليل الشامل',
                  value: 'محدّث',
                  subtitle: 'أي تطوير جديد يحدّث مرجع النظام.',
                  icon: Icons.menu_book_outlined,
                  color: MunasaknaTheme.kiswahGold,
                ),
              ];
              if (!isWide) {
                return Column(
                  children: [
                    for (final card in cards) ...[card, const SizedBox(height: 10)],
                  ],
                );
              }
              return Row(
                children: [
                  for (final card in cards) ...[
                    Expanded(child: card),
                    if (card != cards.last) const SizedBox(width: 10),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          BetaReadinessChecklistCard(
            title: 'تثبيت تجربة المستخدم',
            subtitle: 'مراجعة عامة للصفحات الداخلية لتكون واضحة للحاج وكبار السن ومناسبة للويب والموبايل.',
            icon: Icons.volunteer_activism_outlined,
            color: scheme.primary,
            items: const [
              'الإبقاء على نمط البطاقات الكبيرة، النصوص المختصرة، والأزرار الواضحة.',
              'عدم طلب تسجيل الدخول في مرحلة التطوير، مع إبقاء وضع الضيف ظاهرًا.',
              'ربط الصفحات الحساسة بالمساعد واللجنة الشرعية بدل إعطاء فتوى نهائية.',
              'تحسين قابلية الوصول عبر إعدادات الخط، الوضع الداكن، والإرشادات الصحية.',
            ],
          ),
          const SizedBox(height: 12),
          const BetaReadinessChecklistCard(
            title: 'توحيد المكونات',
            subtitle: 'اعتماد مكوّنات مشتركة لأي صفحة داخلية جديدة بدل تكرار التصميم.',
            icon: Icons.dashboard_customize_outlined,
            color: MunasaknaTheme.zamzamBlue,
            status: 'موحّد',
            items: [
              'MunasaknaAppScaffold للصفحات العامة مع Banner موحد ووضع التطوير.',
              'InfoSectionCard للشرح المنظم والبطاقات الرسمية.',
              'MunasaknaStatusChip لحالات الجاهزية، الحساسية، والربط المستقبلي.',
              'BetaReadinessMetricCard وNusukBridgeContractCard لبوابات الجاهزية والربط.',
            ],
          ),
          const SizedBox(height: 12),
          const BetaReadinessChecklistCard(
            title: 'مراجعة الصفحات الداخلية',
            subtitle: 'تقسيم الصفحات حسب الخدمة لا حسب الشاشة فقط، لضمان أن كل صفحة تخدم مرحلة من رحلة الحاج.',
            icon: Icons.fact_check_outlined,
            color: MunasaknaTheme.haramGreen,
            items: [
              'صفحات العبادة: نوع الحج، المواقيت، المناسك، مصفوفة الحج، الأسئلة، اللجنة الشرعية.',
              'صفحات التشغيل: بياناتي، الوثائق، المجموعة، السكن والنقل، الحقيبة، التقويم.',
              'صفحات السلامة: الصحة، الطوارئ، كبار السن والمرضى، موقعي الحالي.',
              'صفحات المتابعة: الشكاوى، الاستبيان، ما بعد الحج، الإشعارات والتنبيهات.',
            ],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'بوابات Batch 02',
            subtitle: 'مداخل تنفيذية لمراجعة الصفحات، اختبار الرحلة، وعقود نسك التفصيلية.',
            icon: Icons.hub_outlined,
            children: [
              _BetaLinkTile(
                title: 'مراجعة الصفحات',
                subtitle: 'تدقيق UX والاعتماد والبيانات المطلوبة لكل صفحة داخلية.',
                icon: Icons.fact_check_outlined,
                route: MunasaknaRoutes.betaReview,
              ),
              const SizedBox(height: 10),
              _BetaLinkTile(
                title: 'سيناريوهات اختبار بيتا',
                subtitle: 'اختبار الحاج حسب المرحلة والمنصة والصوت والموقع دون تسجيل دخول.',
                icon: Icons.science_outlined,
                route: MunasaknaRoutes.betaTestScenarios,
              ),
              const SizedBox(height: 10),
              _BetaLinkTile(
                title: 'عقود الربط مع نسك',
                subtitle: 'تفصيل الحقول وقواعد الحماية قبل أي ربط فعلي بالسيرفر.',
                icon: Icons.cloud_sync_outlined,
                route: MunasaknaRoutes.nusukContracts,
              ),
            ],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'بوابات Batch 03',
            subtitle: 'تشغيل بيتا، سجل الملاحظات، وبوابات الإطلاق الداخلي قبل أي ربط فعلي.',
            icon: Icons.rocket_launch_outlined,
            children: [
              _BetaLinkTile(
                title: 'تشغيل بيتا الداخلي',
                subtitle: 'خطة اختبار منظمة بلا بيانات حقيقية ولا تسجيل دخول.',
                icon: Icons.rocket_launch_outlined,
                route: MunasaknaRoutes.betaPilot,
              ),
              const SizedBox(height: 10),
              _BetaLinkTile(
                title: 'سجل ملاحظات بيتا',
                subtitle: 'تصنيف UX والمحتوى والصوت والموقع وعقود نسك.',
                icon: Icons.feedback_outlined,
                route: MunasaknaRoutes.betaFeedback,
              ),
              const SizedBox(height: 10),
              _BetaLinkTile(
                title: 'بوابات الإطلاق الداخلي',
                subtitle: 'اختبارات، خصوصية، اعتماد شرعي، صوت، ونسك.',
                icon: Icons.rule_folder_outlined,
                route: MunasaknaRoutes.releaseGates,
              ),
            ],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'بوابات Batch 04',
            subtitle: 'إغلاق بيتا، جاهزية المتاجر، اعتماد المحتوى، وسجل مخاطر الجودة.',
            icon: Icons.assignment_turned_in_outlined,
            children: [
              _BetaLinkTile(
                title: 'قائمة إغلاق بيتا',
                subtitle: 'بوابات UX والاختبارات والمحتوى والخصوصية قبل بيتا داخلية.',
                icon: Icons.assignment_turned_in_outlined,
                route: MunasaknaRoutes.betaClosureChecklist,
              ),
              const SizedBox(height: 10),
              _BetaLinkTile(
                title: 'جاهزية المتاجر والويب',
                subtitle: 'تحضير Android وiOS وWeb دون نشر رسمي الآن.',
                icon: Icons.storefront_outlined,
                route: MunasaknaRoutes.storeReadiness,
              ),
              const SizedBox(height: 10),
              _BetaLinkTile(
                title: 'طابور اعتماد المحتوى',
                subtitle: 'وسم المحتوى الشرعي والصحي والإداري قبل النشر.',
                icon: Icons.verified_user_outlined,
                route: MunasaknaRoutes.contentApprovalQueue,
              ),
              const SizedBox(height: 10),
              _BetaLinkTile(
                title: 'سجل مخاطر الجودة',
                subtitle: 'مخاطر الفتوى، الخصوصية، الصوت، وتجربة المستخدم.',
                icon: Icons.health_and_safety_outlined,
                route: MunasaknaRoutes.qualityRiskRegister,
              ),
            ],
          ),

          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'بوابات Batch 05–11',
            subtitle: 'دفعة بيتا كبيرة لإغلاق التوحيد، أمان المساعد، FAQ، نسك Mock، التذكيرات، المنصات، والدخان النهائي.',
            icon: Icons.auto_awesome_motion_outlined,
            children: [
              _BetaLinkTile(
                title: 'توحيد الواجهة',
                subtitle: 'مسح بصري للصفحات الداخلية وتثبيت المكونات.',
                icon: Icons.dashboard_customize_outlined,
                route: MunasaknaRoutes.uiConsistencySweep,
              ),
              const SizedBox(height: 10),
              _BetaLinkTile(
                title: 'أمان المساعد والصوت',
                subtitle: 'حواجز لا فتوى ولا هلوسة وسلوك fallback للصوت.',
                icon: Icons.record_voice_over_outlined,
                route: MunasaknaRoutes.assistantSafetyHardening,
              ),
              const SizedBox(height: 10),
              _BetaLinkTile(
                title: 'توسيع الأسئلة',
                subtitle: 'FAQ حسب الزمان والمكان والجنس ونوع الحج.',
                icon: Icons.quiz_outlined,
                route: MunasaknaRoutes.faqExpansionApproval,
              ),
              const SizedBox(height: 10),
              _BetaLinkTile(
                title: 'نسك التجريبي',
                subtitle: 'عقود Mock دون تسجيل دخول أو اتصال فعلي.',
                icon: Icons.cloud_sync_outlined,
                route: MunasaknaRoutes.nusukBridgeMock,
              ),
              const SizedBox(height: 10),
              _BetaLinkTile(
                title: 'تذكيرات المراحل',
                subtitle: 'خطة تنبيهات محلية حسب المرحلة والميقات.',
                icon: Icons.notifications_active_outlined,
                route: MunasaknaRoutes.stageReminders,
              ),
              const SizedBox(height: 10),
              _BetaLinkTile(
                title: 'جاهزية المنصات',
                subtitle: 'Web/PWA وAndroid وiOS قبل بيتا.',
                icon: Icons.devices_outlined,
                route: MunasaknaRoutes.platformReadiness,
              ),
              const SizedBox(height: 10),
              _BetaLinkTile(
                title: 'دخان بيتا النهائي',
                subtitle: 'Smoke gates وSession Handoff للإغلاق.',
                icon: Icons.check_circle_outline,
                route: MunasaknaRoutes.finalBetaSmoke,
              ),
            ],
          ),

          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'عقود الربط المستقبلية مع نسك',
            subtitle: 'لا تفعيل للمصادقة الآن؛ هذه عقود جاهزية فقط لتقليل إعادة البناء عند ربط السيرفر.',
            icon: Icons.cloud_sync_outlined,
            children: [
              for (final contract in NusukBridgeContractPlan.contracts) ...[
                NusukBridgeContractCard(
                  title: contract.titleAr,
                  description: '${contract.descriptionAr}\nالمسار المقترح: ${contract.endpointHint}',
                  fields: contract.requiredFieldsAr,
                  status: contract.modeLabelAr,
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'بوابات الانتقال إلى Beta داخلية',
            subtitle: 'هذه البوابات تمنع الانتقال للنشر قبل ثبات الاختبارات والمحتوى والربط.',
            icon: Icons.rule_folder_outlined,
            children: [
              for (final gate in NusukBridgeContractPlan.gates)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        gate.isComplete ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                        color: gate.isComplete ? scheme.primary : MunasaknaTheme.kiswahGold,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(gate.titleAr, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                            const SizedBox(height: 2),
                            Text(gate.descriptionAr, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.45)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),
          InfoSectionCard(
            title: 'بوابات Beta Content & UX Audit',
            subtitle: 'تدقيق المحتوى والواجهات، وتقرير تكامل رسمي يوجه نسك قبل أي ربط أو APK تجريبي.',
            icon: Icons.rate_review_outlined,
            children: [
              _BetaLinkTile(
                title: 'تدقيق المحتوى والواجهة',
                subtitle: 'مراجعة صفحة بصفحة حسب الطبقة والمخاطر واحتياج نسك.',
                icon: Icons.fact_check_outlined,
                route: MunasaknaRoutes.betaContentUxAudit,
              ),
              const SizedBox(height: 10),
              _BetaLinkTile(
                title: 'تقرير نسك للتكامل',
                subtitle: 'ما يحتاجه مناسكنا من نسك، وما يحتاجه نسك من التطبيق.',
                icon: Icons.integration_instructions_outlined,
                route: MunasaknaRoutes.nusukIntegrationHandoff,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _BetaLinkTile extends StatelessWidget {
  const _BetaLinkTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: scheme.primary.withValues(alpha: 0.06),
          border: Border.all(color: scheme.primary.withValues(alpha: 0.16)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: scheme.primary.withValues(alpha: 0.12),
              ),
              child: Icon(icon, color: scheme.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.45)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: scheme.primary),
          ],
        ),
      ),
    );
  }
}
