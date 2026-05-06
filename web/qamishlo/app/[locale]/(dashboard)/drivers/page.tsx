import { Suspense } from "react";
import { DriversTable } from "./components/drivers-table";
import { Loader } from "@/components/loader";
import { getAllCities, getDrivers } from "@/lib/data";
import { getTranslations } from "next-intl/server";
import Unauthorized from "@/components/unauthorized";

export default async function DriversPage() {
    const [drivers, cities, t] = await Promise.all([getDrivers(), getAllCities(), getTranslations("driversPage")]);
    if (drivers.message === "Forbidden" || cities.message === "Forbidden") return <Unauthorized />;
    return (
        <main className="md:px-4 space-y-8">
            <h1 className=" h1-title">{t("title")}</h1>
            <Suspense fallback={<Loader />}>
                <DriversTable data={drivers} cities={cities} />
            </Suspense>
        </main>
    )
}