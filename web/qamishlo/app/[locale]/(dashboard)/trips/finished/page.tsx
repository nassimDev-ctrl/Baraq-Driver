import { Suspense } from "react";
import FinishedTripsTable from "./components/finished-trips-table";
import { Loader } from "@/components/loader";
import { getAllCities, getCompletedTrips } from "@/lib/data";
import Unauthorized from "@/components/unauthorized";
export default async function FinishedTripsPage() {
    const [cities, finishedTrips] = await Promise.all([getAllCities(), getCompletedTrips()])
    if (finishedTrips.message === "Forbidden" || cities.message === "Forbidden") return <Unauthorized />

    console.log(finishedTrips)

    return (
        <div className="md:px-4">
            <Suspense fallback={<Loader />}>
                <FinishedTripsTable data={finishedTrips} cities={cities} />
            </Suspense>
        </div>
    )
}