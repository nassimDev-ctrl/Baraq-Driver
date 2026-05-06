import { CashCollection } from "@/types/types";
import { parseAsString, useQueryState } from "nuqs";
import React from "react";

export const useCashCollectionFilter = (data: CashCollection[]) => {
    const [from] = useQueryState("from", parseAsString.withDefault(""));
    const [to] = useQueryState("to", parseAsString.withDefault(""));

    const filteredData = React.useMemo(() => {
        return data.filter((item) => {
            if (!("date" in item)) return true;

            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            const itemDate = new Date((item as any).date);

            const matchesFrom =
                from === "" || itemDate >= new Date(from);

            const matchesTo =
                to === "" || itemDate <= new Date(to);

            return matchesFrom && matchesTo;
        });
    }, [data, from, to]);

    return { filteredData };
};