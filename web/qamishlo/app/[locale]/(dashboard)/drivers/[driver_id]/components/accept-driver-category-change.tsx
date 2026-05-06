"use client";

import { DropdownMenuItem } from "@/components/ui/dropdown-menu";
import { acceptDriverChangeCategory } from "@/lib/actions";
import { Driver } from "@/types/types";
import { useTranslations } from "next-intl";
import { toast } from "sonner";

export function AcceptDriverCategoryChange({ driver }: { driver: Driver }) {
    const t = useTranslations("driversPage.driver_dropdown");

    const handleAccept = async () => {
        const res = await acceptDriverChangeCategory(driver._id);

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