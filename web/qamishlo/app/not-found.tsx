"use client";
import { Button } from "@/components/ui/button";
// import { usePathname, useRouter } from "@/i18n/navigation";

import { Languages } from "@/types/types";
import { usePathname, useRouter } from "next/navigation";

export default function NotFound() {
    const router = useRouter();
    const pathname = usePathname();

    const ar = {
        title: "الصفحة غير موجودة",
        description: "عذراً، الصفحة التي تبحث عنها غير موجودة.",
        back: "العودة للرئيسية",
    };

    const en = {
        title: "Page not found",
        description: "Sorry, the page you are looking for does not exist.",
        back: "Go back home",
    };

    const kmr = {
        title: "Rûpel nehat dîtin",
        description: "Bibore, rûpela ku tu lê digerî tune ye.",
        back: "Vegere ser malê",
    };

    // Extract language safely
    const rawLang = pathname.split("/")[1];

    const lang: Languages =
        rawLang === "km" ? "kmr" : (rawLang as Languages);
    const t =
        lang === "ar"
            ? ar
            : lang === "kmr"
                ? kmr
                : en;

    return (
        <main className="grid min-h-screen place-items-center bg-background px-6 py-24 sm:py-32 lg:px-8">
            <div className="text-center">
                <p className="text-base font-semibold text-indigo-600">404</p>

                <h1 className="mt-4 text-5xl font-semibold tracking-tight text-gray-900 sm:text-7xl">
                    {t.title}
                </h1>

                <p className="mt-6 text-lg text-gray-500">
                    {t.description}
                </p>

                <div className="mt-10">
                    <Button
                        onClick={() => router.replace(`/${lang}`)}
                    >
                        {t.back}
                    </Button>
                </div>
            </div>
        </main >
    );
}