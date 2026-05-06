"use client";

import { Button } from "@/components/ui/button";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { ChevronDown } from "lucide-react";
import { Driver } from "@/types/types";
import { useTranslations } from "next-intl";
import { FinalDriverStatus } from "../../components/drivers-columns";
import { AcceptAction } from "./accept-driver-actions";
import { RejectDriverDialog } from "./reject-driver";
import { AcceptDriverCategoryChange } from "./accept-driver-category-change";

interface UpdateDriverStatusProps {
    driver: Driver;
}

const getFinalStatus = (driver: Driver): FinalDriverStatus => {
    if (driver.isBlocked) return "blocked";
    if (driver.isFrozen) return "frozen";
    return driver.status as FinalDriverStatus;
};

export function UpdateDriverStatus({ driver }: UpdateDriverStatusProps) {
    const tStatus = useTranslations("driversPage.driver_status");

    const finalStatus = getFinalStatus(driver);

    return (
        <DropdownMenu>
            <DropdownMenuTrigger asChild>
                <Button variant="secondary" className="gap-2">
                    {tStatus(finalStatus)}
                    <ChevronDown className="size-4" />
                </Button>
            </DropdownMenuTrigger>

            <DropdownMenuContent align="end">
                {finalStatus === "change-sub-category" ? (
                    <AcceptDriverCategoryChange driver={driver} />
                ) : (
                    <AcceptAction driver={driver} />
                )}


                <RejectDriverDialog driver={driver} />
            </DropdownMenuContent>
        </DropdownMenu>
    );
}