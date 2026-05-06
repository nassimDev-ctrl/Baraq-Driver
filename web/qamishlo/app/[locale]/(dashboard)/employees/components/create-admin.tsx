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
import { Switch } from "@/components/ui/switch";
import { addAdmin } from "@/lib/actions";
import { createAdminSchema, CreateAdminSchemaType } from "@/schemas/schemas";
import { Role } from "@/types/types";
import { zodResolver } from "@hookform/resolvers/zod";
import { Plus } from "lucide-react";
import { useTranslations } from "next-intl";
import { useState } from "react";
import { useForm, useWatch } from "react-hook-form";
import { toast } from "sonner";

interface CreateAdminProps {
    roles: Role[];
}

export function CreateAdmin({ roles }: CreateAdminProps) {
    const [open, setOpen] = useState(false);
    const t = useTranslations("EmployeesPage.create_admin");
    const tError = useTranslations("EmployeesPage.create_admin.errors")
    const form = useForm<CreateAdminSchemaType>({
        resolver: zodResolver(createAdminSchema),
        defaultValues: {
            firstName: "",
            lastName: "",
            email: "",
            password: "",
            roles: [],
        },
    });

    const {
        register,
        handleSubmit,
        setValue,
        control,
        reset,
        formState: { errors, isSubmitting },
    } = form;

    const selectedRoles = useWatch({
        control,
        name: "roles",
        defaultValue: [] as string[],
    });

    const toggleRole = (id: string) => {
        setValue(
            "roles",
            selectedRoles.includes(id)
                ? selectedRoles.filter((r) => r !== id)
                : [...selectedRoles, id],
            { shouldValidate: true }
        );
    };


    const onSubmit = async (data: CreateAdminSchemaType) => {
        const res = await addAdmin(data);

        if (res?.status) {
            toast.success(t("success"));
        } else {
            toast.success(t("error"));
        }

        setOpen(false);
        reset();
    };

    return (
        <Dialog
            open={open}
            onOpenChange={(v) => {
                setOpen(v);
                if (!v) reset();
            }}
        >
            <DialogTrigger asChild>
                <Button size="sm">
                    <Plus />
                    {t("add_admin")}
                </Button>
            </DialogTrigger>

            <DialogContent className="max-w-md">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">

                    {/* First Name */}
                    <div className="space-y-1">
                        <Input
                            placeholder={t("first_name")}
                            {...register("firstName")}
                        />
                        {errors.firstName && (
                            <p className="text-sm text-destructive">
                                {tError("first_name_required")}
                            </p>
                        )}
                    </div>

                    {/* Last Name */}
                    <div className="space-y-1">
                        <Input
                            placeholder={t("last_name")}
                            {...register("lastName")}
                        />
                        {errors.lastName && (
                            <p className="text-sm text-destructive">
                                {tError("last_name_required")}
                            </p>
                        )}
                    </div>

                    {/* Email */}
                    <div className="space-y-1">
                        <Input
                            type="email"
                            placeholder={t("email")}
                            {...register("email")}
                        />
                        {errors.email && (
                            <p className="text-sm text-destructive">
                                {tError("invalid_email")}
                            </p>
                        )}
                    </div>

                    {/* Password */}
                    <div className="space-y-1">
                        <Input
                            type="password"
                            placeholder={t("password")}
                            {...register("password")}
                        />
                        {errors.password && (
                            <p className="text-sm text-destructive">
                                {tError("weak_password")}
                            </p>
                        )}
                    </div>

                    {/* Roles */}
                    <div className="space-y-2">
                        <p className="text-sm font-medium">
                            {t("select_roles")}
                        </p>

                        <div className="grid grid-cols-1 gap-2 max-h-64 overflow-y-auto hide-scrollbar">
                            {roles.map((role) => {
                                const checked = selectedRoles.includes(role._id);

                                return (
                                    <div
                                        key={role._id}
                                        className="flex items-center justify-between rounded-lg border px-3 py-2"
                                    >
                                        <div>
                                            <p className="text-sm font-medium">
                                                {role.name}
                                            </p>
                                        </div>

                                        <Switch
                                            dir="ltr"
                                            checked={checked}
                                            onCheckedChange={() =>
                                                toggleRole(role._id)
                                            }
                                        />
                                    </div>
                                );
                            })}
                        </div>

                        {errors.roles && (
                            <p className="text-sm text-destructive">
                                {tError("select_role")}
                            </p>
                        )}
                    </div>


                    <DialogFooter>
                        <Button
                            type="button"
                            variant="secondary"
                            onClick={() => {
                                reset();
                                setOpen(false);
                            }}
                        >
                            {t("cancel")}
                        </Button>

                        <Button type="submit" disabled={isSubmitting}>
                            {isSubmitting ? <Spinner /> :
                                t("create")}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}
