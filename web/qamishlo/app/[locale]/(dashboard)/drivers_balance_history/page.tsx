import { getDriversBalanceHistory } from "@/lib/data";
import { Suspense } from "react";
import BalanceOperationsTable from "./components/balance-operation-table";
import { getTranslations } from "next-intl/server";
import { Loader } from "@/components/loader";
import Unauthorized from "@/components/unauthorized";

export default async function DriversBalanceHistoryPage() {
    const [balanceRecords, t] = await Promise.all([getDriversBalanceHistory(), getTranslations("DriversBalanceHistoryPage")]);
    if (balanceRecords.message === "Forbidden") return <Unauthorized />;
    return (
        <main className="md:px-4 space-y-8">
            <h1 className="h1-title">{t("title")}</h1>
            <Suspense fallback={<Loader />}>
                <BalanceOperationsTable data={balanceRecords} />
            </Suspense>
        </main>
    )
}