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
import { Category } from "@/types/types";
import { UpdateDiscountCodeType } from "@/schemas/schemas";

interface CategoryViewProps {
    discountCodeId: string;
    categories: Category[];        // selected categories
    allCategories: Category[];     // all categories
}

export default function CategoryView({
    discountCodeId,
    categories,
    allCategories,
}: CategoryViewProps) {
    const [open, setOpen] = useState(false);
    const [loading, setLoading] = useState(false);
    const [wasAll, setWasAll] = useState(categories.length === 0);

    const t = useTranslations("discountCodePage.updateDiscountCodeCategories");
    const locale = useLocale();

    const [selectedCategories, setSelectedCategories] = useState<string[]>(
        categories?.map((c) => c._id)
    );

    // =========================
    // Handle Open
    // =========================
    const handleOpenChange = (isOpen: boolean) => {
        setOpen(isOpen);

        if (isOpen) {
            const isAll = categories.length === 0;
            setWasAll(isAll);

            if (isAll) {
                setSelectedCategories(allCategories?.map((c) => c._id));
            } else {
                setSelectedCategories(categories?.map((c) => c._id));
            }
        }
    };

    // =========================
    // Toggle
    // =========================
    const handleToggle = (id: string) => {
        setSelectedCategories((prev) =>
            prev.includes(id)
                ? prev.filter((c) => c !== id)
                : [...prev, id]
        );
    };

    // =========================
    // Save
    // =========================
    const handleSave = async () => {
        setLoading(true);

        const allIds = allCategories?.map((c) => c._id);
        const isNowAll = selectedCategories.length === allIds.length;

        let payload: UpdateDiscountCodeType = {};

        // CASE 1: was ALL
        if (wasAll) {
            if (!isNowAll) {
                payload = {
                    addCategory: selectedCategories,
                };
            }
        }

        // CASE 2: was SOME
        else {
            const originalIds = categories?.map((c) => c._id);

            if (isNowAll) {
                payload = {
                    removeCategory: originalIds,
                };
            } else {
                const addCategories = selectedCategories.filter(
                    (id) => !originalIds.includes(id)
                );

                const removeCategories = originalIds.filter(
                    (id) => !selectedCategories.includes(id)
                );

                payload = {
                    addCategory: addCategories.length
                        ? addCategories
                        : undefined,
                    removeCategory: removeCategories.length
                        ? removeCategories
                        : undefined,
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
                    {categories.length === 0
                        ? t("all")
                        : `${categories.length} ${t("category")}`}
                </Button>
            </DialogTrigger>

            <DialogContent className="h-160 overflow-y-auto hide-scrollbar">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <div className="space-y-2">
                    {allCategories?.map((cat) => {
                        const checked = selectedCategories.includes(cat._id);

                        return (
                            <Button
                                key={cat._id}
                                variant="ghost"
                                type="button"
                                onClick={() => handleToggle(cat._id)}
                                className={`flex justify-between items-center w-full border px-3 py-2 rounded-md ${checked
                                    ? "bg-primary/10 border-primary"
                                    : ""
                                    }`}
                            >
                                {locale === "ar"
                                    ? cat.nameAr
                                    : locale === "en"
                                        ? cat.nameEn
                                        : cat.nameKu}
                                {checked && <Check className="size-4" />}
                            </Button>
                        );
                    })}
                </div>

                <Button
                    onClick={handleSave}
                    className="mt-4 w-full"
                    disabled={loading}
                >
                    {loading ? <Spinner /> : t("save")}
                </Button>
            </DialogContent>
        </Dialog>
    );
}