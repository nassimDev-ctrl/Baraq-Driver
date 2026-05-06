"use client";

import { Button } from "@/components/ui/button";
import {
    Dialog,
    DialogContent,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialog";
import { Spinner } from "@/components/ui/spinner";
import { updateDriverCategory } from "@/lib/actions";
import { Category } from "@/types/types";
import { Check } from "lucide-react";
import { useLocale, useTranslations } from "next-intl";
import { useState } from "react";
import { useForm, useWatch } from "react-hook-form";
import { toast } from "sonner";

interface Props {
    driverId: string;
    currentCategoryId: string;
    categories: Category[];
}

interface FormValues {
    categoryId: string;
}

export default function UpdateDriverCategory({
    driverId,
    currentCategoryId,
    categories,
}: Props) {
    const [open, setOpen] = useState(false);
    const locale = useLocale();
    const t = useTranslations("driver_details.updateDriverCategory");

    const form = useForm<FormValues>({
        defaultValues: {
            categoryId: currentCategoryId,
        },
    });

    const {
        handleSubmit,
        setValue,
        control,
        formState: { isSubmitting },
    } = form;

    const selectedCategory = useWatch({
        name: "categoryId",
        control,
    });

    const onSubmit = async (data: FormValues) => {
        if (!data.categoryId) {
            toast.error(t("selectCategoryError"));
            return;
        }

        const res = await updateDriverCategory(driverId, {
            categoryId: data.categoryId,
        });

        if (res.status) {
            toast.success(t("success"));
            setOpen(false);
        } else {
            toast.error(res.message);
        }
    };

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <Button>{t("openButton")}</Button>
            </DialogTrigger>

            <DialogContent className="max-w-lg max-h-[80vh] overflow-y-auto">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <form onSubmit={handleSubmit(onSubmit)} className="space-y-3">

                    {/* Categories */}
                    {categories.map((cat) => {
                        const selected = selectedCategory === cat._id;

                        return (
                            <button
                                key={cat._id}
                                type="button"
                                onClick={() =>
                                    setValue("categoryId", cat._id)
                                }
                                className={`flex justify-between items-center w-full rounded-lg border px-4 py-3 text-sm font-medium transition h-8 ${selected
                                    ? "border-primary bg-primary/10"
                                    : "border-muted hover:bg-muted/50"
                                    }`}
                            >
                                {locale === "ar"
                                    ? cat.nameAr
                                    : cat.nameEn}

                                {selected && (
                                    <Check className="size-4" />
                                )}
                            </button>
                        );
                    })}

                    <DialogFooter className="pt-4">
                        <Button
                            type="button"
                            variant="secondary"
                            onClick={() => setOpen(false)}
                        >
                            {t("cancel")}
                        </Button>

                        <Button type="submit" disabled={isSubmitting}>
                            {isSubmitting ? <Spinner /> : t("update")}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}