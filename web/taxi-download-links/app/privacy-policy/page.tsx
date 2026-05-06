import { Metadata } from "next";
// import Image from "next/image";
import Link from "next/link";
import { Navbar } from "../../components/Navbar";
import { FadeInView } from "../../components/animations";
import { Shield, Lock, Eye, Server, Bell, UserCheck, Clock, Mail } from "lucide-react";

export const metadata: Metadata = {
  title: "سياسة الخصوصية | Privacy Policy",
  description:
    "سياسة الخصوصية لتطبيق وار تكسي (Waar Taxi). نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية. تعرف على كيفية جمع واستخدام وحماية بياناتك.",
  alternates: {
    canonical: "https://taxiwaar.com/privacy-policy",
  },
  openGraph: {
    title: "سياسة الخصوصية | وار تكسي - Waar Taxi",
    description:
      "سياسة الخصوصية لتطبيق وار تكسي. نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية.",
  },
};

const sectionsAr = [
  {
    title: "المعلومات التي نجمعها",
    content:
      "نقوم بجمع المعلومات التالية لتقديم خدمة النقل بشكل أمثل: الاسم الكامل للمستخدم، رقم الهاتف المستخدم للتسجيل والدخول، البريد الإلكتروني في حال توفيره، معلومات الحساب والتسجيل، الموقع الجغرافي عبر تقنية GPS لتحديد نقاط الركوب والوصول بدقة، بالإضافة إلى تفاصيل الرحلات السابقة وسجل الاستخدام الكامل.",
    icon: <Eye size={22} className="text-brand" />,
  },
  {
    title: "كيفية استخدام المعلومات",
    content:
      "نستخدم بياناتك الشخصية لتقديم خدمة النقل بأعلى جودة ممكنة. يشمل ذلك ربطك بالسائقين الأقرب لموقعك، تحسين تجربة التطبيق بناءً على أنماط الاستخدام، حساب الأسعار التقريبية للرحلات بدقة، إرسال الإشعارات المهمة المتعلقة برحلاتك، وتقديم الدعم الفني اللازم عند الحاجة.",
    icon: <Server size={22} className="text-brand" />,
  },
  {
    title: "مشاركة المعلومات",
    content:
      "قد نشارك بعض البيانات المحدودة مع الأطراف التالية: السائقين المعتمدين لتنسيق الرحلات، مزودي خدمات الدفع الإلكتروني لإتمام المعاملات المالية، والجهات القانونية عند الضرورة وبموجب القوانين المعمول بها. نؤكد أننا لا نبيع بيانات المستخدمين لأي جهة كانت تحت أي ظرف.",
    icon: <Lock size={22} className="text-brand" />,
  },
  {
    title: "صلاحيات التطبيق",
    content:
      "قد يطلب تطبيق وار تكسي الوصول إلى بعض الصلاحيات الأساسية لتوفير الخدمة بشكل سليم، وتشمل: تحديد الموقع الجغرافي لتعيين نقاط الركوب والنزول، الاتصال بالإنترنت لعرض الخرائط وتحديد المواقع في الوقت الفعلي، والإشعارات لإبقائك على اطلاع بحالة رحلتك.",
    icon: <Bell size={22} className="text-brand" />,
  },
  {
    title: "حماية البيانات",
    content:
      "نتخذ إجراءات أمنية متقدمة لحماية بياناتك الشخصية من الوصول غير المصرح به. نستخدم تقنيات التشفير المتقدمة لنقل البيانات وتخزينها، ونعمل على خوادم آمنة ومعتمدة، مع مراقبة مستمرة للأنظمة لاكتشاف أي تهديدات أمنية محتملة والتعامل معها فوراً.",
    icon: <Shield size={22} className="text-brand" />,
  },
  {
    title: "الاحتفاظ بالبيانات",
    content:
      "نحتفظ ببياناتك الشخصية طالما كان حسابك نشطاً ونحتاجها لتقديم الخدمة. في حال حذف حسابك، يتم حذف البيانات الشخصية خلال فترة زمنية معقولة، مع الاحتفاظ ببعض المعلومات المجهولة لأغراض إحصائية وتحسين الخدمة، وذلك وفقاً للمتطلبات القانونية المعمول بها.",
    icon: <Clock size={22} className="text-brand" />,
  },
  {
    title: "حقوقك",
    content:
      "لديك الحق الكامل في الوصول إلى بياناتك الشخصية المخزنة لدينا في أي وقت. يمكنك طلب تعديل أي معلومات غير دقيقة، أو حذف بياناتك بالكامل، أو تصدير نسخة من بياناتك. لممارسة أي من هذه الحقوق، يمكنك التواصل معنا عبر البريد الإلكتروني الرسمي.",
    icon: <UserCheck size={22} className="text-brand" />,
  },
  {
    title: "خصوصية الأطفال",
    content:
      "تطبيق وار تكسي غير موجه للاستخدام من قبل الأطفال الذين تقل أعمارهم عن 13 عاماً. لا نقوم عمداً بجمع بيانات شخصية من أي شخص يقل عمره عن 13 سنة. في حال اكتشافنا أننا قد جمعنا بيانات لطفل دون هذا العمر، سنقوم بحذفها فوراً.",
    icon: <UserCheck size={22} className="text-brand" />,
  },
  {
    title: "التعديلات على السياسة",
    content:
      "نحتفظ بحق تحديث سياسة الخصوصية هذه في أي وقت عند الحاجة. في حال إجراء تغييرات جوهرية، سنقوم بإعلامك عبر إشعار داخل التطبيق أو عبر البريد الإلكتروني المسجل في حسابك. ننصحك بمراجعة هذه السياسة بشكل دوري للاطلاع على أي تحديثات.",
    icon: <Server size={22} className="text-brand" />,
  },
  {
    title: "التواصل معنا",
    content:
      "إذا كان لديك أي أسئلة أو استفسارات حول سياسة الخصوصية أو كيفية تعاملنا مع بياناتك، يسعدنا تواصلك معنا عبر البريد الإلكتروني الرسمي: info@taxiwaar.com. فريقنا سيرد عليك في أقرب وقت ممكن.",
    icon: <Mail size={22} className="text-brand" />,
  },
];

