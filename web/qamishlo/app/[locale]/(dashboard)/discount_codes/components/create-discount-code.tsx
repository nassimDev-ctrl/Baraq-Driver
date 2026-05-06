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
import { Input } from "@/components/ui/input";
import { Spinner } from "@/components/ui/spinner";
import { Check, Plus } from "lucide-react";
import { useState } from "react";
import { useForm, Controller } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { useLocale, useTranslations } from "next-intl";
import { toast } from "sonner";
import {
    CreateDiscountCodeSchema,
    CreateDiscountCodeSchemaType,
} from "@/schemas/schemas";
import { City } from "@/types/types";
import { createDiscountCode } from "@/lib/actions";

interface CreateDiscountCodeProps {
    cities: City[];
    // categories: Category[]; //removed for now
}

export default function CreateDiscountCode({
    cities,
    // categories, //*: removed for now
}: CreateDiscountCodeProps) {
    const t = useTranslations("discountCodePage.discountDialog");
    const locale = useLocale();
    const [open, setOpen] = useState(false);
    const [discountMode, setDiscountMode] = useState<"amount" | "percentage">("amount");

    const form = useForm({
        resolver: zodResolver(CreateDiscountCodeSchema),
        defaultValues: {
            discountAmount: 1,
            percentageDiscount: 0,
            numberOfUsers: 0,
            maxTrips: 1,
            minimum: 0,
            startAt: new Date(),
            expiredAt: new Date(),
            status: "active",
            // categories: []
        } satisfies CreateDiscountCodeSchemaType,
    } as const);

    const {
        register,
        control,
        handleSubmit,
        reset,
        formState: { errors, isSubmitting },
    } = form;

    const onSubmit = async (data: CreateDiscountCodeSchemaType) => {
        const res = await createDiscountCode(data);

        if (res.status) {
            toast.success(t("success"));
            reset();
            setOpen(false);
        } else {
            toast.error(t("error"));
        }
    };

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <Button>
                    {t("create")} <Plus className="ml-2 size-4" />
                </Button>
            </DialogTrigger>

            <DialogContent className="max-w-2xl h-160 overflow-y-auto hide-scrollbar">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                    <div className="flex gap-2 mb-2">
                        <Button
                            type="button"
                            variant={discountMode === "amount" ? "default" : "outline"}
                            onClick={() => setDiscountMode("amount")}
                        >
                            {t("form.fixed")}
                        </Button>

                        <Button
                            type="button"
                            variant={discountMode === "percentage" ? "default" : "outline"}
                            onClick={() => setDiscountMode("percentage")}
                        >
                            %
                        </Button>
                    </div>

                    {/* Discount */}
                    {discountMode === "amount" && (
                        <div>
                            <label className="block text-sm font-medium mb-1">
                                {t("form.discount")} ({t("sy")})
                            </label>

                            <Input
                                type="number"
                                {...register("discountAmount", {
                                    valueAsNumber: true,
                                    onChange: () => form.setValue("percentageDiscount", 0)
                                })}
                            />
                            {errors.discountAmount && (
                                <p className="text-sm text-destructive mt-1">
                                    {t(`errors.${errors.discountAmount.message}`)}
                                </p>
                            )}
                        </div>
                    )}

                    {/* Percentage Discount */}
                    {discountMode === "percentage" && (
                        <div>
                            <label className="block text-sm font-medium mb-1">
                                {t("form.percentage")} (%)
                            </label>

                            <Input
                                type="number"
                                {...register("percentageDiscount", {
                                    valueAsNumber: true,
                                    onChange: () => form.setValue("discountAmount", 0)
                                })}
                            />
                            {errors.percentageDiscount && (
                                <p className="text-sm text-destructive mt-1">
                                    {t(`errors.${errors.percentageDiscount.message}`)}
                                </p>
                            )}
                        </div>
                    )}

                    {/* Max Trips */}
                    <div>
                        <label className="block text-sm font-medium mb-1">
                            {t("form.trips")}
                        </label>
                        <Input
                            type="number"
                            {...register("maxTrips", {
                                valueAsNumber: true,
                            })}
                        />
                        {errors.maxTrips && (
                            <p className="text-sm text-destructive mt-1">
                                {t(`errors.${errors.maxTrips.message}`)}
                            </p>
                        )}
                    </div>

                    {/* Minimum */}
                    <div>
                        <label className="block text-sm font-medium mb-1">
                            {t("form.minimum")} ({t("sy")})
                        </label>
                        <Input
                            type="number"
                            {...register("minimum", {
                                valueAsNumber: true,
                            })}
                        />
                        {errors.minimum && (
                            <p className="text-sm text-destructive mt-1">
                                {t(`errors.${errors.minimum.message}`)}
                            </p>
                        )}
                    </div>

                    {/* Number of Users */}
                    <div>
                        <label className="block text-sm font-medium mb-1">
                            {t("form.numberOfUsers")}
                        </label>
                        <Input
                            type="number"
                            {...register("numberOfUsers", {
                                valueAsNumber: true,
                            })}
                        />
                        {errors.numberOfUsers && (
                            <p className="text-sm text-destructive mt-1">
                                {t(`errors.${errors.numberOfUsers.message}`)}
                            </p>
                        )}
                    </div>

                    {/* Dates */}
                    <div className="grid grid-cols-2 gap-4">
                        <div>
                            <label className="block text-sm font-medium mb-1">
                                {t("form.startAt")}
                            </label>
                            <Input type="date" {...register("startAt")} />
                            {errors.startAt && (
                                <p className="text-sm text-destructive mt-1">
                                    {t(`errors.${errors.startAt.message}`)}
                                </p>
                            )}
                        </div>

                        <div>
                            <label className="block text-sm font-medium mb-1">
                                {t("form.expiredAt")}
                            </label>
                            <Input type="date" {...register("expiredAt")} />
                            {errors.expiredAt && (
                                <p className="text-sm text-destructive mt-1">
                                    {t(`errors.${errors.expiredAt.message}`)}
                                </p>
                            )}
                        </div>
                    </div>

                    {/* Cities */}
                    <Controller
                        control={control}
                        name="cities"
                        render={({ field }) => (
                            <div>
                                <p className="font-medium mb-2">
                                    {t("form.cities.label")}
                                </p>

                                <p className="text-xs text-muted-foreground mb-2">
                                    {t("form.cities.helper")}
                                </p>

                                <div className="grid grid-cols-2 gap-2">
                                    {cities.map((city) => {
                                        const checked = field.value?.includes(city._id);

                                        return (
                                            <button
                                                type="button"
                                                key={city._id}
                                                onClick={() =>
                                                    checked
                                                        ? field.onChange(
                                                            field.value?.filter(
                                                                (id) => id !== city._id
                                                            )
                                                        )
                                                        : field.onChange([
                                                            ...(field.value || []),
                                                            city._id,
                                                        ])
                                                }
                                                className={`flex justify-between rounded-lg border px-3 py-2 text-sm ${checked
                                                    ? "border-primary bg-primary/10"
                                                    : "border-muted"
                                                    }`}
                                            >
                                                {locale === "ar"
                                                    ? city.nameAr
                                                    : locale === "en"
                                                        ? city.nameEn
                                                        : city.nameKu}

                                                {checked && <Check className="size-4" />}
                                            </button>
                                        );
                                    })}
                                </div>
                            </div>
                        )}
                    />

                    {/* Categories */}
                    {/* <Controller
                        control={control}
                        name="categories"
                        render={({ field }) => (
                            <div>
                                <p className="font-medium mb-2">
                                    {t("form.categories.label")}
                                </p>

                                <div className="grid grid-cols-2 gap-2">
                                    {categories.map((cat) => {
                                        const selected = field.value?.includes(cat._id);

                                        return (
                                            <button
                                                key={cat._id}
                                                type="button"
                                                onClick={() =>
                                                    selected
                                                        ? field.onChange(
                                                            field.value?.filter(
                                                                (id) => id !== cat._id
                                                            )
                                                        )
                                                        : field.onChange([
                                                            ...(field.value || []),
                                                            cat._id,
                                                        ])
                                                }
                                                className={`flex justify-between rounded-lg border px-3 py-2 text-sm ${selected
                                                    ? "border-primary bg-primary/10"
                                                    : "border-muted"
                                                    }`}
                                            >
                                                {locale === "ar"
                                                    ? cat.nameAr
                                                    : locale === "en"
                                                        ? cat.nameEn
                                                        : cat.nameKu}

                                                {selected && <Check className="size-4" />}
                                            </button>
                                        );
                                    })}
                                </div>

                                {errors.categories && (
                                    <p className="text-sm text-destructive mt-2">
                                        {t(`errors.${errors.categories.message}`)}
                                    </p>
                                )}
                            </div>
                        )}
                    /> */}
                    <DialogFooter>
                        <Button
                            type="button"
                            variant="secondary"
                            onClick={() => {
                                reset();
                                setOpen(false);
                            }}
                        >
                            {t("actions.cancel")}
                        </Button>

                        <Button type="submit" disabled={isSubmitting}>
                            {isSubmitting ? <Spinner /> : t("actions.create")}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}