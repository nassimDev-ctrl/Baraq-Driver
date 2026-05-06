"use client";

import { Button } from "@/components/ui/button";
import { useRouter } from "@/i18n/navigation";
import { cn } from "@/lib/utils";
import { ChevronRight } from "lucide-react";
import { useLocale, useTranslations } from "next-intl";

interface GoBackButtonProps {
    link: string
}

export default function GoBackButton({ link }: GoBackButtonProps) {
    const t = useTranslations("go_back_button");
    const router = useRouter();
    const locale = useLocale();
    return (
        <Button
            variant="outline"
            type="button"
            onClick={() => router.push(link)}
            className="gap-2"
        >
            <ChevronRight className={cn("size-4", locale !== "ar" && "rotate-180")} />
            <span>{t("back")}</span>
        </Button>
    );
}
