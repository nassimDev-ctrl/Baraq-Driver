"use client";

import { useState } from "react";
import { useForm, useWatch } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Permission } from "@/types/types";
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
import { Input } from "@/components/ui/input";
import { Switch } from "@/components/ui/switch";
import { Plus } from "lucide-react";
import { useTranslations } from "next-intl";
import { createGroupSchema, CreateGroupSchema } from "@/schemas/schemas";
// import { createNewGroup } from "@/lib/actions";
import { toast } from "sonner";
import { Spinner } from "@/components/ui/spinner";
import { createNewGroup } from "@/lib/actions";

interface CreateGroupProps {
    permissions: Permission[];
}

export function CreateGroup({ permissions }: CreateGroupProps) {
    const t = useTranslations("groups_dialog");
    const tPermissions = useTranslations("permissions");
    const [open, setOpen] = useState(false);

    const form = useForm<CreateGroupSchema>({
        resolver: zodResolver(createGroupSchema),
        defaultValues: {
            name: "",
            permissions: [],
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

    const selectedPermissions = useWatch({
        control,
        name: "permissions",
        defaultValue: [] as string[],
    });

    const togglePermission = (id: string) => {
        setValue(
            "permissions",
            selectedPermissions.includes(id)
                ? selectedPermissions.filter((p) => p !== id)
                : [...selectedPermissions, id],
            { shouldValidate: true }
        );
    };

    const onSubmit = async (data: CreateGroupSchema) => {
        const res = await createNewGroup(data.name, data.permissions);
        if (res?.status) {
            toast.success("created successfully");
        } else {
            toast.error("Failed to create group");
        }
        reset();
        setOpen(false);
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
                <Card className="border-2 border-dashed w-full h-full p-0 shadow-none hover:scale-105 cursor-pointer">
                    <CardContent className="p-6 h-full min-h-28 w-full flex items-center justify-center">
                        <Plus className="size-10 text-foreground/80" />
                    </CardContent>
                </Card>
            </DialogTrigger>

            <DialogContent className="max-w-md">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <form
                    onSubmit={handleSubmit(onSubmit)}
                    className="space-y-4"
                >
                    {/* Group name */}
                    <div className="space-y-1">
                        <Input
                            placeholder={t("form.name.placeholder")}
                            {...register("name")}
                        />
                        {errors.name && (
                            <p className="text-sm text-destructive">
                                {errors.name.message}
                            </p>
                        )}
                    </div>

                    {/* Permissions */}
                    <div className="space-y-2">
                        <p className="text-sm font-medium">
                            {t("form.permissions.title")}
                        </p>

                        <div className="grid grid-cols-1 gap-2 max-h-64 overflow-y-auto hide-scrollbar">
                            {permissions.map((permission) => {
                                const checked =
                                    selectedPermissions.includes(
                                        permission._id
                                    );

                                return (
                                    <div
                                        key={permission._id}
                                        className="flex items-center justify-between rounded-lg border px-3 py-2"
                                    >
                                        <span className="text-sm">
                                            {tPermissions(permission.name)}
                                        </span>

                                        <Switch
                                            dir="ltr"
                                            checked={checked}
                                            onCheckedChange={() =>
                                                togglePermission(permission._id)
                                            }
                                        />
                                    </div>
                                );
                            })}
                        </div>

                        {errors.permissions && (
                            <p className="text-sm text-destructive">
                                {errors.permissions.message}
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
                            {t("actions.cancel")}
                        </Button>

                        <Button type="submit" disabled={isSubmitting}>
                            {form.formState.isSubmitting ?
                                <>
                                    <Spinner />
                                </>
                                :
                                t("actions.create")
                            }
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}