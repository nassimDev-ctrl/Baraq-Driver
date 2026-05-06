"use client";
import { Button } from "@/components/ui/button";
import { Logout } from "@/lib/actions";
import { Languages } from "@/types/types";
import { usePathname } from "next/navigation";

export default function GlobalError({
    error,
    reset,
}: {
    error: Error & { digest?: string };
    reset: () => void;
}) {
    console.log(error);

    const ar = {
        something_wrong_happened: "حدث خطأ ما!",
        try_again: "تحقق من اتصال الإنترنت لديك، أو حاول مرة أخرى لاحقًا.",
        reset: "إعادة المحاولة",
        logout: "تسجيل الخروج",
    };

    const en = {
        something_wrong_happened: "Something went wrong!",
        try_again: "Check your internet connection, or try again later.",
        reset: "Try again",
        logout: "Logout",
    };

    const kmr = {
        something_wrong_happened: "Tiştek çewt qewimî!",
        try_again: "Têkiliya xwe ya înternetê kontrol bike, an jî paşê dîsa biceribîne.",
        reset: "Dîsa biceribîne",
        logout: "Derkeve",
    };

    const pathname = usePathname();
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
        <html>
            <body>
                <main className="grid min-h-full place-items-center bg-background px-6 py-24 sm:py-32 lg:px-8">
                    <div className="text-center">
                        <p className="text-base font-semibold text-indigo-600">404</p>

                        <h1 className="mt-4 text-5xl font-semibold tracking-tight text-balance text-gray-900 sm:text-7xl">
                            {t.something_wrong_happened}
                        </h1>

                        <p className="mt-6 text-lg font-medium text-pretty text-gray-500 sm:text-xl/8">
                            {t.try_again}
                        </p>

                        <div className="mt-10 flex items-center justify-center gap-x-6">
                            <Button onClick={reset}>
                                {t.reset}
                            </Button>
                            <Button variant="destructive" onClick={handleLogout}>
                                {t.logout}
                            </Button>
                        </div>
                    </div>
                </main>
            </body>
        </html>
    );
}