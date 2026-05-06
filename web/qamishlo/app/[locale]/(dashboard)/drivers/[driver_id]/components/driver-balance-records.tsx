"use client";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { BalanceOperation } from "@/types/types"
import { useTranslations } from "next-intl";
import { useState } from "react";

interface DriverBalanceDialogProps {
    operations: BalanceOperation[]
}

export function DriverBalanceDialog({
    operations,
}: DriverBalanceDialogProps) {
    const t = useTranslations("driver_details.driverBalance")
    const tSP = useTranslations("currency")
    const [open, setOpen] = useState(false);
    const driver = operations?.length ? operations[0].driverId : null
    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <Button variant="outline">{t("openButton")}</Button>
            </DialogTrigger>
            <DialogContent className="max-w-md h-160 max-h-160 rounded-2xl p-0">

                {/* Header */}
                <div className="p-6 border-b bg-muted/40">
                    <DialogHeader>
                        <DialogTitle>{t("title")}</DialogTitle>
                    </DialogHeader>
                </div>

                {/* Current Balance */}
                {driver && (
                    <div className="p-6 text-center border-b">
                        <p className="text-sm text-muted-foreground mb-2">
                            {t("currentBalance")}
                        </p>
                        <p className="text-3xl font-bold text-green-600">
                            {driver.balance.toLocaleString()} {tSP("SYP")}
                        </p>
                    </div>
                )}

                {/* Operations List */}
                <div className="max-h-100 overflow-y-auto p-6 space-y-4">

                    {operations.map((operation) => {
                        const isCharge = operation.operation === "charge"

                        return (
                            <div
                                key={operation._id}
                                className="flex items-center justify-between p-4 rounded-xl bg-muted/40 hover:bg-muted transition"
                            >
                                {/* Left Side */}
                                <div className="flex items-center gap-3 ">
                                    <div
                                        className={`w-2 h-10 rounded-full ${isCharge ? "bg-green-400" : "bg-red-500"
                                            }`}
                                    />

                                    <div>
                                        <p className="font-medium">
                                            {isCharge ? t("charge") : t("withdraw")}
                                        </p>
                                        <p className="text-xs text-muted-foreground">
                                            {new Date(operation.createdAt).toLocaleDateString()}
                                        </p>
                                    </div>
                                </div>

                                {/* Amount */}
                                <p
                                    className={`font-semibold ${isCharge ? "text-green-400" : "text-red-500"
                                        }`}
                                >
                                    {isCharge ? "+" : "-"}
                                    {operation.balance.toLocaleString()} {tSP("SYP")}
                                </p>
                            </div>
                        )
                    })}

                    {operations.length === 0 && (
                        <div className="text-center py-10 text-muted-foreground">
                            {t("noOperations")}
                        </div>
                    )}

                </div>

            </DialogContent>
        </Dialog>
    )
}