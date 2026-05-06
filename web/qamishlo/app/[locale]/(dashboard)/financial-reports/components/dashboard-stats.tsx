"use client";

import { DashboardStats } from "@/types/types";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { useTranslations } from "next-intl";

interface Props {
    data: DashboardStats;
}

export default function DashboardStatsCards({ data }: Props) {
    const t = useTranslations("financialReportsPage.dashboard");
    const tSYP = useTranslations("currency");

    const items = [
        { label: t("total_trips"), value: data.totalTrips },
        { label: t("gross_revenue"), value: data.grossRevenue, isMoney: true },
        { label: t("net_revenue"), value: data.netRevenue, isMoney: true },
        { label: t("commission"), value: data.totalCommission, isMoney: true },
        { label: t("discount"), value: data.totalDiscount, isMoney: true },
        { label: t("avg_trip"), value: data.avgTrip, isMoney: true },
        { label: t("avg_gross_trip"), value: data.avgGrossTrip, isMoney: true },
        { label: t("take_rate"), value: `${data.takeRate.toFixed(2)}%` },
    ];

    return (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {items.map((item, index) => (
                <Card key={index}>
                    <CardHeader>
                        <CardTitle className="text-sm text-muted-foreground">
                            {item.label}
                        </CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="text-xl font-bold flex items-center gap-1">
                            {item.isMoney ? (
                                <>
                                    {item.value.toFixed(2)}
                                    <span className="text-xs text-muted-foreground px-0.5">
                                        {tSYP("SYP")}
                                    </span>
                                </>
                            ) : (
                                item.value
                            )}
                        </div>
                    </CardContent>
                </Card>
            ))}
        </div>
    );
}