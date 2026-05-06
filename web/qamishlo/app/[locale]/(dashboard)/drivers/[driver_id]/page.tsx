
import { getAllCities, getCarCategories, getDriver, getDriverBalanceOperations } from "@/lib/data";
import { Suspense } from "react";
import { Loader } from "@/components/loader";
import DriverDetails from "./components/driver-details";
import Unauthorized from "@/components/unauthorized";

export default async function DriverPage({
    params,
}: {
    params: Promise<{ driver_id: string }>
}) {
    const { driver_id } = await params
    const [driver, categories, balanceRecords, cities] = await Promise.all([getDriver(driver_id), getCarCategories(), getDriverBalanceOperations(driver_id), getAllCities()]);

    if (driver.message === "Forbidden" || balanceRecords.message === "Forbidden" || categories.message === "Forbidden" || cities.message === "Forbidden") return <Unauthorized />;
    return (
        <main>
            <Suspense fallback={<Loader />}>
                <DriverDetails driver={driver} categories={categories} balanceRecords={balanceRecords} cities={cities} />
            </Suspense>
        </main>
    )
}