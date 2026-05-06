"use client";

import { Button } from "@/components/ui/button";
import { toggleCityStatus } from "@/lib/actions";
import { useTranslations } from "next-intl";
import { toast } from "sonner";

interface ToggleButtonProps {
    id: string;
    status: boolean;
}

export default function ToggleButton({ id, status }: ToggleButtonProps) {
    const tStatus = useTranslations("cities_status");
    const toggleStatus = async () => {
        const res = await toggleCityStatus(id, !status)
        if (res?.status) {
            toast.success(res.message)
        } else {
            toast.error(res?.message);
        }
    };
    return (
        <Button variant="secondary" className="w-full" onClick={toggleStatus}>
            {status ? tStatus("deactivate") : tStatus("activate")}
        </Button>
    )
}
