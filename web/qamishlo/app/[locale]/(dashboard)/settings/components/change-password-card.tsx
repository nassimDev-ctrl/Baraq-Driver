"use client"

import { zodResolver } from "@hookform/resolvers/zod"
import { useTranslations } from "next-intl"
import { Controller, useForm } from "react-hook-form"
import { toast } from "sonner"

import { Button } from "@/components/ui/button"
import {
    Field,
    FieldError,
    FieldGroup,
    FieldLabel,
} from "@/components/ui/field"
import { Input } from "@/components/ui/input"
import { Spinner } from "@/components/ui/spinner"
import { UpdateAdminPasswordSchema, UpdateAdminPasswordSchemaType } from "@/schemas/schemas"
import { updateAdminPassword } from "@/lib/actions"

export default function ChangePasswordCard() {
    const t = useTranslations("settingsPage.security")

    const form = useForm<UpdateAdminPasswordSchemaType>({
        resolver: zodResolver(UpdateAdminPasswordSchema),
        defaultValues: {
            currentPassword: "",
            newPassword: "",
            confirmPassword: "",
        },
    })

    async function onSubmit(data: UpdateAdminPasswordSchemaType) {
        try {
            const res = await updateAdminPassword(data.newPassword);
            if (res.status) {
                toast.success("Password updated successfully")
            }
        } catch {
            toast.error("Something went wrong")
        }
        form.reset()
    }

    return (
        <div className="w-full max-w-lg mx-auto">
            <form
                id="change-password-form"
                onSubmit={form.handleSubmit(onSubmit)}
                className="space-y-4"
            >
                {/* Fields */}
                <FieldGroup className="space-y-0">
                    <Controller
                        name="currentPassword"
                        control={form.control}
                        render={({ field, fieldState }) => (
                            <Field data-invalid={fieldState.invalid}>
                                <FieldLabel htmlFor="current-password">
                                    {t("currentPassword")}
                                </FieldLabel>
                                <Input
                                    {...field}
                                    id="current-password"
                                    type="password"
                                    aria-invalid={fieldState.invalid}
                                    className="h-11"
                                />
                                {fieldState.invalid && (
                                    <FieldError errors={[fieldState.error]} />
                                )}
                            </Field>
                        )}
                    />

                    <Controller
                        name="newPassword"
                        control={form.control}
                        render={({ field, fieldState }) => (
                            <Field data-invalid={fieldState.invalid}>
                                <FieldLabel htmlFor="new-password">
                                    {t("newPassword")}
                                </FieldLabel>
                                <Input
                                    {...field}
                                    id="new-password"
                                    type="password"
                                    aria-invalid={fieldState.invalid}
                                    className="h-11"
                                />
                                {fieldState.invalid && (
                                    <FieldError errors={[fieldState.error]} />
                                )}
                            </Field>
                        )}
                    />

                    <Controller
                        name="confirmPassword"
                        control={form.control}
                        render={({ field, fieldState }) => (
                            <Field data-invalid={fieldState.invalid}>
                                <FieldLabel htmlFor="confirm-password">
                                    {t("confirmPassword")}
                                </FieldLabel>
                                <Input
                                    {...field}
                                    id="confirm-password"
                                    type="password"
                                    aria-invalid={fieldState.invalid}
                                    className="h-11"
                                />
                                {fieldState.invalid && (
                                    <FieldError errors={[fieldState.error]} />
                                )}
                            </Field>
                        )}
                    />
                </FieldGroup>

                {/* Actions */}
                <div className="flex justify-end gap-3 pt-2">
                    <Button
                        type="submit"
                        disabled={form.formState.isSubmitting}
                    >
                        {form.formState.isSubmitting
                            ? <Spinner />
                            : t("changePassword")}
                    </Button>
                </div>
            </form>
        </div>
    )
}