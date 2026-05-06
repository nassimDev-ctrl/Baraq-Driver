import { Loader } from "@/components/loader";
import { getAllCities, getClients } from "@/lib/data";
import { Suspense } from "react";
import ClientsTable from "./components/clients-table";
import { getTranslations } from "next-intl/server";
import Unauthorized from "@/components/unauthorized";

export default async function ClientsPage() {
    const [clients, cities, t] = await Promise.all([getClients(), getAllCities(), getTranslations("clientsPage")]);
    if (clients.message === "Forbidden" || cities.message === "Forbidden") return <Unauthorized />;
    return (
        <main className="md:px-4 space-y-8">
            <h1 className="h1-title">{t("clients")}</h1>
            <Suspense fallback={<Loader />}>
                <ClientsTable data={clients} cities={cities} />
            </Suspense>
        </main>
    )
}