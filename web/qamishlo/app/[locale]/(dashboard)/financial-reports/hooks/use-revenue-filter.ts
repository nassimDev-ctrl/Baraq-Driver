import { RevenueTrip } from "@/types/types";
import { parseAsString, useQueryState } from "nuqs";
import React from "react";

export const useRevenueFilter = (data: RevenueTrip[]) => {
    const [from] = useQueryState("from", parseAsString.withDefault(""));
    const [to] = useQueryState("to", parseAsString.withDefault(""));

    const filteredData = React.useMemo(() => {
        if (!from && !to) return data;
        return data.filter((trip) => {
            const tripDate = new Date(trip.date);

            const matchesFrom =
                from === "" || tripDate >= new Date(from);

            const matchesTo =
                to === "" || tripDate <= new Date(to);

            return matchesFrom && matchesTo;
        });
    }, [data, from, to]);

    return { filteredData };
};