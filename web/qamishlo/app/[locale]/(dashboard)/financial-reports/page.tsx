import { Loader } from "@/components/loader";
import Unauthorized from "@/components/unauthorized";
import {
    getCashCollection,
    getDashboardStats,
    getDriversPerformance,
    getRevenueReport,
    getTripComparison,
    getTripsByCity,
} from "@/lib/data";
import { getTranslations } from "next-intl/server";
import { Suspense } from "react";
import DashboardStatsCards from "./components/dashboard-stats";
import FinancialTabs from "./components/financial-tabs";

export default async function FinancialReportsPage() {
    const t = await getTranslations("financialReportsPage");
    const [revenue, cash, cities, comparison, drivers, stats] = await Promise.all([
        getRevenueReport(),
        getCashCollection(),
        getTripsByCity(),
        getTripComparison(),
        getDriversPerformance(),
        getDashboardStats()
    ]);


    if (revenue.message === "Forbidden" || cash.message === "Forbidden" || cities.message === "Forbidden" || comparison.message === "Forbidden" || drivers.message === "Forbidden" || stats.message === "Forbidden") return <Unauthorized />

    return (
        <main className="md:px-4 space-y-8">
            <h1 className=" h1-title">{t("title")}</h1>

            <Suspense fallback={<Loader />}>
                {/*  Dashboard Stats */}
                {stats && <DashboardStatsCards data={stats} />}

                <FinancialTabs revenue={revenue} cash={cash} cities={cities} comparison={comparison} drivers={drivers} />
            </Suspense>
        </main >
    )
}