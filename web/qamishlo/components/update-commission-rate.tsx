"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { useTranslations } from "next-intl";
import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogFooter,
    DialogTrigger,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { ChevronDown } from "lucide-react";
import { toast } from "sonner";
import { UpdateCommissionPercentageType } from "@/schemas/schemas";
import { updateCommissionPercentage } from "@/lib/actions";
import { Commission } from "@/types/types";

interface UpdateCommissionRateProps {
    commission: Commission;
}

export default function UpdateCommissionRate({
    commission,
}: UpdateCommissionRateProps) {
    const t = useTranslations("commission");

    const [open, setOpen] = useState(false);
    const { register, handleSubmit, reset, formState } =
        useForm<UpdateCommissionPercentageType>({
            defaultValues: {
                commissionPercentage: commission.commissionPercentage,
            },
        });

    const onSubmit = async (data: UpdateCommissionPercentageType) => {
        if (
            data.commissionPercentage < 0 ||
            data.commissionPercentage > 100
        ) {
            toast.error(t("rangeError"));
            return;
        }

        const res = await updateCommissionPercentage(
            commission._id,
            data.commissionPercentage
        );

        if (res.status) {
            toast.success(t("success"));
            setOpen(false);
            reset(data);
        } else {
            toast.error(t("error"));
        }
    };

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <Button variant="outline" size="sm" className="flex items-center gap-2">
                    {t("commission")}: {commission.commissionPercentage}%
                    <ChevronDown className="w-4 h-4" />
                </Button>
            </DialogTrigger>

            <DialogContent className="sm:max-w-100">
                <DialogHeader>
                    <DialogTitle>{t("updateTitle")}</DialogTitle>
                </DialogHeader>

                <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                    <div>
                        <label className="block text-sm font-medium mb-2">{t("percentageLabel")}</label>
                        <Input
                            type="number"
                            step="0.1"
                            {...register("commissionPercentage", { required: true, valueAsNumber: true })}
                        />
                    </div>

                    <DialogFooter className="flex justify-end gap-2">
                        <Button type="button" variant="secondary" onClick={() => setOpen(false)}>
                            {t("cancel")}
                        </Button>
                        <Button type="submit" disabled={formState.isSubmitting}>
                            {formState.isSubmitting ? t("updating") : t("update")}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}