"use client";
import { Button } from "@/components/ui/button";
import { usePathname, useRouter } from "@/i18n/navigation";
import { Languages } from "@/types/types";
import { Lock } from "lucide-react";
import { Logout } from "@/lib/actions";


export default function Unauthorized() {
    const router = useRouter();
    const pathname = usePathname();

    const ar = {
        title: "غير مصرح",
        description: "ليس لديك إذن للوصول إلى هذه الصفحة.",
        back: "العودة للرئيسية",
        logout: "تسجيل الخروج",
    };

    const en = {
        title: "Unauthorized",
        description: "You do not have permission to access this page.",
        back: "Go back home",
        logout: "Logout",
    };

    const kmr = {
        title: "Destûr tune",
        description: "Tu destûr nîne ku bigihîje vê rûpelê.",
        back: "Vegere ser malê",
        logout: "Derkeve",
    };

    const rawLang = pathname.split("/")[1];

    const lang: Languages =
        rawLang === "km" ? "kmr" : (rawLang as Languages);

    const t =
        lang === "ar"
            ? ar
            : lang === "kmr"
                ? kmr
                : en;

    const handleLogout = () => {
        localStorage.removeItem("fcm_token");
        Logout();
    };

    return (
        <main className="grid h-full place-items-center items-center-safe bg-background px-6 lg:px-8">
            <div className="text-center">
                <p className="text-base font-semibold text-indigo-600">401</p>

                {/* Lock Icon */}
                <div className="mt-6 flex justify-center">
                    <div className="rounded-full bg-indigo-100 p-6">
                        <Lock className="h-10 w-10 text-indigo-600" />
                    </div>
                </div>

                <h1 className="mt-6 text-5xl font-semibold tracking-tight text-gray-900 sm:text-7xl">
                    {t.title}
                </h1>

                <p className="mt-6 text-lg text-gray-500">
                    {t.description}
                </p>

                <div className="mt-10 flex items-center justify-center gap-4 flex-wrap">
                    <Button onClick={() => router.push(`/${lang}`)}>
                        {t.back}
                    </Button>

                    <Button variant="destructive" onClick={handleLogout}>
                        {t.logout}
                    </Button>
                </div>
            </div>
        </main>
    );
}