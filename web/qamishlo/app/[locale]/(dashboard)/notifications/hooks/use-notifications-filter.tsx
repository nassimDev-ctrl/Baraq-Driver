import { Notifications } from "@/types/types";
import {
    parseAsInteger,
    useQueryState
} from "nuqs";
import React from "react";

export const useNotificationsFilter = (data: Notifications[]) => {
    // const [governorate] = useQueryState(
    //     "governorate",
    //     parseAsString.withDefault("")
    // );

    const [date] = useQueryState(
        "createdAt",
        parseAsInteger
    );

    const isSameDay = (a: Date, b: Date) =>
        a.getFullYear() === b.getFullYear() &&
        a.getMonth() === b.getMonth() &&
        a.getDate() === b.getDate();

    const filteredData = React.useMemo(() => {
        return data.filter((notification) => {
            // const matchesGovernorate =
            //     !governorate ||
            //     notification.governorates.some((g) => g._id === governorate);

            const matchesDate =
                !date ||
                isSameDay(
                    new Date(date),
                    new Date(notification.createdAt)
                );

            return matchesDate;
        });
    }, [data, date]);

    return { filteredData };
};