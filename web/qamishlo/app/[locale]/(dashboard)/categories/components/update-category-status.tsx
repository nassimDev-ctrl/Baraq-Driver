"use client";

import { Badge } from "@/components/ui/badge";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuGroup,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Check, ChevronDown, X } from "lucide-react";
import { useState } from "react";
import { useTranslations } from "next-intl";
import { toggleSubCategoryStatus } from "@/lib/actions";

interface UpdateStatusProps {
    id: string;
    status: boolean;
}

export default function UpdateCategoryStatus({
    id,
    status,
}: UpdateStatusProps) {
    const [open, setOpen] = useState(false);
    const t = useTranslations("category_status");

    const updateStatus = (status: boolean) => {
        toggleSubCategoryStatus(id, status);
        setOpen(false);
    };

    return (
        <DropdownMenu open={open} onOpenChange={setOpen}>
            <DropdownMenuTrigger asChild>
                <Badge
                    variant={status ? "default" : "secondary"}
                    className="flex items-center gap-2 cursor-pointer"
                >
                    <ChevronDown className="size-3" />
                    {status ? t("active") : t("inactive")}
                </Badge>
            </DropdownMenuTrigger>

            <DropdownMenuContent align="end" className="w-40">
                <DropdownMenuLabel className="text-xs text-muted-foreground">
                    {t("status")}
                </DropdownMenuLabel>

                <DropdownMenuSeparator />

                <DropdownMenuGroup>
                    <DropdownMenuItem
                        onClick={() => updateStatus(true)}
                        disabled={status}
                        className="flex items-center gap-2"
                    >
                        <Check className="size-4 text-green-600" />
                        {t("active")}
                    </DropdownMenuItem>

                    <DropdownMenuItem
                        onClick={() => updateStatus(false)}
                        disabled={!status}
                        className="flex items-center gap-2"
                    >
                        <X className="size-4 text-destructive" />
                        {t("inactive")}
                    </DropdownMenuItem>
                </DropdownMenuGroup>
            </DropdownMenuContent>
        </DropdownMenu>
    );
}