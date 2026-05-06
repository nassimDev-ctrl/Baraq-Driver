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
import { Commission } from "@/types/types";
import { updateMinTripPrice } from "@/lib/actions";

interface UpdateMinTripPriceType {
    minPriceOfTrip: number;
}

interface UpdateMinTripPriceProps {
    commission: Commission;
}

export default function UpdateMinTripPrice({
    commission,
}: UpdateMinTripPriceProps) {
    const t = useTranslations("commission.minTripPrice");
    const tSYP = useTranslations("currency");
    const [open, setOpen] = useState(false);
    const { register, handleSubmit, reset, formState } =
        useForm<UpdateMinTripPriceType>({
            defaultValues: {
                minPriceOfTrip: commission.minPriceOfTrip,
            },
        });

    const onSubmit = async (data: UpdateMinTripPriceType) => {
        if (data.minPriceOfTrip < 0) {
            toast.error(t("minPriceError"));
            return;
        }

        const res = await updateMinTripPrice(commission._id, data.minPriceOfTrip);

        if (res.status) {
            toast.success(res.message ?? t("success"));
            setOpen(false);
            reset(data);
        } else {
            toast.error(res.message ?? t("error"));
        }
    };

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <Button variant="outline" size="sm" className="flex items-center gap-2">
                    {t("minPrice")}: {commission.minPriceOfTrip} {tSYP("SYP")}
                    <ChevronDown className="w-4 h-4" />
                </Button>
            </DialogTrigger>

            <DialogContent className="sm:max-w-100">
                <DialogHeader>
                    <DialogTitle>{t("updateMinPriceTitle")}</DialogTitle>
                </DialogHeader>

                <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                    <div>
                        <label className="block text-sm font-medium mb-2">{t("minPriceLabel")}</label>
                        <Input
                            type="number"
                            step="0.01"
                            {...register("minPriceOfTrip", { required: true, valueAsNumber: true })}
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