const sectionsEn = [
  {
    title: "Information We Collect",
    content:
      "We collect the following information to provide an optimal transportation service: your full name for registration, phone number for sign-in and verification, email address if provided, account and registration details, geographic location via GPS technology to determine pickup and drop-off points accurately, along with trip details and complete usage history.",
    icon: <Eye size={22} className="text-brand" />,
  },
  {
    title: "How We Use Information",
    content:
      "We use your personal data to deliver the highest quality transportation service. This includes matching you with the nearest drivers, improving the app experience based on usage patterns, calculating approximate trip prices accurately, sending important trip-related notifications, and providing necessary technical support when needed.",
    icon: <Server size={22} className="text-brand" />,
  },
  {
    title: "Sharing of Information",
    content:
      "We may share limited data with the following parties: verified drivers for trip coordination, electronic payment service providers for processing financial transactions, and legal authorities when necessary and in accordance with applicable laws. We confirm that we do not sell user data to any party under any circumstances.",
    icon: <Lock size={22} className="text-brand" />,
  },
  {
    title: "App Permissions",
    content:
      "Waar Taxi may request access to certain essential permissions to provide the service properly, including: geographic location to set pickup and drop-off points, internet connection to display maps and determine locations in real-time, and notifications to keep you informed about your trip status.",
    icon: <Bell size={22} className="text-brand" />,
  },
  {
    title: "Data Security",
    content:
      "We take advanced security measures to protect your personal data from unauthorized access. We use state-of-the-art encryption technologies for data transmission and storage, operate on secure and certified servers, with continuous system monitoring to detect and immediately address any potential security threats.",
    icon: <Shield size={22} className="text-brand" />,
  },
  {
    title: "Data Retention",
    content:
      "We retain your personal data as long as your account is active and we need it to provide the service. If you delete your account, personal data will be removed within a reasonable timeframe, while retaining some anonymized information for statistical and service improvement purposes, in accordance with applicable legal requirements.",
    icon: <Clock size={22} className="text-brand" />,
  },
  {
    title: "Your Rights",
    content:
      "You have the full right to access your personal data stored with us at any time. You can request modification of any inaccurate information, complete deletion of your data, or export a copy of your data. To exercise any of these rights, please contact us via our official email address.",
    icon: <UserCheck size={22} className="text-brand" />,
  },
  {
    title: "Children's Privacy",
    content:
      "Waar Taxi is not intended for use by children under 13 years of age. We do not knowingly collect personal data from anyone under 13. If we discover that we have collected data from a child under this age, we will delete it immediately.",
    icon: <UserCheck size={22} className="text-brand" />,
  },
  {
    title: "Changes to This Policy",
    content:
      "We reserve the right to update this privacy policy at any time when necessary. If we make substantial changes, we will notify you via an in-app notification or through the email registered in your account. We recommend reviewing this policy periodically to stay informed of any updates.",
    icon: <Server size={22} className="text-brand" />,
  },
  {
    title: "Contact Us",
    content:
      "If you have any questions or concerns about our privacy policy or how we handle your data, we would be happy to hear from you via our official email: info@taxiwaar.com. Our team will respond to you as soon as possible.",
    icon: <Mail size={22} className="text-brand" />,
  },
];

