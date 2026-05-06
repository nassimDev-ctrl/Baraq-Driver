"use client";

import { useState } from "react";
import { Controller, useForm, useWatch } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { useTranslations, useLocale } from "next-intl";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Spinner } from "@/components/ui/spinner";
import { Check, Plus } from "lucide-react";
import { toast } from "sonner";

import { PostNotificationSchema, PostNotificationSchemaType } from "@/schemas/schemas";
import { postNotification } from "@/lib/actions";
import { Category, City } from "@/types/types";

interface NotifyDialogProps {
    cities: City[];
    categories: Category[];
}

export default function NotifyDialog({ cities, categories }: NotifyDialogProps) {
    const t = useTranslations("notifyDialog");
    const locale = useLocale();
    const [open, setOpen] = useState(false);

    const form = useForm<PostNotificationSchemaType>({
        resolver: zodResolver(PostNotificationSchema),
        defaultValues: {
            titleAr: "",
            titleEn: "",
            titleKu: "",
            messageAr: "",
            messageEn: "",
            messageKu: "",
            target: "all",
            cities: [],
            categories: [],
        },
    });

    const { control, register, handleSubmit, reset, formState: { errors, isSubmitting } } = form;

    const selectedTarget = useWatch({
        control,
        name: "target",
    });

    const onSubmit = async (data: PostNotificationSchemaType) => {
        const res = await postNotification(data);
        if (res.status) {
            toast.success("Notification sent successfully");
            reset();
            setOpen(false);
        } else {
            toast.error(res.message);
        }
    };

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <Button>{t("openButton")} <Plus className="ml-2 size-4" /></Button>
            </DialogTrigger>

            <DialogContent className="max-w-md max-h-[85vh] overflow-y-auto space-y-6">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                    {/* TITLE */}
                    <div className="space-y-2">
                        <Input placeholder={t("form.titleAr.placeholder")} {...register("titleAr")} />
                        {errors.titleAr && <p className="text-sm text-destructive">{t(errors.titleAr.message as string)}</p>}

                        <Input placeholder={t("form.titleEn.placeholder")} {...register("titleEn")} />
                        {errors.titleEn && <p className="text-sm text-destructive">{t(errors.titleEn.message as string)}</p>}

                        <Input placeholder={t("form.titleKu.placeholder")} {...register("titleKu")} />
                        {errors.titleKu && <p className="text-sm text-destructive">{t(errors.titleKu.message as string)}</p>}
                    </div>

                    {/* MESSAGE */}
                    <div className="space-y-2">
                        <Textarea placeholder={t("form.messageAr.placeholder")} {...register("messageAr")} />
                        {errors.messageAr && <p className="text-sm text-destructive">{t(errors.messageAr.message as string)}</p>}

                        <Textarea placeholder={t("form.messageEn.placeholder")} {...register("messageEn")} />
                        {errors.messageEn && <p className="text-sm text-destructive">{t(errors.messageEn.message as string)}</p>}

                        <Textarea placeholder={t("form.messageKu.placeholder")} {...register("messageKu")} />
                        {errors.messageKu && <p className="text-sm text-destructive">{t(errors.messageKu.message as string)}</p>}
                    </div>

                    {/* TARGET */}
                    <Controller
                        control={control}
                        name="target"
                        render={({ field }) => (
                            <div className="space-y-2">
                                <p className="text-sm font-medium">{t("form.target.label")}</p>
                                <div className="grid grid-cols-3 gap-2">
                                    {["all", "drivers", "clients"].map((value) => (
                                        <button
                                            key={value}
                                            type="button"
                                            onClick={() => field.onChange(value)}
                                            className={`rounded-lg border px-3 py-2 text-sm ${field.value === value ? "border-primary bg-primary/10" : "border-muted"}`}
                                        >
                                            {t(`form.target.${value}`)}
                                        </button>
                                    ))}
                                </div>
                            </div>
                        )}
                    />

                    {/* CITIES */}
                    <Controller
                        control={control}
                        name="cities"
                        render={({ field }) => (
                            <div className="space-y-2">
                                <p className="text-sm font-medium">{t("form.cities.label")}</p>
                                <div className="grid grid-cols-2 gap-2">
                                    {cities.map(city => {
                                        const checked = field.value?.includes(city._id);
                                        return (
                                            <button
                                                key={city._id}
                                                type="button"
                                                onClick={() =>
                                                    checked
                                                        ? field.onChange(field.value?.filter(id => id !== city._id))
                                                        : field.onChange([...(field.value || []), city._id])
                                                }
                                                className={`flex justify-between rounded-lg border px-3 py-2 text-sm ${checked ? "border-primary bg-primary/10" : "border-muted"}`}
                                            >
                                                {locale === "ar" ? city.nameAr : locale === "en" ? city.nameEn : city.nameKu}
                                                {checked && <Check className="size-4" />}
                                            </button>
                                        );
                                    })}
                                </div>
                            </div>
                        )}
                    />

                    {/* CATEGORIES */}
                    {selectedTarget === "drivers" && <Controller
                        control={control}
                        name="categories"
                        render={({ field }) => (
                            <div className="space-y-2">
                                <p className="text-sm font-medium">{t("form.categories.label")}</p>
                                <div className="grid grid-cols-2 gap-2">
                                    {categories.map(cat => {
                                        const selected = field.value?.includes(cat._id);
                                        return (
                                            <button
                                                key={cat._id}
                                                type="button"
                                                onClick={() =>
                                                    selected
                                                        ? field.onChange(field.value?.filter(id => id !== cat._id))
                                                        : field.onChange([...(field.value || []), cat._id])
                                                }
                                                className={`flex justify-between rounded-lg border px-3 py-2 text-sm ${selected ? "border-primary bg-primary/10" : "border-muted"}`}
                                            >
                                                {locale === "ar" ? cat.nameAr : locale === "en" ? cat.nameEn : cat.nameKu}
                                                {selected && <Check className="size-4" />}
                                            </button>
                                        );
                                    })}
                                </div>
                            </div>
                        )}
                    />}

                    <DialogFooter>
                        <Button type="button" variant="secondary" onClick={() => { reset(); setOpen(false); }}>
                            {t("actions.cancel")}
                        </Button>
                        <Button type="submit" disabled={isSubmitting}>
                            {isSubmitting ? <Spinner /> : t("actions.send")}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}