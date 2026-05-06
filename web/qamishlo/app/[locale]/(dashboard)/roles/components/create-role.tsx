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
import { createRoleSchema, CreateRoleSchema } from "@/schemas/schemas";
import { Group } from "@/types/types";
import { zodResolver } from "@hookform/resolvers/zod";
import { Plus } from "lucide-react";
import { useState } from "react";
import { useForm, useWatch } from "react-hook-form";
import { toast } from "sonner";
import { createNewRole } from "@/lib/actions";
import { useTranslations } from "next-intl";

interface CreateRoleProps {
    groups: Group[];
}

export function CreateRole({ groups }: CreateRoleProps) {
    const [open, setOpen] = useState(false);
    const t = useTranslations("RolesPage.create_role");
    const tError = useTranslations("RolesPage.create_role.errors");

    const form = useForm<CreateRoleSchema>({
        resolver: zodResolver(createRoleSchema),
        defaultValues: {
            name: "",
            groups: [],
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

    const selectedGroups = useWatch({
        control,
        name: "groups",
        defaultValue: [] as string[],
    });

    const toggleGroup = (id: string) => {
        setValue(
            "groups",
            selectedGroups.includes(id)
                ? selectedGroups.filter((g) => g !== id)
                : [...selectedGroups, id],
            { shouldValidate: true }
        );
    };

    const onSubmit = async (data: CreateRoleSchema) => {
        const res = await createNewRole(data.name, data.groups);
        reset();
        setOpen(false);
        if (res?.status) {
            toast.success(t("success"));
        } else {
            toast.error(t("error"));
        }
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
                    {t("add_role")}
                </Button>
            </DialogTrigger>

            <DialogContent className="max-w-md">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">

                    {/* Role Name */}
                    <div className="space-y-1">
                        <Input
                            placeholder={t("role_name")}
                            {...register("name")}
                        />
                        {errors.name && (
                            <p className="text-sm text-destructive">
                                {tError("name_required")}
                            </p>
                        )}
                    </div>

                    {/* Groups */}
                    <div className="space-y-2">
                        <p className="text-sm font-medium">
                            {t("select_groups")}
                        </p>

                        <div className="grid grid-cols-1 gap-2 max-h-64 overflow-y-auto hide-scrollbar">
                            {groups?.map((group) => {
                                const checked =
                                    selectedGroups.includes(group._id);

                                return (
                                    <div
                                        key={group._id}
                                        className="flex items-center justify-between rounded-lg border px-3 py-2"
                                    >
                                        <div>
                                            <p className="text-sm font-medium">
                                                {group.name}
                                            </p>
                                        </div>

                                        <Switch
                                            dir="ltr"
                                            checked={checked}
                                            onCheckedChange={() =>
                                                toggleGroup(group._id)
                                            }
                                        />
                                    </div>
                                );
                            })}
                        </div>

                        {errors.groups && (
                            <p className="text-sm text-destructive">
                                {tError("select_group")}
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
                            {isSubmitting ? <Spinner /> : t("create")}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}
