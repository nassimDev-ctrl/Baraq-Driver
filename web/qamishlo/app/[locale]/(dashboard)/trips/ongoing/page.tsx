import { Suspense } from "react";
import OngoingTripsTable from "./components/ongoing-trips-table";
import { Loader } from "@/components/loader";
import { getAllCities, getOngoingTrips } from "@/lib/data";
import Unauthorized from "@/components/unauthorized";
export default async function OngoingTripsPage() {
    const [cities, onGoingTrips] = await Promise.all([getAllCities(), getOngoingTrips()])
    if (onGoingTrips.message === "Forbidden" || cities.message === "Forbidden") return <Unauthorized />
    return (
        <div className="md:px-4">
            <Suspense fallback={<Loader />}>
                <OngoingTripsTable data={onGoingTrips} cities={cities} />
            </Suspense>
        </div>
    )
}
