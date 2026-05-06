import { FinishedTrips } from "@/types/types";
import { parseAsString, useQueryState } from "nuqs";
import React from "react";

export const useFinishedTripsFilter = (data: FinishedTrips[]) => {
    const [status] = useQueryState(
        "status",
        parseAsString.withDefault("")
    );

    const [emergency] = useQueryState(
        "emergency",
        parseAsString.withDefault("")
    );

    const [city] = useQueryState("city", parseAsString.withDefault(""));

    const filteredData = React.useMemo(() => {
        return data.filter((trip) => {
            const matchesStatus =
                status.length === 0 || status.includes(trip.status);

            const matchesEmergency =
                emergency.length === 0 ||
                emergency.includes(trip.emergency ? "true" : "false");

            const matchesCity =
                city.length === 0 ||
                (city &&
                    city.includes(trip.city._id)
                );


            return matchesStatus && matchesEmergency && matchesCity;
        });
    }, [data, status, emergency, city]);

    return { filteredData };
};
