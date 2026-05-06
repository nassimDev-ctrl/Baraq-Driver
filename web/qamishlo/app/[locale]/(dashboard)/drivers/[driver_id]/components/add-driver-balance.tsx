"use client";

import { useEffect, useState } from "react";
import { useForm } from "react-hook-form";
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
import { toast } from "sonner";
import { Driver } from "@/types/types";
import { addDriverBalance } from "@/lib/actions";
import { AddDriverBalance, AddDriverBalanceType } from "@/schemas/schemas";
import { Spinner } from "@/components/ui/spinner";
import { zodResolver } from "@hookform/resolvers/zod";
import { useTranslations } from "next-intl";

interface AddDriverBalanceDialogProps {
    driver: Driver;
}


export function AddDriverBalanceDialog({ driver }: AddDriverBalanceDialogProps) {
    const [open, setOpen] = useState(false);
    const t = useTranslations("driver_details.AddDriverBalanceDialog")
    const tSP = useTranslations("currency")
    const {
        register,
        handleSubmit,
        reset,
        formState: { isSubmitting, errors },
    } = useForm<AddDriverBalanceType>({
        resolver: zodResolver(AddDriverBalance),
        defaultValues: {
            amount: 0,
        },
    });

    useEffect(() => {
        if (open) {
            reset({ amount: 0 });
        }
    }, [open, reset]);

    const onSubmit = async (data: AddDriverBalanceType) => {
        if (!data.amount || data.amount <= 0) {
            toast.error(t("error_amount"));
            return;
        }

        const res = await addDriverBalance(driver._id, data.amount);

        if (res.status) {
            toast.success(t("success"));
            setOpen(false);
        } else {
            toast.error(res.message || t("error"));
        }
    };

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <Button variant="secondary">
                    {t("trigger")}
                </Button>
            </DialogTrigger>

            <DialogContent>
                <DialogHeader>
                    <DialogTitle>
                        {t("title")}
                    </DialogTitle>
                </DialogHeader>

                <div className="space-y-4">
                    {/* Current Balance */}
                    <div className="rounded-lg bg-muted p-3 text-sm">
                        <span className="font-medium">
                            {t("current_balance")}:
                        </span>{" "}
                        {driver.balance ?? 0} {tSP("SYP")}
                    </div>

                    {/* Form */}
                    <form
                        onSubmit={handleSubmit(onSubmit)}
                        className="space-y-4"
                    >
                        <div className="space-y-1">
                            <label className="text-sm font-medium">
                                {t("amount")} {tSP("SYP")}
                            </label>
                            <Input
                                type="number"
                                placeholder={t("form.amount.placeholder")}
                                {...register("amount", {
                                    valueAsNumber: true,
                                })}
                            />
                            {errors.amount && (
                                <p className="text-sm text-red-500">
                                    {/* {errors.amount.message} */}
                                    {t("form.amount.error_message")}
                                </p>
                            )}
                        </div>

                        <DialogFooter>
                            <Button
                                type="button"
                                variant="secondary"
                                onClick={() => setOpen(false)}
                                disabled={isSubmitting}
                            >
                                {t("cancel")}
                            </Button>

                            <Button
                                type="submit"
                                disabled={isSubmitting}
                            >
                                {isSubmitting
                                    ? <Spinner />
                                    : t("add_balance")}
                            </Button>
                        </DialogFooter>
                    </form>
                </div>
            </DialogContent>
        </Dialog>
    );
}