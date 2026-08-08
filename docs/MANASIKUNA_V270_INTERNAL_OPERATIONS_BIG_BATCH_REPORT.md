# Manasikuna v2.7.0 — Internal Operations Big Batch

## الهدف
توسيع الصفحات الداخلية لتطبيق مناسكنا فوق baseline v260، مع دمج صفحات تشغيلية إضافية مرتبطة برحلة الحاج قبل السفر، أثناء الحج، وبعد العودة، مع الحفاظ على وضع التطوير بلا تسجيل دخول وبلا ربط سيرفر.

## ما تم تطويره

### 1. تقويم الحج
- صفحة جديدة: `HajjSchedulePage`.
- تعرض المراحل الزمنية: قبل السفر، الميقات، منى/عرفة/مزدلفة، يوم النحر والتشريق، الوداع والعودة.
- تربط كل مرحلة بإجراء داخل التطبيق مثل محفظة الوثائق، المواقيت، رفيق اليوم، الدليل المكاني، وما بعد الحج.

### 2. محفظة الوثائق
- صفحة جديدة: `DocumentsWalletPage`.
- تعرض حالة الوثائق محليًا: الجواز، التطعيم، التصريح، بيانات الطوارئ، السكن، النقل.
- مؤشر جاهزية بصري.
- لا ترفع أي وثيقة في وضع التطوير.

### 3. مجموعتي والمشرف
- صفحة جديدة: `GroupSupervisorPage`.
- تمهد لعرض الشركة، المجموعة، المشرف، المرشد، الدعم الميداني، ونقاط التجمع.
- تربط بالأزرار السريعة: موقعي الحالي، الهواتف الضرورية، الطوارئ.

### 4. السكن والنقل
- صفحة جديدة: `AccommodationTransportPage`.
- تعرض الفندق، مخيم منى، الحافلات والتفويج، والانتقال إلى عرفة ومزدلفة.
- تتعامل مع المشاكل عبر موقعي الحالي، المجموعة، والشكاوى.

### 5. دعم كبار السن والمرضى
- صفحة جديدة: `AccessibilitySupportPage`.
- إرشادات سلامة لكبير السن، المريض، ذوي الحركة المحدودة، والخوف من الزحام/الضياع.
- أزرار وصول سريع للطوارئ والموقع والاتصال.

### 6. ما بعد الحج
- صفحة جديدة: `PostHajjPage`.
- تشمل الاستبيان، إغلاق الشكاوى، المتابعة الصحية، وسجل الرحلة.

## ملفات مضافة
- `lib/features/schedule/presentation/pages/hajj_schedule_page.dart`
- `lib/features/documents/presentation/pages/documents_wallet_page.dart`
- `lib/features/group/presentation/pages/group_supervisor_page.dart`
- `lib/features/accommodation_transport/presentation/pages/accommodation_transport_page.dart`
- `lib/features/accessibility/presentation/pages/accessibility_support_page.dart`
- `lib/features/post_hajj/presentation/pages/post_hajj_page.dart`

## ملفات معدلة
- `lib/app/router/munasakna_routes.dart`
- `lib/app/router/munasakna_router.dart`
- `lib/core/enums/munasakna_service_key.dart`
- `lib/features/home/domain/models/munasakna_service.dart`
- `lib/features/home/presentation/pages/munasakna_home_page.dart`
- `lib/features/services/presentation/pages/services_page.dart`
- `pubspec.yaml`

## خارج النطاق
- لا تسجيل دخول.
- لا ربط مباشر بقاعدة بيانات أو Supabase.
- لا رفع ملفات أو مشاركة موقع فعلية دون إذن.
- لا فتوى شرعية جديدة.

## نقطة الاستئناف
الدفعة التالية المقترحة: تطوير منظومة “سجل الرحلة المحلي” وواجهة ربط مستقبلية مع نسك تشمل نماذج DTO محلية أولية لبرنامج الحاج، المجموعة، التفويج، والوثائق.
