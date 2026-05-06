"use client";

import { useState } from "react";
import { Driver } from "@/types/types";
import { rejectDriver } from "@/lib/actions";
import { toast } from "sonner";

import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogFooter,
} from "@/components/ui/dialog";

import {
    DropdownMenuItem,
} from "@/components/ui/dropdown-menu";

import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Check } from "lucide-react";
import { useTranslations } from "next-intl";

interface RejectDriverDialogProps {
    driver: Driver;
}

const REJECT_FIELDS = [
    { labelKey: "fields.personalImage", value: "personalImage" },
    { labelKey: "fields.personalCardImageFront", value: "personalCardImageFront" },
    { labelKey: "fields.personalCardImageBack", value: "personalCardImageBack" },
    { labelKey: "fields.carImage", value: "carImage" },
    { labelKey: "fields.carPlateNumber", value: "carPlateNumber" },
    { labelKey: "fields.carName", value: "carName" },
];

export function RejectDriverDialog({ driver }: RejectDriverDialogProps) {
    const [open, setOpen] = useState(false);
    const [step, setStep] = useState<number>(driver.registrationStep);
    const [fieldToUpdate, setFieldToUpdate] = useState<string>("");
    const [message, setMessage] = useState("");
    const [loading, setLoading] = useState(false);
    const t = useTranslations("driversPage.driver_dropdown.reject_dialog")

    const handleReject = async () => {
        if (!fieldToUpdate) {
            toast.error("Please select a field");
            return;
        }

        if (!message) {
            toast.error("Please write a rejection reason");
            return;
        }

        setLoading(true);

        const res = await rejectDriver(
            driver._id,
            step,
            fieldToUpdate,
            message
        );

        if (res.status) {
            toast.success(res.message);
            setOpen(false);
            setMessage("");
            setFieldToUpdate("");
            setStep(1);
        } else {
            toast.error(res.message);
        }

        setLoading(false);
    };

    return (
        <>
            {/* Dropdown Item */}
            <DropdownMenuItem
                className="text-destructive"
                onSelect={(e) => e.preventDefault()}
                onClick={() => setOpen(true)}
            >
                {t("trigger")}
            </DropdownMenuItem>

            {/* Dialog */}
            <Dialog open={open} onOpenChange={setOpen}>
                <DialogContent>
                    <DialogHeader>
                        <DialogTitle>{t("title")}</DialogTitle>
                    </DialogHeader>

                    <div className="space-y-6">

                        {/* Step Selection */}
                        <div>
                            <p className="text-sm font-medium mb-2">{t("select_step")}</p>
                            <div className="flex gap-2">
                                {[1, 2, 3].map((s) => (
                                    <Button
                                        key={s}
                                        type="button"
                                        variant={step === s ? "default" : "outline"}
                                        onClick={() => setStep(s)}
                                    >
                                        {s}
                                    </Button>
                                ))}
                            </div>
                        </div>

                        {/* Field Selection */}
                        <div>
                            <p className="text-sm font-medium mb-2">
                                {t("select_field_to_update")}
                            </p>

                            <div className="grid gap-2">
                                {REJECT_FIELDS.map((field) => {
                                    const selected = fieldToUpdate === field.value;

                                    return (
                                        <Button
                                            key={field.value}
                                            type="button"
                                            variant={selected ? "default" : "outline"}
                                            className="justify-between"
                                            onClick={() => setFieldToUpdate(field.value)}
                                        >
                                            {t(field.labelKey)}
                                            {selected && <Check className="size-4" />}
                                        </Button>
                                    );
                                })}
                            </div>
                        </div>

                        {/* Message */}
                        <div>
                            <p className="text-sm font-medium mb-2">
                                {t("message")}
                            </p>
                            <Textarea
                                value={message}
                                onChange={(e) => setMessage(e.target.value)}
                                placeholder="Write rejection reason..."
                            />
                        </div>

                    </div>

                    <DialogFooter>
                        <Button
                            variant="secondary"
                            onClick={() => setOpen(false)}
                        >
                            {t("cancel")}
                        </Button>

                        <Button
                            variant="destructive"
                            onClick={handleReject}
                            disabled={loading}
                        >
                            {loading ? "Rejecting..." : t("confirm")}
                        </Button>
                    </DialogFooter>
                </DialogContent>
            </Dialog>
        </>
    );
}