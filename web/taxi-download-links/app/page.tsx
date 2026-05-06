import Image from "next/image";
import Link from "next/link";
import { siGoogleplay, siApple } from "simple-icons";
import { getClientAppInfo, getDriverAppInfo } from "../lib/data";
import waar_taxi from "../public/waar-qamishlo.png"

import {
  FadeInView,
  StaggerContainer,
  StaggerItem,
  ScaleIn,
} from "../components/animations";
import {
  MapPin,
  Clock,
  Shield,
  Star,
  CreditCard,
  Navigation,
  Smartphone,
  Users,
  ChevronDown,
} from "lucide-react";
import { Version } from "../lib/types";
import { Navbar } from "../components/Navbar";

function normalizeUrl(url: string) {
  if (!url) return "";
  if (url.startsWith("http://") || url.startsWith("https://")) return url;
  return `https://${url}`;
}

/* ============================
   HERO SECTION
   ============================ */
function HeroSection() {
  return (
    <section className="relative min-h-screen flex items-center justify-center pt-24 pb-16 overflow-hidden">
      {/* Background */}
      <div className="absolute inset-0 bg-mesh noise-overlay" />
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-transparent to-transparent dark:to-[#050d1a] to-[#f0f7fc]" />

      {/* Floating orbs */}
      <div className="absolute top-20 right-[15%] w-72 h-72 rounded-full blur-[120px] animate-float bg-[var(--brand-primary)]/10 dark:bg-[var(--brand-primary)]/10" />
      <div className="absolute bottom-20 left-[10%] w-96 h-96 rounded-full blur-[150px] animate-float-delayed bg-[var(--brand-accent)]/6 dark:bg-[var(--brand-accent)]/6" />
      <div className="absolute top-[40%] left-[50%] w-64 h-64 rounded-full blur-[100px] animate-float-slow bg-[var(--brand-primary)]/8 dark:bg-[var(--brand-primary)]/8" />

      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 w-full">
        <div className="grid lg:grid-cols-2 gap-12 lg:gap-16 items-center">
          {/* Text Content */}
          <div className="text-center lg:text-right">
            <FadeInView delay={0.1}>
              <div className="inline-flex items-center gap-2 px-4 py-2 glass rounded-full mb-6">
                <span className="w-2 h-2 bg-green-400 rounded-full animate-pulse" />
                <span className="text-sm text-subtle">متاح الآن في سوريا</span>
              </div>
            </FadeInView>

            <FadeInView delay={0.2}>
              <h1 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold leading-tight mb-6">
                <span className="gradient-text">تنقّل بذكاء</span>
                <br />
                <span className="heading-color">وسهولة مع</span>
                <br />
                <span className="gradient-text">وار تكسي</span>
              </h1>
            </FadeInView>

            <FadeInView delay={0.35}>
              <p className="text-lg sm:text-xl text-subtle max-w-lg mx-auto lg:mx-0 mb-8 leading-relaxed">
                تطبيقك الذكي لطلب سيارات الأجرة بكل سهولة وسرعة. اطلب
                رحلتك في أي وقت ومن أي مكان، وتابعها لحظة بلحظة.
              </p>
            </FadeInView>

            <FadeInView delay={0.5}>
              <div className="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
                <a
                  href="#download"
                  className="group inline-flex items-center justify-center gap-3 px-8 py-4 text-lg font-bold text-white btn-brand rounded-2xl shadow-xl shadow-[var(--brand-primary)]/25 hover:shadow-[var(--brand-primary)]/40 hover:scale-[1.02] transition-all duration-500"
                >
                  <Smartphone size={22} />
                  حمّل التطبيق الآن
                </a>
                <a
                  href="#features"
                  className="inline-flex items-center justify-center gap-2 px-8 py-4 text-lg font-medium text-subtle glass hover:bg-[var(--brand-primary)]/5 rounded-2xl transition-all duration-300"
                >
                  اكتشف المزيد
                  <ChevronDown size={18} className="animate-bounce" />
                </a>
              </div>
            </FadeInView>

            {/* Quick stats */}
            <FadeInView delay={0.65}>
              <div className="flex items-center gap-8 mt-12 justify-center lg:justify-start">
                {[
                  { value: "10K+", label: "رحلة يومياً" },
                  { value: "5K+", label: "سائق نشط" },
                  { value: "4.8", label: "تقييم المستخدمين" },
                ].map((stat) => (
                  <div key={stat.label} className="text-center">
                    <div className="text-2xl font-bold gradient-text">
                      {stat.value}
                    </div>
                    <div className="text-xs text-muted-custom mt-1">
                      {stat.label}
                    </div>
                  </div>
                ))}
              </div>
            </FadeInView>
          </div>

          {/* Phone Mockup */}
          <FadeInView direction="left" delay={0.3}>
            <div className="relative flex justify-center lg:justify-end">
              <div className="relative w-[280px] sm:w-[320px]">
                {/* Glow behind phone */}
                <div className="absolute inset-0 bg-[var(--brand-primary)]/15 dark:bg-[var(--brand-primary)]/15 rounded-[3rem] blur-3xl scale-110" />

                {/* Phone frame */}
                <div className="relative glass-strong rounded-[2.5rem] p-3 animate-float-slow">
                  <div className="rounded-[2rem] overflow-hidden bg-gradient-to-br dark:from-[#0a1628] dark:to-[#06101f] from-white to-[#f0f7fc]">
                    <div className="p-6 flex flex-col items-center gap-4">
                      {/* Status bar */}
                      <div className="w-full flex items-center justify-between text-[10px] text-subtle px-2">
                        <span>9:41</span>
                        <div className="w-20 h-5 bg-black/10 dark:bg-black/40 rounded-full" />
                        <span>100%</span>
                      </div>

                      {/* App content */}
                      <div className="w-full mt-4 space-y-3">
                        <div className="text-center mb-2">
                          <div className="w-12 h-12 mx-auto rounded-2xl icon-brand flex items-center justify-center mb-2 p-1">
                            <div className="w-full h-full rounded-xl bg-white flex items-center justify-center">
                              <Image
                                src={waar_taxi}
                                alt="Waar Taxi"
                                width={44}
                                height={44}
                                className="w-full h-full object-contain"
                              />
                            </div>
                          </div>
                          <p className="text-brand text-sm font-bold">
                            وار تكسي
                          </p>
                        </div>

                        {/* Map area */}
                        <div className="w-full h-32 rounded-2xl bg-gradient-to-br dark:from-[var(--brand-primary)]/10 dark:to-[var(--brand-accent)]/10 from-[var(--brand-primary)]/8 to-[var(--brand-accent)]/5 border border-[var(--brand-primary)]/10 flex items-center justify-center relative overflow-hidden">
                          <div className="absolute inset-0 opacity-20">
                            <Image
                              src="/hero-bg.png"
                              alt=""
                              width={300}
                              height={200}
                              className="w-full h-full object-cover"
                            />
                          </div>
                          <Navigation className="text-[var(--brand-primary)]/60 size-8" />
                          <div className="absolute top-3 right-3 w-3 h-3 bg-green-400 rounded-full animate-ping" />
                          <div className="absolute bottom-3 left-3 w-3 h-3 bg-[var(--brand-primary)] rounded-full" />
                        </div>

                        {/* Ride options */}
                        <div className="grid grid-cols-3 gap-2">
                          {[
                            { icon: "🚗", label: "اقتصادي" },
                            { icon: "🚙", label: "مريح" },
                            { icon: "🚐", label: "عائلي" },
                          ].map((ride) => (
                            <div
                              key={ride.label}
                              className="glass rounded-xl p-2 text-center"
                            >
                              <span className="text-lg">{ride.icon}</span>
                              <p className="text-[9px] text-subtle mt-1">
                                {ride.label}
                              </p>
                            </div>
                          ))}
                        </div>

                        {/* Book button */}
                        <button className="w-full py-3 btn-brand text-white font-bold text-sm rounded-xl">
                          اطلب رحلتك الآن
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </FadeInView>
        </div>
      </div>
    </section>
  );
}

/* ============================
   FEATURES SECTION
   ============================ */
function FeaturesSection() {
  const features = [
    {
      icon: <MapPin size={28} className="text-brand" />,
      title: "تحديد الموقع بدقة",
      desc: "حدد موقعك الحالي بدقة عالية باستخدام تقنية GPS المتقدمة، واختر وجهتك بسهولة على الخريطة التفاعلية.",
    },
    {
      icon: <Clock size={28} className="text-brand" />,
      title: "طلب فوري على مدار الساعة",
      desc: "اطلب رحلتك في أي وقت كان، صباحاً أو ليلاً. سائقونا متواجدون دائماً لخدمتك عند الحاجة.",
    },
    {
      icon: <Navigation size={28} className="text-brand" />,
      title: "تتبع الرحلة لحظة بلحظة",
      desc: "تابع سائقك على الخريطة مباشرة واعرف الوقت المتوقع للوصول. أنت دائماً على اطلاع بالرحلة.",
    },
    {
      icon: <CreditCard size={28} className="text-brand" />,
      title: "خيارات دفع مرنة",
      desc: "ادفع بالطريقة التي تناسبك: نقداً أو عبر المحفظة الإلكترونية. خيارات متعددة تلبي احتياجات الجميع.",
    },
    {
      icon: <Shield size={28} className="text-brand" />,
      title: "سائقون موثوقون ومدربون",
      desc: "جميع سائقينا معتمدون ومدربون على أعلى مستوى. نحرص على راحتك وأمانك في كل رحلة.",
    },
    {
      icon: <Star size={28} className="text-brand" />,
      title: "قيّم وتحسّن الخدمة",
      desc: "شاركنا رأيك وقيّم رحلتك وسائقك بعد كل انتهاء رحلة. ملاحظاتك تساعدنا على التحسين المستمر.",
    },
  ];

  return (
    <section id="features" className="relative py-24 overflow-hidden">
      <div className="absolute inset-0 section-bg" />
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-[600px] h-[600px] bg-[var(--brand-primary)]/5 rounded-full blur-[150px]" />

      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <FadeInView className="text-center mb-16">
          <span className="inline-block px-4 py-1.5 glass rounded-full text-sm text-brand mb-4">
            لماذا وار تكسي؟
          </span>
          <h2 className="text-3xl sm:text-4xl font-extrabold heading-color mb-4">
            تجربة تنقّل <span className="gradient-text">استثنائية</span>
          </h2>
          <p className="text-subtle max-w-2xl mx-auto text-lg">
            نوفر لك كل ما تحتاجه لرحلة مريحة وآمنة، بتقنيات حديثة وواجهة
            سهلة الاستخدام
          </p>
        </FadeInView>

        <StaggerContainer className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {features.map((feature) => (
            <StaggerItem key={feature.title}>
              <div className="glass-card rounded-2xl p-6 h-full group cursor-default">
                <div className="w-14 h-14 icon-brand-soft rounded-2xl flex items-center justify-center mb-5 transition-colors duration-300">
                  {feature.icon}
                </div>
                <h3 className="text-lg font-bold heading-color mb-3">
                  {feature.title}
                </h3>
                <p className="card-desc leading-relaxed text-sm">
                  {feature.desc}
                </p>
              </div>
            </StaggerItem>
          ))}
        </StaggerContainer>
      </div>
    </section>
  );
}

/* ============================
   HOW IT WORKS SECTION
   ============================ */
function HowItWorksSection() {
  const steps = [
    {
      number: "01",
      title: "سجّل حسابك",
      desc: "أنشئ حسابك بسهولة عبر رقم هاتفك واستعد للانطلاق.",
      icon: <Users size={24} />,
    },
    {
      number: "02",
      title: "اطلب رحلتك",
      desc: "حدد موقعك ووجهتك، واختر نوع الرحلة المناسب لك.",
      icon: <MapPin size={24} />,
    },
    {
      number: "03",
      title: "استمتع بالرحلة",
      desc: "تتبع سائقك وتابع رحلتك لحظة بلحظة حتى الوصول.",
      icon: <Navigation size={24} />,
    },
  ];

  return (
    <section className="relative py-24 overflow-hidden">
      <div className="absolute inset-0 section-bg-alt" />

      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <FadeInView className="text-center mb-16">
          <span className="inline-block px-4 py-1.5 glass rounded-full text-sm text-brand mb-4">
            سهولة الاستخدام
          </span>
          <h2 className="text-3xl sm:text-4xl font-extrabold heading-color mb-4">
            كيف يعمل <span className="gradient-text">وار تكسي</span>؟
          </h2>
          <p className="text-subtle max-w-2xl mx-auto text-lg">
            ثلاث خطوات بسيطة فقط وستكون في طريقك
          </p>
        </FadeInView>

        <StaggerContainer className="grid md:grid-cols-3 gap-8">
          {steps.map((step) => (
            <StaggerItem key={step.number}>
              <div className="relative text-center group">
                <div className="relative inline-flex items-center justify-center w-20 h-20 glass-strong rounded-3xl mb-6 icon-brand-soft transition-colors duration-500">
                  <span className="absolute -top-2 -right-2 w-7 h-7 icon-brand rounded-lg flex items-center justify-center text-xs font-bold text-white">
                    {step.number}
                  </span>
                  <span className="text-brand">{step.icon}</span>
                </div>

                <h3 className="text-xl font-bold heading-color mb-3">
                  {step.title}
                </h3>
                <p className="text-subtle leading-relaxed max-w-xs mx-auto">
                  {step.desc}
                </p>
              </div>
            </StaggerItem>
          ))}
        </StaggerContainer>
      </div>
    </section>
  );
}

/* ============================
   SAFETY SECTION
   ============================ */
function SafetySection() {
  return (
    <section id="safety" className="relative py-24 overflow-hidden">
      <div className="absolute inset-0 section-bg" />
      <div className="absolute bottom-0 right-0 w-96 h-96 bg-[var(--brand-primary)]/5 rounded-full blur-[150px]" />

      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="glass-strong rounded-3xl p-8 sm:p-12 lg:p-16 overflow-hidden relative">
          <div className="absolute inset-0 bg-gradient-to-br from-[var(--brand-primary)]/5 to-[var(--brand-accent)]/5 pointer-events-none" />

          <div className="relative z-10 grid lg:grid-cols-2 gap-12 items-center">
            <div>
              <FadeInView>
                <span className="inline-block px-4 py-1.5 icon-brand-soft rounded-full text-sm text-brand mb-6">
                  أمانك أولويتنا
                </span>
              </FadeInView>

              <FadeInView delay={0.1}>
                <h2 className="text-3xl sm:text-4xl font-extrabold heading-color mb-6 leading-tight">
                  تنقّل بأمان
                  <br />
                  <span className="gradient-text">وثقة كاملة</span>
                </h2>
              </FadeInView>

              <FadeInView delay={0.2}>
                <p className="text-subtle text-lg leading-relaxed mb-8">
                  في وار تكسي، نضع سلامتك في المقام الأول. كل رحلة تخضع لمعايير أمان صارمة لضمان تجربة سفر مريحة وموثوقة للجميع.
                </p>
              </FadeInView>

              <FadeInView delay={0.3}>
                <div className="space-y-4">
                  {[
                    {
                      title: "تشفير كامل للبيانات",
                      desc: "جميع معلوماتك الشخصية وموقعك مشفرة ومحمية بأحدث التقنيات.",
                    },
                    {
                      title: "تتبع الرحلات في الوقت الفعلي",
                      desc: "أنت وعائلتك يمكنكم متابعة الرحلة مباشرة على الخريطة.",
                    },
                    {
                      title: "نظام تقييم ومراجعة شفاف",
                      desc: "سائقون ذوو تقييمات عالية فقط يقدمون خدماتنا.",
                    },
                    {
                      title: "دعم فني على مدار الساعة",
                      desc: "فريقنا جاهز لمساعدتك في أي وقت ومن أي مكان.",
                    },
                  ].map((item) => (
                    <div
                      key={item.title}
                      className="flex gap-4 items-start group"
                    >
                      <div className="w-8 h-8 mt-1 rounded-lg icon-brand-soft flex items-center justify-center shrink-0 transition-colors">
                        <Shield size={16} className="text-brand" />
                      </div>
                      <div>
                        <h4 className="heading-color font-semibold mb-1 text-sm">
                          {item.title}
                        </h4>
                        <p className="card-desc text-sm">{item.desc}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </FadeInView>
            </div>

            <ScaleIn className="hidden lg:flex justify-center">
              <div className="relative">
                <div className="absolute inset-0 bg-[var(--brand-primary)]/10 rounded-3xl blur-3xl scale-110" />
                <div className="relative glass-card rounded-3xl p-8">
                  <div className="space-y-4">
                    <div className="flex items-center gap-4 glass rounded-2xl p-4">
                      <div className="w-12 h-12 rounded-full bg-gradient-to-br from-green-400 to-green-600 flex items-center justify-center text-white font-bold text-lg">
                        أ
                      </div>
                      <div>
                        <p className="heading-color font-semibold text-sm">
                          أحمد محمد
                        </p>
                        <div className="flex items-center gap-1 mt-1">
                          {Array.from({ length: 5 }).map((_, i) => (
                            <Star
                              key={i}
                              size={12}
                              className="text-amber-400 fill-amber-400"
                            />
                          ))}
                          <span className="text-subtle text-xs mr-1">
                            4.9
                          </span>
                        </div>
                      </div>
                      <div className="mr-auto px-3 py-1 bg-green-400/10 border border-green-400/20 rounded-full text-green-600 dark:text-green-400 text-xs">
                        متصل
                      </div>
                    </div>

                    <div className="grid grid-cols-3 gap-3">
                      <div className="glass rounded-2xl p-4 text-center">
                        <p className="text-2xl font-bold gradient-text">
                          500+
                        </p>
                        <p className="text-subtle text-xs mt-1">رحلة</p>
                      </div>
                      <div className="glass rounded-2xl p-4 text-center">
                        <p className="text-2xl font-bold gradient-text">
                          3
                        </p>
                        <p className="text-subtle text-xs mt-1">سنوات</p>
                      </div>
                      <div className="glass rounded-2xl p-4 text-center">
                        <p className="text-2xl font-bold gradient-text">
                          98%
                        </p>
                        <p className="text-subtle text-xs mt-1">رضا</p>
                      </div>
                    </div>

                    <div className="glass rounded-2xl p-4">
                      <div className="flex items-center gap-3 mb-3">
                        <div className="w-8 h-8 rounded-lg icon-brand-soft flex items-center justify-center">
                          <MapPin size={16} className="text-brand" />
                        </div>
                        <span className="text-subtle text-sm">
                          آخر رحلة
                        </span>
                      </div>
                      <div className="flex items-center justify-between text-sm">
                        <span className="text-subtle">المدينة القديمة</span>
                        <Navigation size={14} className="text-muted-custom" />
                        <span className="text-subtle">المطار</span>
                      </div>
                      <div className="mt-2 text-xs text-muted-custom">
                        23 دقيقة - 12.5 كم
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </ScaleIn>
          </div>
        </div>
      </div>
    </section>
  );
}

/* ============================
   DOWNLOAD SECTION
   ============================ */
function DownloadSection({
  clientAppData,
  driverAppData,
}: {
  clientAppData: Version;
  driverAppData: Version;
}) {
  return (
    <section id="download" className="relative py-24 overflow-hidden">
      <div className="absolute inset-0 section-bg-alt" />
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-[var(--brand-primary)]/5 rounded-full blur-[200px]" />

      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <FadeInView className="text-center mb-16">
          <span className="inline-block px-4 py-1.5 glass rounded-full text-sm text-brand mb-4">
            حمّل التطبيق
          </span>
          <h2 className="text-3xl sm:text-4xl font-extrabold heading-color mb-4">
            ابدأ رحلتك <span className="gradient-text">الآن</span>
          </h2>
          <p className="text-subtle max-w-2xl mx-auto text-lg">
            حمل تطبيق وار تكسي وانضم لآلاف المستخدمين الذين يثقون بنا يومياً
          </p>
        </FadeInView>

        <StaggerContainer className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
          {/* Client App */}
          <StaggerItem>
            <div className="glass-card gradient-border rounded-3xl p-8 h-full text-center group">
              <div className="relative inline-flex items-center justify-center w-20 h-20 icon-brand-soft rounded-2xl mb-6 transition-colors duration-500">
                <Smartphone size={36} className="text-brand" />
              </div>
              <h3 className="text-2xl font-bold heading-color mb-2">
                تطبيق المستخدم
              </h3>
              <p className="text-subtle mb-6 leading-relaxed">
                اطلب رحلتك بسهولة، تتبعها لحظة بلحظة، واستمتع بتنقّل ذكي
                ومريح
              </p>
              <div className="space-y-3 mb-6">
                <div className="flex items-center justify-center gap-2 text-sm text-subtle">
                  <span>الإصدار:</span>
                  <span className="heading-color font-medium">
                    {clientAppData.version}
                  </span>
                </div>
                <div className="flex items-center justify-center gap-2 text-sm text-subtle">
                  <span>آخر تحديث:</span>
                  <span className="heading-color font-medium">
                    {new Date(clientAppData.updatedAt).toLocaleDateString(
                      "ar-SY"
                    )}
                  </span>
                </div>
                {/* {clientAppData.size && (
                  <div className="flex items-center justify-center gap-2 text-sm text-subtle">
                    <span>الحجم:</span>
                    <span className="heading-color font-medium">
                      {clientAppData.size}
                    </span>
                  </div>
                )} */}
              </div>
              <a
                href={normalizeUrl(clientAppData.downloadLink)}
                target="_blank"
                rel="noopener noreferrer"
                className="group/btn inline-flex items-center justify-center gap-3 w-full px-8 py-4 text-lg font-bold text-white btn-brand rounded-2xl shadow-xl shadow-[var(--brand-primary)]/25 hover:shadow-[var(--brand-primary)]/40 transition-all duration-500"
              >
                <div
                  className="w-6 h-6 fill-current"
                  dangerouslySetInnerHTML={{
                    __html: siGoogleplay.svg,
                  }}
                />
                تحميل تطبيق المستخدم
              </a>
            </div>
          </StaggerItem>

          {/* Driver App */}
          <StaggerItem>
            <div className="glass-card gradient-border rounded-3xl p-8 h-full text-center group">
              <div className="relative inline-flex items-center justify-center w-20 h-20 icon-brand-soft rounded-2xl mb-6 transition-colors duration-500">
                <Navigation size={36} className="text-brand" />
              </div>
              <h3 className="text-2xl font-bold heading-color mb-2">
                تطبيق السائق
              </h3>
              <p className="text-subtle mb-6 leading-relaxed">
                انضم لفريق السائقين، واستقبل الطلبات، وابدأ بكسب الدخل بطريقة
                مرنة
              </p>
              <div className="space-y-3 mb-6">
                <div className="flex items-center justify-center gap-2 text-sm text-subtle">
                  <span>الإصدار:</span>
                  <span className="heading-color font-medium">
                    {driverAppData.version}
                  </span>
                </div>
                <div className="flex items-center justify-center gap-2 text-sm text-subtle">
                  <span>آخر تحديث:</span>
                  <span className="heading-color font-medium">
                    {new Date(driverAppData.updatedAt).toLocaleDateString(
                      "ar-SY"
                    )}
                  </span>
                </div>
                {/* {driverAppData.size && (
                  <div className="flex items-center justify-center gap-2 text-sm text-subtle">
                    <span>الحجم:</span>
                    <span className="heading-color font-medium">
                      {driverAppData.size}
                    </span>
                  </div>
                )} */}
              </div>
              <a
                href={normalizeUrl(driverAppData.downloadLink)}
                target="_blank"
                rel="noopener noreferrer"
                className="group/btn inline-flex items-center justify-center gap-3 w-full px-8 py-4 text-lg font-bold text-white btn-brand rounded-2xl shadow-xl shadow-[var(--brand-primary)]/25 hover:shadow-[var(--brand-primary)]/40 transition-all duration-500"
              >
                <div
                  className="w-6 h-6 fill-current"
                  dangerouslySetInnerHTML={{
                    __html: siGoogleplay.svg,
                  }}
                />
                تحميل تطبيق السائق
              </a>
            </div>
          </StaggerItem>
        </StaggerContainer>

        {/* Store badges */}
        <FadeInView delay={0.4} className="mt-12 text-center">
          <p className="text-muted-custom text-sm mb-6">متوفر قريباً على</p>
          <div className="flex items-center justify-center gap-4 flex-wrap">
            <div className="glass-card rounded-2xl px-6 py-3 flex items-center gap-3">
              <div
                className="w-6 h-6 fill-brand"
                dangerouslySetInnerHTML={{ __html: siGoogleplay.svg }}
              />
              <span className="text-subtle font-medium text-sm">
                Google Play
              </span>
            </div>
            <div className="glass-card rounded-2xl px-6 py-3 flex items-center gap-3">
              <div
                className="w-6 h-6 fill-brand"
                dangerouslySetInnerHTML={{ __html: siApple.svg }}
              />
              <span className="text-subtle font-medium text-sm">
                App Store
              </span>
            </div>
          </div>
        </FadeInView>
      </div>
    </section>
  );
}

/* ============================
   FOOTER
   ============================ */
function Footer() {
  return (
    <footer className="relative py-12 border-t border-[var(--brand-primary)]/10">
      <div className="absolute inset-0 dark:bg-[#050d1a] bg-[#f0f7fc]" />
      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col items-center gap-6">
          {/* Logo */}
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl overflow-hidden icon-brand flex items-center justify-center p-0.5">
              <div className="w-full h-full rounded-[10px] overflow-hidden bg-white flex items-center justify-center">
                <Image
                  src={waar_taxi}
                  alt="Waar Taxi"
                  width={36}
                  height={36}
                  className="object-contain"
                />
              </div>
            </div>
            <div>
              <p className="text-brand font-bold">وار تكسي</p>
              <p className="text-muted-custom text-xs">Waar Taxi</p>
            </div>
          </div>

          {/* Links */}
          <div className="flex items-center gap-6 text-sm">
            <Link
              href="#features"
              className="text-subtle hover:text-brand transition-colors"
            >
              المميزات
            </Link>
            <Link
              href="#download"
              className="text-subtle hover:text-brand transition-colors"
            >
              التحميل
            </Link>
            <Link
              href="#safety"
              className="text-subtle hover:text-brand transition-colors"
            >
              الأمان
            </Link>
            <Link
              href="/privacy-policy"
              className="text-subtle hover:text-brand transition-colors"
            >
              سياسة الخصوصية
            </Link>
          </div>

          {/* Contact */}
          <div className="text-center">
            <a
              href="mailto:info@taxiwaar.com"
              className="text-muted-custom hover:text-brand text-sm transition-colors"
            >
              info@taxiwaar.com
            </a>
          </div>

          {/* Copyright */}
          <p className="text-muted-custom text-xs">
            © {new Date().getFullYear()} وار تكسي - Waar Taxi. جميع الحقوق
            محفوظة.
          </p>
        </div>
      </div>
    </footer>
  );
}

/* ============================
   MAIN PAGE
   ============================ */
export default async function HomePage() {
  const driverAppData: Version = await getDriverAppInfo();
  const clientAppData: Version = await getClientAppInfo();

  return (
    <main className="min-h-screen flex flex-col">
      <Navbar />
      <HeroSection />
      <FeaturesSection />
      <HowItWorksSection />
      <SafetySection />
      <DownloadSection clientAppData={clientAppData} driverAppData={driverAppData} />
      <Footer />
    </main>
  );
}
