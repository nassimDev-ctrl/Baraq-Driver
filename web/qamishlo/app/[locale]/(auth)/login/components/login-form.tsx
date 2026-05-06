"use client";

import { Button } from "@/components/ui/button";
import { Field, FieldError, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import { Spinner } from "@/components/ui/spinner";
import { Link, useRouter } from "@/i18n/navigation";
import { login } from "@/lib/actions";
import waar_qamishlo_logo from "@/public/waar-qamishlo.png";
import { loginFormSchema, loginFormSchemaType } from "@/schemas/schemas";
import { zodResolver } from "@hookform/resolvers/zod";
import { useTranslations } from "next-intl";
import Image from "next/image";

import { Controller, useForm } from "react-hook-form";
import { toast } from "sonner";

export default function LoginForm() {
    const t = useTranslations("loginPage");
    const router = useRouter();
    const form = useForm({
        defaultValues: {
            email: "",
            password: "",
        },
        resolver: zodResolver(loginFormSchema)
    });
    async function onSubmit(values: loginFormSchemaType) {
        const res = await login(values);
        if (res.status) {
            toast.success(t("success"));
            router.push("/");
        } else {
            toast.error(res.message)
        }
        form.reset();
    }
    return (
        <form
            onSubmit={form.handleSubmit(onSubmit)}
            className="bg-muted m-auto w-full max-w-sm rounded-xl border shadow-md"
        >
            <div className="bg-card rounded-xl p-8 space-y-4">
                <div className="text-center">
                    <Link href={{ pathname: "/" }} className="mx-auto block w-fit">
                        <Image src={waar_qamishlo_logo} alt="waar_qamishlo_logo" width={80} height={80} />
                    </Link>
                    <h1 className="mt-4 text-xl font-semibold">
                        {t("Sign In to waar qamishlo")}
                    </h1>
                </div>
                {/* Email */}
                <Controller
                    name="email"
                    control={form.control}
                    rules={{ required: t("Email is required") }}
                    render={({ field, fieldState }) => (
                        <Field data-invalid={fieldState.invalid}>
                            <FieldLabel>{t("Email")}</FieldLabel>
                            <Input {...field} type="email" placeholder={t("enter email address")} />
                            {fieldState.error && (
                                <FieldError errors={[fieldState.error]} />
                            )}
                        </Field>
                    )}
                />
                {/* Password */}
                <Controller
                    name="password"
                    control={form.control}
                    rules={{ required: t("Password is required") }}
                    render={({ field, fieldState }) => (
                        <Field data-invalid={fieldState.invalid}>
                            <FieldLabel>{t("Password")}</FieldLabel>
                            <Input {...field} type="password" placeholder={t("enter your password")} />
                            {fieldState.error && (
                                <FieldError errors={[fieldState.error]} />
                            )}
                        </Field>
                    )}
                />
                <Field>
                    <Button type="submit" disabled={form.formState.isSubmitting} className="flex items-center">
                        {form.formState.isSubmitting ?
                            <>
                                <Spinner />
                            </>
                            :
                            t("Sign In")
                        }
                    </Button>
                </Field>
            </div>
        </form>
    )
}
