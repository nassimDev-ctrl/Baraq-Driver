"use client";

import { DropdownMenuItem } from "@/components/ui/dropdown-menu";
import { acceptDriver } from "@/lib/actions";
import { toast } from "sonner";
import { Driver } from "@/types/types";
import { useTranslations } from "next-intl";

export function AcceptAction({ driver }: { driver: Driver }) {
    const t = useTranslations("driversPage.driver_dropdown")
    const handleAccept = async () => {
        const res = await acceptDriver(driver._id);

        if (res.status) {
            toast.success(res.message);
        } else {
            toast.error(res.message);
        }
    };

    return (
        <DropdownMenuItem onClick={handleAccept}>
            {t("accept")}
        </DropdownMenuItem>
    );
}