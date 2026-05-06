import type { Metadata } from "next";
import { Geist, Cairo } from "next/font/google";
import "./globals.css";
import { Toaster } from "@/components/ui/sonner";
import { NuqsAdapter } from "nuqs/adapters/next/app";
import { getLocale } from "next-intl/server";
import AppInit from "@/components/AppInit";
import NotificationListener from "@/components/NotificationListener";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const cairoSans = Cairo({
  subsets: ["arabic", "latin"],
  variable: "--font-sans",
});

export async function generateMetadata(): Promise<Metadata> {
  const locale = await getLocale();

  const isArabic = locale === "ar";
  const isKurdish = locale === "kmr";

  return {
    title: isArabic
      ? "وار قامشلو"
      : isKurdish
        ? "Waar Qamişlo"
        : "Waar Qamishlo",

    description: isArabic
      ? "وار قامشلو"
      : isKurdish
        ? "Waar Qamişlo"
        : "Waar Qamishlo",

    applicationName: isArabic
      ? "قامشلو"
      : isKurdish
        ? "Qamişlo"
        : "Qamishlo",

    appleWebApp: {
      capable: true,
      title: isArabic
        ? "قامشلو"
        : isKurdish
          ? "Qamişlo"
          : "Qamishlo",
      statusBarStyle: "default",
    },

    openGraph: {
      title: isArabic
        ? "وار قامشلو"
        : isKurdish
          ? "Waar Qamişlo"
          : "Waar Qamishlo",

      description: isArabic
        ? "وار قامشلو"
        : isKurdish
          ? "Waar Qamişlo"
          : "Waar Qamishlo",

      type: "website",
      locale: isArabic ? "ar" : isKurdish ? "kmr" : "en",
    },
  };
}

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const locale = await getLocale();
  return (
    <html suppressHydrationWarning lang={locale} dir={locale === "ar" ? "rtl" : "ltr"}>
      <meta name="apple-mobile-web-app-title" content="Waar Qamishlo" />
      <body
        className={`${geistSans.variable} ${cairoSans.variable} antialiased bg-white`}
      >
        {/* FCM initialization */}
        {/* {typeof window !== "undefined" && <AppInit />} */}
        <AppInit />
        {/* Start listening for messages */}
        {/* {typeof window !== "undefined" && <NotificationListener />} */}
        <NotificationListener />
        <NuqsAdapter>
          {children}
        </NuqsAdapter>
        <Toaster />
      </body>
    </html>
  );
}
