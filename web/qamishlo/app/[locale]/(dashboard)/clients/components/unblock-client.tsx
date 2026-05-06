"use client";

import { DropdownMenuItem } from "@/components/ui/dropdown-menu";
import { UnBlockUser } from "@/lib/actions";
import { useTranslations } from "next-intl";
import { toast } from "sonner";

interface UnblockClientDialogProps {
    userId: string;
}

export default function UnblockClientDialog({ userId }: UnblockClientDialogProps) {
    const t = useTranslations("unblock_client");
    const handleUnBlock = async () => {
        const res = await UnBlockUser(userId);
        if (res?.status) {
            toast.success(t("success"));
        } else {
            toast.error(t("error"));
        }
    };
    return (
        <DropdownMenuItem
            onClick={handleUnBlock}
        >
            {t("trigger")}
        </DropdownMenuItem>
    )
}