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
import { toast } from "sonner";
import { useState } from "react";
import { useLocale, useTranslations } from "next-intl";
import { Spinner } from "@/components/ui/spinner";
import { updateDiscountCode } from "@/lib/actions";
import { UpdateDiscountCodeType } from "@/schemas/schemas";
import { City } from "@/types/types";

interface CityViewProps {
    discountCodeId: string;
    cities: City[];
    allCities: City[];
}

export default function CityView({
    discountCodeId,
    cities,
    allCities,
}: CityViewProps) {
    const [open, setOpen] = useState(false);
    const [loading, setLoading] = useState(false);
    const [wasAll, setWasAll] = useState(cities.length === 0);
    const t = useTranslations("discountCodePage.updateDiscountCodeCity");
    const locale = useLocale();

    const [selectedCities, setSelectedCities] = useState<string[]>(
        cities.map((c) => c._id)
    );

    const handleOpenChange = (isOpen: boolean) => {
        setOpen(isOpen);

        if (isOpen) {
            const isAll = cities.length === 0;
            setWasAll(isAll);

            if (isAll) {
                setSelectedCities(allCities.map((c) => c._id));
            } else {
                setSelectedCities(cities.map((c) => c._id));
            }
        }
    };
    const handleToggle = (id: string) => {
        setSelectedCities((prev) =>
            prev.includes(id)
                ? prev.filter((c) => c !== id)
                : [...prev, id]
        );
    };

    const handleSave = async () => {
        setLoading(true);

        const allIds = allCities.map((c) => c._id);
        const isNowAll = selectedCities.length === allIds.length;

        let payload: UpdateDiscountCodeType = {};

        // 🟢 CASE 1: Was ALL before
        if (wasAll) {
            if (isNowAll) {
                payload = {};
            } else {
                // ALL → SOME
                payload = {
                    addCities: selectedCities,
                };
            }
        }

        // 🟢 CASE 2: Was SOME before
        else {
            const originalIds = cities.map((c) => c._id);

            if (isNowAll) {
                // SOME → ALL
                payload = {
                    removeCities: originalIds,
                };
            } else {
                const addCities = selectedCities.filter(
                    (id) => !originalIds.includes(id)
                );

                const removeCities = originalIds.filter(
                    (id) => !selectedCities.includes(id)
                );

                payload = {
                    addCities: addCities.length ? addCities : undefined,
                    removeCities: removeCities.length ? removeCities : undefined,
                };
            }
        }

        const res = await updateDiscountCode(discountCodeId, payload);

        if (res.status) {
            toast.success(
                locale === "ar"
                    ? "تم التحديث بنجاح"
                    : locale === "en"
                        ? "Updated successfully"
                        : "Bi serkeftî hate nûkirin"
            );
            setOpen(false);
        } else {
            toast.error(
                locale === "ar"
                    ? "حدث خطأ ما"
                    : locale === "en"
                        ? "Something went wrong"
                        : "Tiştek çewt çû"
            );
        }

        setLoading(false);
    };

    return (
        <Dialog open={open} onOpenChange={handleOpenChange}>
            <DialogTrigger asChild>
                <Button variant="link">
                    {cities.length === 0
                        ? t("all")
                        : `${cities.length} ${t("city")}`}
                </Button>
            </DialogTrigger>

            <DialogContent className="h-160 overflow-y-auto hide-scrollbar">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <div className="space-y-2">
                    {allCities.map((city) => {
                        // TODO: must test when I remove all cities
                        const checked = selectedCities.includes(city._id);

                        return (
                            <Button
                                key={city._id}
                                variant="ghost"
                                type="button"
                                onClick={() => handleToggle(city._id)}
                                className={`flex justify-between items-center w-full border px-3 py-2 rounded-md ${checked
                                    ? "bg-primary/10 border-primary"
                                    : ""
                                    }`}
                            >
                                {locale === "ar" ? city.nameAr : locale === "en" ? city.nameEn : city.nameKu}
                                {checked && <Check className="size-4" />}
                            </Button>
                        );
                    })}
                </div>
                <Button onClick={handleSave} className="mt-4 w-full" disabled={loading}>
                    {loading ?
                        <Spinner />
                        :
                        t("save")
                    }
                </Button>
            </DialogContent>
        </Dialog>
    );
}