import type { Metadata } from "next";
import { Tajawal, Geist, Geist_Mono } from "next/font/google";
import { ThemeProvider } from "next-themes";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

const tajawal = Tajawal({
  subsets: ["arabic", "latin"],
  variable: "--font-tajawal",
  display: "swap",
  weight: ["300", "400", "500", "700", "800", "900"],
});

const SITE_URL = "https://taxiwaar.com";
const SITE_NAME = "وار تكسي - Waar Taxi";

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: {
    default: "وار تكسي - Waar Taxi | تطبيق نقل الركاب في سوريا",
    template: "%s | وار تكسي - Waar Taxi",
  },
  description:
    "وار تكسي – تطبيقك الذكي لطلب سيارات الأجرة في سوريا. اطلب رحلتك بسهولة وسرعة، تتبعها لحظة بلحظة، واستمتع بتنقّل ذكي وآمن. حمل تطبيق المستخدم أو السائق الآن!",
  keywords: [
    "وار تكسي",
    "Waar Taxi",
    "تطبيق تاكسي",
    "سيارة أجرة",
    "نقل ركاب",
    "سوريا",
    "تطبيق نقل",
    "طلب سيارة",
    "أجرة سوريا",
    "تاكسي ذكي",
    "تنقل سوريا",
    "سائق تاكسي",
    "رحلة آمنة",
    "taxi app syria",
    "ride hailing",
    "transport syria",
  ],
  authors: [{ name: "Waar Taxi Team", url: SITE_URL }],
  creator: "Waar Taxi",
  publisher: "Waar Taxi",
  formatDetection: {
    email: false,
    address: false,
    telephone: false,
  },
  applicationName: SITE_NAME,
  icons: {
    icon: [
      { url: "/favicon.ico", sizes: "any" },
      { url: "/icon1.png", sizes: "96x96", type: "image/png" },
    ],
    apple: [{ url: "/apple-icon.png", sizes: "180x180", type: "image/png" }],
  },
  manifest: "/manifest.json",
  openGraph: {
    type: "website",
    locale: "ar_SY",
    alternateLocale: ["en_US"],
    url: SITE_URL,
    siteName: SITE_NAME,
    title: "وار تكسي - Waar Taxi | تطبيق نقل الركاب في سوريا",
    description:
      "تطبيقك الذكي لطلب سيارات الأجرة في سوريا. اطلب رحلتك بسهولة، تتبعها لحظة بلحظة، واستمتع بتنقّل ذكي وآمن!",
    images: [
      {
        url: "/og-image.png",
        width: 1200,
        height: 630,
        alt: "وار تكسي - Waar Taxi",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "وار تكسي - Waar Taxi",
    description:
      "تطبيقك الذكي لطلب سيارات الأجرة في سوريا. اطلب رحلتك الآن!",
    images: ["/og-image.png"],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-video-preview": -1,
      "max-image-preview": "large",
      "max-snippet": -1,
    },
  },
  alternates: {
    canonical: SITE_URL,
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="ar"
      dir="rtl"
      suppressHydrationWarning
      className={`${geistSans.variable} ${geistMono.variable} ${tajawal.variable} antialiased scroll-smooth`}
    >
      <head>
        <meta name="theme-color" content="#1594c7" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link
          rel="preconnect"
          href="https://fonts.gstatic.com"
          crossOrigin="anonymous"
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify({
              "@context": "https://schema.org",
              "@type": "WebApplication",
              name: "وار تكسي - Waar Taxi",
              description: "تطبيق ذكي لطلب سيارات الأجرة في سوريا",
              url: SITE_URL,
              applicationCategory: "TravelApplication",
              operatingSystem: "Android, iOS",
              offers: [
                {
                  "@type": "Offer",
                  price: "0",
                  priceCurrency: "SYP",
                  name: "تطبيق المستخدم",
                },
                {
                  "@type": "Offer",
                  price: "0",
                  priceCurrency: "SYP",
                  name: "تطبيق السائق",
                },
              ],
              aggregateRating: {
                "@type": "AggregateRating",
                ratingValue: "4.8",
                ratingCount: "5000",
                bestRating: "5",
                worstRating: "1",
              },
            }),
          }}
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify({
              "@context": "https://schema.org",
              "@type": "Organization",
              name: "وار تكسي - Waar Taxi",
              url: SITE_URL,
              logo: `${SITE_URL}/waar-logo.png`,
              contactPoint: {
                "@type": "ContactPoint",
                email: "info@taxiwaar.com",
                contactType: "customer service",
                availableLanguage: ["Arabic", "English"],
              },
            }),
          }}
        />
      </head>
      <body className="min-h-screen overflow-x-hidden font-[var(--font-tajawal)] transition-colors duration-300">
        <ThemeProvider
          attribute="class"
          defaultTheme="dark"
          enableSystem
          disableTransitionOnChange={false}
        >
          {children}
        </ThemeProvider>
      </body>
    </html>
  );
}