export default function PrivacyPolicyPage() {
  return (
    <main className="min-h-screen flex flex-col">
      <Navbar />

      {/* Header */}
      <section className="relative pt-32 pb-16 overflow-hidden">
        <div className="absolute inset-0 bg-mesh noise-overlay" />
        <div className="absolute top-20 right-[20%] w-64 h-64 bg-[var(--brand-primary)]/8 rounded-full blur-[120px]" />
        <div className="absolute bottom-0 left-[10%] w-80 h-80 bg-[var(--brand-accent)]/6 rounded-full blur-[150px]" />

        <div className="relative z-10 max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <FadeInView>
            <div className="inline-flex items-center gap-2 px-4 py-2 glass rounded-full mb-6">
              <Shield size={16} className="text-brand" />
              <span className="text-sm text-subtle">الشفافية والأمان</span>
            </div>
          </FadeInView>

          <FadeInView delay={0.1}>
            <h1 className="text-4xl sm:text-5xl font-extrabold heading-color mb-4">
              سياسة <span className="gradient-text">الخصوصية</span>
            </h1>
          </FadeInView>

          <FadeInView delay={0.2}>
            <p className="text-subtle text-lg max-w-2xl mx-auto mb-4">
              نحن في{" "}
              <span className="text-brand font-semibold">
                وار تكسي
              </span>{" "}
              نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية بأعلى المعايير
            </p>
          </FadeInView>

          <FadeInView delay={0.3}>
            <p className="text-muted-custom text-sm">
              Last Updated:{" "}
              {new Date().toLocaleDateString("en-US", {
                year: "numeric",
                month: "long",
                day: "numeric",
              })}
            </p>
          </FadeInView>
        </div>
      </section>

      {/* Arabic Content */}
      <section dir="rtl" className="relative py-8">
        <div className="absolute inset-0 section-bg" />

        <div className="relative z-10 max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <FadeInView className="mb-8">
            <div className="flex items-center gap-3 mb-8">
              <div className="w-1 h-8 bg-gradient-to-b from-[var(--brand-primary)] to-[var(--brand-accent)] rounded-full" />
              <h2 className="text-2xl font-bold heading-color">
                سياسة الخصوصية - العربية
              </h2>
            </div>
          </FadeInView>

          <div className="space-y-6">
            {sectionsAr.map((section, index) => (
              <FadeInView key={`ar-${index}`} delay={index * 0.05}>
                <div className="glass-card rounded-2xl p-6 group">
                  <div className="flex items-start gap-4">
                    <div className="w-11 h-11 shrink-0 rounded-xl icon-brand-soft flex items-center justify-center transition-colors duration-300">
                      {section.icon}
                    </div>
                    <div className="flex-1">
                      <div className="flex items-center gap-3 mb-3">
                        <span className="text-muted-custom text-sm font-mono">
                          {String(index + 1).padStart(2, "0")}
                        </span>
                        <h3 className="text-lg font-bold heading-color">
                          {section.title}
                        </h3>
                      </div>
                      <p className="card-desc leading-relaxed text-sm">
                        {section.content}
                      </p>
                    </div>
                  </div>
                </div>
              </FadeInView>
            ))}
          </div>
        </div>
      </section>

      {/* English Content */}
      <section dir="ltr" className="relative py-8">
        <div className="absolute inset-0 section-bg-alt" />

        <div className="relative z-10 max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <FadeInView className="mb-8">
            <div className="flex items-center gap-3 mb-8">
              <div className="w-1 h-8 bg-gradient-to-b from-[var(--brand-primary)] to-[var(--brand-accent)] rounded-full" />
              <h2 className="text-2xl font-bold heading-color">
                Privacy Policy - English
              </h2>
            </div>
          </FadeInView>

          <div className="space-y-6">
            {sectionsEn.map((section, index) => (
              <FadeInView key={`en-${index}`} delay={index * 0.05}>
                <div className="glass-card rounded-2xl p-6 group">
                  <div className="flex items-start gap-4">
                    <div className="w-11 h-11 shrink-0 rounded-xl icon-brand-soft flex items-center justify-center transition-colors duration-300">
                      {section.icon}
                    </div>
                    <div className="flex-1">
                      <div className="flex items-center gap-3 mb-3">
                        <span className="text-muted-custom text-sm font-mono">
                          {String(index + 1).padStart(2, "0")}
                        </span>
                        <h3 className="text-lg font-bold heading-color">
                          {section.title}
                        </h3>
                      </div>
                      <p className="card-desc leading-relaxed text-sm">
                        {section.content}
                      </p>
                    </div>
                  </div>
                </div>
              </FadeInView>
            ))}
          </div>
        </div>
      </section>

      {/* Back to Home */}
      <section className="relative py-12">
        <div className="absolute inset-0 dark:bg-[#050d1a] bg-[#f0f7fc]" />
        <div className="relative z-10 max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <FadeInView>
            <Link
              href="/"
              className="inline-flex items-center gap-2 px-8 py-3 text-sm font-medium text-subtle glass hover:bg-[var(--brand-primary)]/5 rounded-2xl transition-all duration-300"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="16"
                height="16"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
                strokeLinecap="round"
                strokeLinejoin="round"
              >
                <path d="m9 18 6-6-6-6" />
              </svg>
              العودة للصفحة الرئيسية
            </Link>
          </FadeInView>

          <FadeInView delay={0.1}>
            <p className="text-muted-custom text-xs mt-8">
              © {new Date().getFullYear()} وار تكسي - Waar Taxi. جميع الحقوق
              محفوظة.
            </p>
          </FadeInView>
        </div>
      </section>
    </main>
  );
}
