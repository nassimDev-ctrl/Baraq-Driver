import { Loader } from "@/components/loader";
import { getAllCities, getClientTrips } from "@/lib/data";
import { Suspense } from "react";
import FinishedTripsTable from "../../../trips/finished/components/finished-trips-table";
import { getTranslations } from "next-intl/server";

import { buttonVariants } from "@/components/ui/button";
import Unauthorized from "@/components/unauthorized";
import { Link } from "@/i18n/navigation";

export default async function ClientTripsPage({
    params,
}: {
    params: Promise<{ client_id: string }>
}) {
    const { client_id } = await params
    const [clientTrips, cities, t] = await Promise.all([getClientTrips(client_id), getAllCities(), getTranslations("client_trips")]);
    if (clientTrips.message === "Forbidden") return <Unauthorized />;
    return (
        <main className="space-y-8">
            <div className="flex items-center justify-between mb-8">
                <h1 className=" h1-title">{t("title")}</h1>
                <Link
                    className={buttonVariants({ variant: "secondary" })}
                    href={{
                        pathname: `/clients/client-trips/${client_id}/used-discount-codes`,
                    }}
                >
                    {t("view_discount_code")}
                </Link>
            </div>
            <Suspense fallback={<Loader />}>
                <FinishedTripsTable data={clientTrips} cities={cities} />
            </Suspense>
        </main>
    )
}