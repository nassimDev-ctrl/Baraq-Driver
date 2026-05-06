"use client";

import { useState } from "react";
import {
    Tabs,
    TabsContent,
    TabsList,
    TabsTrigger,
} from "@/components/ui/tabs";

import { useLocale, useTranslations } from "next-intl";
import RevenueTable from "./revenue/revenue-table";
import CashCollectionTable from "./cash-collection/cash-collection-table";
import ComparisonTable from "./comparison/Comparison-table";
import CityRevenueTable from "./cities/cities-table";
import DriversTable from "./drivers/DriversTable";
import { CashCollection, CityRevenue, DriverRevenue, RevenueTrip, TripComparison } from "@/types/types";
import { useQueryStates } from "nuqs";

const DEFAULT_QUERY = {
    page: 1,
    perPage: 10,
    from: null,
    to: null,
};

interface FinancialTabsProps {
    revenue: RevenueTrip[];
    cash: CashCollection[];
    comparison: TripComparison[];
    cities: CityRevenue[];
    drivers: DriverRevenue[];
}

export default function FinancialTabs({
    revenue,
    cash,
    comparison,
    cities,
    drivers,
}: FinancialTabsProps) {
    const [activeTab, setActiveTab] = useState("revenue");
    const t = useTranslations("financialReportsPage");
    const locale = useLocale();
    const [, setQuery] = useQueryStates({
        page: {
            defaultValue: 1,
            parse: Number,
        },
        perPage: {
            defaultValue: 10,
            parse: Number,
        },
        from: {
            defaultValue: null,
            parse: (v) => v ?? null,
        },
        to: {
            defaultValue: null,
            parse: (v) => v ?? null,
        },
    });

    const handleTabChange = (value: string) => {
        setActiveTab(value);

        // reset EVERYTHING related to table state in URL
        setQuery(DEFAULT_QUERY);
    };


    const dir = locale === "ar" ? "rtl" : "ltr";

    return (
        <Tabs className="flex flex-col space-y-4 w-full" value={activeTab} onValueChange={handleTabChange}>
            <TabsList className="flex flex-wrap">
                <TabsTrigger value="revenue">{t("revenue_title")}</TabsTrigger>
                <TabsTrigger value="cash">{t("cash_collection_title")}</TabsTrigger>
                <TabsTrigger value="comparison">{t("comparison_title")}</TabsTrigger>
                <TabsTrigger value="cities">{t("cities_title")}</TabsTrigger>
                <TabsTrigger value="drivers">{t("drivers_title")}</TabsTrigger>
            </TabsList>

            <TabsContent value="revenue" dir={dir}>
                <RevenueTable key="revenue" data={revenue} />
            </TabsContent>

            <TabsContent value="cash" dir={dir}>
                <CashCollectionTable key="cash" data={cash} />
            </TabsContent>

            <TabsContent value="comparison" dir={dir}>
                <ComparisonTable key="comparison" data={comparison} />
            </TabsContent>

            <TabsContent value="cities" dir={dir}>
                <CityRevenueTable key="cities" data={cities} />
            </TabsContent>

            <TabsContent value="drivers" dir={dir}>
                <DriversTable key="drivers" data={drivers} />
            </TabsContent>
        </Tabs>
    );
}