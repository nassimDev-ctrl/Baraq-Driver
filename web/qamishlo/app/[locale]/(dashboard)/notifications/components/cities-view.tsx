"use client";

import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Check } from "lucide-react";
import { City } from "@/types/types";
import { useLocale, useTranslations } from "next-intl";

interface Props {
    cities: City[];
    allCities: City[];
}

export default function CitiesViewOnly({ cities, allCities }: Props) {
    const t = useTranslations("CitiesViewOnly");

    const locale = useLocale();

    const isAll = cities.length === 0;

    const selectedGovIds = isAll
        ? allCities.map((g) => g._id)
        : cities.map((g) => g._id);

    return (
        <Dialog>
            <DialogTrigger asChild>
                <Button variant="link">
                    {isAll ? t("all") : `${cities.length} ${t("governorate")}`}
                </Button>
            </DialogTrigger>

            <DialogContent className="h-160 overflow-y-auto hide-scrollbar">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <div className="space-y-2">
                    {allCities.map((city) => {
                        const checked = selectedGovIds.includes(city._id);

                        return (
                            <div
                                key={city._id}
                                className={`flex justify-between items-center w-full border px-3 py-2 rounded-md ${checked
                                    ? "bg-primary/10 border-primary"
                                    : "opacity-60"
                                    }`}
                            >
                                {locale === "ar" ? city.nameAr : locale === "en" ? city.nameEn : city.nameKu}
                                {checked && <Check className="size-4" />}
                            </div>
                        );
                    })}
                </div>
            </DialogContent>
        </Dialog>
    );
}