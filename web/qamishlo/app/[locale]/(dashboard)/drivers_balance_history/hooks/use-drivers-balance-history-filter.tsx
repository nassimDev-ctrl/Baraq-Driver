import { BalanceOperation } from "@/types/types";
import {
    parseAsInteger,
    parseAsString,
    useQueryState,
} from "nuqs";
import React from "react";

export const useBalanceOperationsFilter = (
    data: BalanceOperation[]
) => {
    const [operation] = useQueryState(
        "operation",
        parseAsString.withDefault("")
    );

    const [date] = useQueryState(
        "createdAt",
        parseAsInteger
    );

    const isSameDay = (a: Date, b: Date) =>
        a.getFullYear() === b.getFullYear() &&
        a.getMonth() === b.getMonth() &&
        a.getDate() === b.getDate();

    const filteredData = React.useMemo(() => {
        return data.filter((item) => {
            const matchesOperation =
                operation.length === 0 ||
                operation.includes(item.operation);

            const matchesDate =
                !date ||
                isSameDay(
                    new Date(date),
                    new Date(item.createdAt)
                );

            return matchesOperation && matchesDate;
        });
    }, [data, operation, date]);

    return { filteredData };
};