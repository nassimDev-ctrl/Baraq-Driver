import { Suspense } from "react";
import { getAllCities, getAllEmergencies } from "@/lib/data";
import { Loader } from "@/components/loader";
import { getTranslations } from "next-intl/server";
import EmergenciesTable from "./components/EmergenciesTable";
import Unauthorized from "@/components/unauthorized";

export default async function EmergenciesPage() {
    const [emergencies, cities, t] = await Promise.all([getAllEmergencies(), getAllCities(), getTranslations("emergencyPage")]);
    if (emergencies.message === "Forbidden" || cities.message === "Forbidden") return <Unauthorized />;


    console.log(emergencies)

    if (emergencies?.data?.length === 0) return null;



    return (
        <main className="md:px-4 space-y-8">
            <h1 className="h1-title">{t("title")}</h1>
            <Suspense fallback={<Loader />}>
                <EmergenciesTable data={emergencies} cities={cities} />
            </Suspense>
        </main>
    )
}