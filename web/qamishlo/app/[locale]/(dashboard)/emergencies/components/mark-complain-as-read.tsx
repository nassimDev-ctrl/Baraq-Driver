"use client";

import { useState } from "react";
import { toast } from "sonner";
import { markComplainAsRead } from "@/lib/actions";
import { Button } from "@/components/ui/button";

import { Check } from "lucide-react";
import { Spinner } from "@/components/ui/spinner";
import { useTranslations } from "next-intl";
import { useRouter } from "@/i18n/navigation";

interface MarkComplainAsReadProps {
    complaintId: string;
}

export function MarkComplainAsRead({
    complaintId,
}: MarkComplainAsReadProps) {
    const t = useTranslations("complaints_columns");
    const [loading, setLoading] = useState(false);
    const router = useRouter();

    const handleMarkAsRead = async () => {
        setLoading(true);

        const res = await markComplainAsRead(complaintId);

        if (res.status) {
            toast.success(res.message);
            router.refresh();
        } else {
            toast.error(res.message);
        }

        setLoading(false);
    };

    return (
        <Button
            variant="secondary"
            size="sm"
            onClick={handleMarkAsRead}
            disabled={loading}
            className="w-full justify-start"
        >
            <Check className="size-4 mr-2" />
            {loading ? <Spinner /> : t("mark_as_read")}
        </Button>
    );
}