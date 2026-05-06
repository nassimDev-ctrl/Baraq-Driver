
import { Client } from "@/types/types";
import { parseAsString, useQueryState } from "nuqs";
import React from "react";

export const useClientsFilter = (data: Client[]) => {
    const [fullname] = useQueryState("fullname",
        parseAsString.withDefault("")
    );
    const [city] = useQueryState("city",
        parseAsString.withDefault("")
    );

    const [gender] = useQueryState(
        "gender",
        parseAsString.withDefault("")
    )

    const [phoneNumber] = useQueryState(
        "phoneNumber",
        parseAsString.withDefault("")
    );

    const normalizePhone = (value: string) =>
        value.replace(/\s+/g, "").replace("+", "");
    const filteredData = React.useMemo(() => {
        return data.filter((client) => {
            const matchesCity =
                city.length === 0 || city.includes(client.city._id);
            const matchesName =
                fullname === "" ||
                `${client.firstName} ${client.lastName}`.toLowerCase().includes(fullname.toLowerCase());
            const matchesGender =
                gender.length === 0 ||
                gender.includes(client.gender);
            const matchesMobilePhone =
                phoneNumber === "" ||
                phoneNumber.length === 0 ||
                normalizePhone(client.authUser?.mobilePhone ?? "").includes(
                    normalizePhone(phoneNumber)
                );

            return matchesCity && matchesName && matchesMobilePhone && matchesGender;
        });
    }, [data, city, fullname, phoneNumber, gender]);

    return { filteredData }
}