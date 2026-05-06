"use client";

import { useState } from "react";
import { useForm, Controller } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { toast } from "sonner";
import { useTranslations } from "next-intl";

import { Button } from "@/components/ui/button";
import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogFooter,
    DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Spinner } from "@/components/ui/spinner";
import { DropdownMenuItem } from "@/components/ui/dropdown-menu";

import {
    Field,
    FieldLabel,
    FieldDescription,
    FieldError,
} from "@/components/ui/field";

import { updateDiscountCode } from "@/lib/actions";
import { UpdateDiscountCodeType } from "@/schemas/schemas";
import { DiscountCode } from "@/types/types";

interface Props {
    discountCodeId: string;
    initialData: DiscountCode;
}

export default function UpdateDiscountCodeDialog({
    discountCodeId,
    initialData,
}: Props) {
    const [open, setOpen] = useState(false);

    const t = useTranslations("discountCodePage.updateDiscountCode");
    const tFields = useTranslations("discountCodePage.updateDiscountCode.fields");
    const tActions = useTranslations("discountCodePage.updateDiscountCode.actions");
    const [discountMode, setDiscountMode] = useState<"amount" | "percentage">(
        initialData.percentageDiscount > 0 ? "percentage" : "amount"
    );

    /* ---------------- Schema  ---------------- */

    const UpdateScalarSchema = z.object({
        discountAmount: z
            .number()
            .min(0),
        percentageDiscount: z
            .number()
            .min(0)
            .max(100, tFields("percentageDiscount.maxError")),
        numberOfUsers: z
            .number()
            .min(0, tFields("numberOfUsers.minError")),
        maxTrips: z
            .number()
            .min(1, tFields("maxTrips.minError")),
        minimum: z
            .number()
            .min(0, tFields("minimum.minError")),
        expiredAt: z.date().optional(),
    })
        .refine(
            (data) => data.discountAmount > 0 || data.percentageDiscount > 0,
            {
                message: tFields("discountAmount.minError"),
                path: ["discountAmount"],
            }
        );

    type FormValues = z.infer<typeof UpdateScalarSchema>;

    const form = useForm<FormValues>({
        resolver: zodResolver(UpdateScalarSchema),
        defaultValues: {
            discountAmount: initialData.discountAmount ?? 0,
            percentageDiscount: initialData.percentageDiscount ?? 0,
            numberOfUsers: initialData.numberOfUsers,
            maxTrips: initialData.maxTrips,
            minimum: initialData.minimum,
            expiredAt: initialData.expiredAt
                ? new Date(initialData.expiredAt)
                : undefined,
        },
    });

    const onSubmit = async (data: FormValues) => {
        const payload: UpdateDiscountCodeType = Object.fromEntries(
            Object.entries(data).filter(([, value]) => value !== undefined)
        );

        if (Object.keys(payload).length === 0) {
            toast.info(tActions("noChanges"));
            return;
        }

        const res = await updateDiscountCode(discountCodeId, payload);

        if (res.status) {
            toast.success(tActions("success"));
            setOpen(false);
        } else {
            toast.error(tActions("error"));
        }
    };

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <DropdownMenuItem onSelect={(e) => e.preventDefault()}>
                    {t("edit")}
                </DropdownMenuItem>
            </DialogTrigger>

            <DialogContent className="max-w-md">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <div className="flex gap-2">
                    <Button
                        type="button"
                        variant={discountMode === "amount" ? "default" : "outline"}
                        onClick={() => {
                            setDiscountMode("amount");
                            form.setValue("percentageDiscount", 0);
                        }}
                    >
                        {tFields("fixed")}
                    </Button>

                    <Button
                        type="button"
                        variant={discountMode === "percentage" ? "default" : "outline"}
                        onClick={() => {
                            setDiscountMode("percentage");
                            form.setValue("discountAmount", 0);
                        }}
                    >
                        {tFields("percentage")}
                    </Button>
                </div>

                <form
                    onSubmit={form.handleSubmit(onSubmit)}
                    className="space-y-5"
                >
                    {/* Discount Amount */}
                    {discountMode === "amount" && (
                        <Controller
                            name="discountAmount"
                            control={form.control}
                            render={({ field, fieldState }) => (
                                <Field data-invalid={fieldState.invalid}>
                                    <FieldLabel>
                                        {tFields("discountAmount.label")}
                                    </FieldLabel>

                                    <Input
                                        type="number"
                                        value={field.value ?? ""}
                                        onChange={(e) =>
                                            field.onChange(
                                                e.target.value === ""
                                                    ? 0
                                                    : Number(e.target.value)
                                            )
                                        }
                                    />

                                    <FieldDescription>
                                        {tFields("discountAmount.description")}
                                    </FieldDescription>

                                    {fieldState.invalid && (
                                        <FieldError errors={[fieldState.error]} />
                                    )}
                                </Field>
                            )}
                        />
                    )}

                    {/* Discount Percentage */}
                    {discountMode === "percentage" && (
                        <Controller
                            name="percentageDiscount"
                            control={form.control}
                            render={({ field, fieldState }) => (
                                <Field data-invalid={fieldState.invalid}>
                                    <FieldLabel>
                                        {tFields("percentageDiscount.label")}
                                    </FieldLabel>

                                    <Input
                                        type="number"
                                        value={field.value ?? ""}
                                        onChange={(e) =>
                                            field.onChange(
                                                e.target.value === ""
                                                    ? 0
                                                    : Number(e.target.value)
                                            )
                                        }
                                    />

                                    <FieldDescription>
                                        {tFields("percentageDiscount.description")}
                                    </FieldDescription>

                                    {fieldState.invalid && (
                                        <FieldError errors={[fieldState.error]} />
                                    )}
                                </Field>
                            )}
                        />
                    )}


                    {/* Max Trips */}
                    <Controller
                        name="maxTrips"
                        control={form.control}
                        render={({ field, fieldState }) => (
                            <Field data-invalid={fieldState.invalid}>
                                <FieldLabel>
                                    {tFields("maxTrips.label")}
                                </FieldLabel>
                                <Input
                                    type="number"
                                    value={field.value ?? ""}
                                    onChange={(e) =>
                                        field.onChange(
                                            e.target.value === ""
                                                ? undefined
                                                : Number(e.target.value)
                                        )
                                    }
                                    aria-invalid={fieldState.invalid}
                                />
                                {fieldState.invalid && (
                                    <FieldError errors={[fieldState.error]} />
                                )}
                            </Field>
                        )}
                    />

                    {/* Minimum */}
                    <Controller
                        name="minimum"
                        control={form.control}
                        render={({ field, fieldState }) => (
                            <Field data-invalid={fieldState.invalid}>
                                <FieldLabel>
                                    {tFields("minimum.label")}
                                </FieldLabel>
                                <Input
                                    type="number"
                                    value={field.value ?? ""}
                                    onChange={(e) =>
                                        field.onChange(
                                            e.target.value === ""
                                                ? undefined
                                                : Number(e.target.value)
                                        )
                                    }
                                    aria-invalid={fieldState.invalid}
                                />
                                {fieldState.invalid && (
                                    <FieldError errors={[fieldState.error]} />
                                )}
                            </Field>
                        )}
                    />

                    {/* Number Of Users */}
                    <Controller
                        name="numberOfUsers"
                        control={form.control}
                        render={({ field, fieldState }) => (
                            <Field data-invalid={fieldState.invalid}>
                                <FieldLabel>
                                    {tFields("numberOfUsers.label")}
                                </FieldLabel>
                                <Input
                                    type="number"
                                    value={field.value ?? ""}
                                    onChange={(e) =>
                                        field.onChange(
                                            e.target.value === ""
                                                ? undefined
                                                : Number(e.target.value)
                                        )
                                    }
                                    aria-invalid={fieldState.invalid}
                                />
                                {fieldState.invalid && (
                                    <FieldError errors={[fieldState.error]} />
                                )}
                            </Field>
                        )}
                    />

                    {/* Expiration Date */}
                    <Controller
                        name="expiredAt"
                        control={form.control}
                        render={({ field, fieldState }) => (
                            <Field data-invalid={fieldState.invalid}>
                                <FieldLabel>
                                    {tFields("expiredAt.label")}
                                </FieldLabel>
                                <Input
                                    type="date"
                                    value={
                                        field.value
                                            ? new Date(field.value)
                                                .toISOString()
                                                .split("T")[0]
                                            : ""
                                    }
                                    onChange={(e) =>
                                        field.onChange(
                                            e.target.value
                                                ? new Date(e.target.value)
                                                : undefined
                                        )
                                    }
                                    aria-invalid={fieldState.invalid}
                                />
                                {fieldState.invalid && (
                                    <FieldError errors={[fieldState.error]} />
                                )}
                            </Field>
                        )}
                    />

                    <DialogFooter>
                        <Button
                            type="submit"
                            disabled={form.formState.isSubmitting}
                        >
                            {form.formState.isSubmitting ? (
                                <Spinner />
                            ) : (
                                tActions("save")
                            )}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}