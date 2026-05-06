
import { Loader } from "@/components/loader";
import { getAllCities } from "@/lib/data";
import { City } from "@/types/types";
import { getTranslations } from 'next-intl/server';
import { Suspense } from "react";
import { CreateCity } from "./components/add-city";
import { CityCard } from "./components/city-card";
import Unauthorized from "@/components/unauthorized";
export default async function CitiesPage() {
    const [cities, t] = await Promise.all([getAllCities(), getTranslations("cities")]);
    if (cities.message === "Forbidden") return <Unauthorized />;
    return (
        <main className="md:px-4 space-y-4">
            <h1 className="h1-title">{t("title")}</h1>
            <Suspense fallback={<Loader />}>
                <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4 mb-8">
                    {cities.map((city: City) => (
                        <CityCard key={city._id} city={city} />
                    ))}
                    <CreateCity />
                </div>
            </Suspense>
        </main>
    );
}