"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useTranslations } from "next-intl";
import { useState } from "react";
import { Controller, useForm } from "react-hook-form";

import {
    Dialog,
    DialogContent,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialog";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { toast } from "sonner";

import {
    UpdateClientNumberSchema,
    UpdateClientNumberSchemaType,
} from "@/schemas/schemas";

import { DropdownMenuItem } from "@/components/ui/dropdown-menu";
import { updateClientNumber } from "@/lib/actions";

interface UpdateClientNumberProps {
    clientId: string;
}

export default function UpdateClientNumber({ clientId }: UpdateClientNumberProps) {
    const t = useTranslations("clientNumber");

    const [open, setOpen] = useState(false);

    const {
        control,
        handleSubmit,
        reset,
        formState: { errors, isSubmitting },
    } = useForm<UpdateClientNumberSchemaType>({
        resolver: zodResolver(UpdateClientNumberSchema),
        defaultValues: {
            phoneNumber: "",
        },
    });

    const onSubmit = async (data: UpdateClientNumberSchemaType) => {
        const res = await updateClientNumber(clientId, data.phoneNumber);

        if (res.status) {
            toast.success(t("success"));
            setOpen(false);
            reset();
        } else {
            toast.error(res.message ?? t("error"));
        }
    };

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <DropdownMenuItem
                    onSelect={(e) => {
                        e.preventDefault();
                        setOpen(true);
                    }
                    }
                >
                    {t("updateButton")}
                </DropdownMenuItem>
            </DialogTrigger>

            <DialogContent className="sm:max-w-100">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                    <div>
                        <label className="block text-sm font-medium mb-2">
                            {t("label")}
                        </label>

                        <Controller
                            name="phoneNumber"
                            control={control}
                            render={({ field }) => (
                                <Input
                                    type="tel"
                                    inputMode="numeric"
                                    placeholder="9639XXXXXXXX"
                                    {...field}
                                />
                            )}
                        />

                        {errors.phoneNumber && (
                            <p className="text-sm text-red-500 mt-1">
                                {errors.phoneNumber.message}
                            </p>
                        )}
                    </div>

                    <DialogFooter className="flex justify-end gap-2">
                        <Button
                            type="button"
                            variant="secondary"
                            onClick={() => setOpen(false)}
                        >
                            {t("cancel")}
                        </Button>

                        <Button type="submit" disabled={isSubmitting}>
                            {isSubmitting ? t("updating") : t("update")}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}