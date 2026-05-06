import { Emergency } from "@/types/types";
import { parseAsArrayOf, parseAsString, useQueryState } from "nuqs";
import React from "react";

export const useEmergenciesFilter = (data: Emergency[]) => {
    const [city] = useQueryState(
        "city",
        parseAsArrayOf(parseAsString).withDefault([])
    );

    const filteredData = React.useMemo(() => {
        return data.filter((emergency) => {
            const matchesCity =
                city && (

                    city.length === 0 ||
                    city.includes(emergency.city?._id)
                )

            return matchesCity;
        });
    }, [data, city]);

    return { filteredData };
};