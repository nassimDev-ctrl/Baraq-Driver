"use client";

import { DropdownMenuItem } from "@/components/ui/dropdown-menu";
import { UnBlockUser } from "@/lib/actions";
import { useTranslations } from "next-intl";
import { toast } from "sonner";

interface UnblockClientDialogProps {
    driverId: string;
}

export default function UnblockDriverDialog({ driverId }: UnblockClientDialogProps) {
    const t = useTranslations("driversPage.UnblockDriver");
    const handleUnBlock = async () => {
        const res = await UnBlockUser(driverId);
        if (res?.status) {
            toast.success(t("success"));
        } else {
            toast.error(t("error"))
        }
    };
    return (
        <DropdownMenuItem
            onClick={handleUnBlock}
        >
            {t("action")}
        </DropdownMenuItem>
    )
}