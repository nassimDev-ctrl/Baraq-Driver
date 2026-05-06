"use client";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import {
    Dialog,
    DialogContent,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialog";
import { Field, FieldError, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import { Spinner } from "@/components/ui/spinner";
import { Controller, useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { useTranslations } from "next-intl";
import { Plus } from "lucide-react";
import { toast } from "sonner";
import { CreateCitySchema, CreateCitySchemaType } from "@/schemas/schemas";
import { addCity } from "@/lib/actions";
import { useState } from "react";

export function CreateCity() {
    const t = useTranslations("createCity");
    const [open, setOpen] = useState(false);

    const form = useForm<CreateCitySchemaType>({
        defaultValues: { nameEn: "", nameAr: "", nameKu: "" },
        resolver: zodResolver(CreateCitySchema),
    });

    const onSubmit = async (values: CreateCitySchemaType) => {
        const res = await addCity(values);
        if (res.status) {
            toast.success(t("success"));
            form.reset();
            setOpen(false);
        } else {
            toast.error(res.message ?? t("error"));
        }
    };

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <Card className="border-2 border-dashed w-full h-full p-0 shadow-none hover:scale-105 cursor-pointer">
                    <CardContent className="p-6 h-full min-h-28 flex items-center justify-center">
                        <Plus className="size-10 text-foreground/80" />
                    </CardContent>
                </Card>
            </DialogTrigger>

            <DialogContent className="max-w-sm">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
                    {/* English Name */}
                    <Controller
                        name="nameEn"
                        control={form.control}
                        render={({ field, fieldState }) => (
                            <Field data-invalid={fieldState.invalid}>
                                <FieldLabel>{t("form.nameEn")}</FieldLabel>
                                <Input {...field} placeholder={t("form.nameEn")} />
                                {fieldState.error && (
                                    <FieldError errors={[{ message: t(fieldState.error.message!) }]} />
                                )}
                            </Field>
                        )}
                    />

                    {/* Arabic Name */}
                    <Controller
                        name="nameAr"
                        control={form.control}
                        render={({ field, fieldState }) => (
                            <Field data-invalid={fieldState.invalid}>
                                <FieldLabel>{t("form.nameAr")}</FieldLabel>
                                <Input {...field} placeholder={t("form.nameAr")} />
                                {fieldState.error && (
                                    <FieldError errors={[{ message: t(fieldState.error.message!) }]} />
                                )}
                            </Field>
                        )}
                    />

                    {/* Kurdish Name */}
                    <Controller
                        name="nameKu"
                        control={form.control}
                        render={({ field, fieldState }) => (
                            <Field data-invalid={fieldState.invalid}>
                                <FieldLabel>{t("form.nameKu")}</FieldLabel>
                                <Input {...field} placeholder={t("form.nameKu")} />
                                {fieldState.error && (
                                    <FieldError errors={[{ message: t(fieldState.error.message!) }]} />
                                )}
                            </Field>
                        )}
                    />

                    <DialogFooter className="pt-4">
                        <Button
                            type="button"
                            variant="secondary"
                            onClick={() => { form.reset(); setOpen(false); }}
                        >
                            {t("actions.cancel")}
                        </Button>

                        <Button type="submit" disabled={form.formState.isSubmitting}>
                            {form.formState.isSubmitting ? <Spinner /> : t("actions.create")}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}