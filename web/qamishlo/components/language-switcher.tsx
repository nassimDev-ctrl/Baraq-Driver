"use client";
import { useLocale } from "next-intl";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuTrigger,
    DropdownMenuRadioGroup,
    DropdownMenuRadioItem,
} from "@/components/ui/dropdown-menu";
import { Button } from "./ui/button";
import { Globe } from "lucide-react";
import { usePathname, useRouter } from "@/i18n/navigation";
import { updateLanguage } from "@/lib/actions";
const LANGUAGES = [
    { value: "ar", label: "العربية" },
    { value: "en", label: "English" },
    { value: "kmr", label: "Kurmancî" },
];

export function LanguageSwitcher() {
    const router = useRouter();
    const pathname = usePathname();
    const locale = useLocale();

    const handleChange = (nextLocale: string) => {
        updateLanguage(nextLocale)
        router.push(pathname, { locale: nextLocale });
    };

    return (
        <DropdownMenu>
            <DropdownMenuTrigger asChild>
                <Button
                    variant="ghost"
                    size="icon"
                    className="bg-white text-black hover:bg-gray-100"
                >
                    <Globe className="h-5 w-5" />
                </Button>
            </DropdownMenuTrigger>

            <DropdownMenuContent align="end">
                <DropdownMenuRadioGroup
                    value={locale}
                    onValueChange={handleChange}
                >
                    {LANGUAGES.map((lang) => (
                        <DropdownMenuRadioItem
                            key={lang.value}
                            value={lang.value}
                        >
                            {lang.label}
                        </DropdownMenuRadioItem>
                    ))}
                </DropdownMenuRadioGroup>
            </DropdownMenuContent>
        </DropdownMenu>
    );
}
