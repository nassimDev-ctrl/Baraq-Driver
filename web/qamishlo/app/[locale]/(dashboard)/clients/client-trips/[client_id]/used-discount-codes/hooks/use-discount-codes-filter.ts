"use client";

import { DiscountCode } from "@/types/types";
import { parseAsString, useQueryState } from "nuqs";
import React from "react";

export const useDiscountCodesFilter = (data: DiscountCode[]) => {
    const [code] = useQueryState(
        "code",
        parseAsString.withDefault("")
    );

    // const [status] = useQueryState(
    //     "status",
    //     parseAsString.withDefault("")
    // );

    // const [isVip] = useQueryState(
    //     "isVip",
    //     parseAsString.withDefault("")
    // );

    // const [governorate] = useQueryState(
    //     "governorate",
    //     parseAsString.withDefault("")
    // );

    const filteredData = React.useMemo(() => {
        return data.filter((discount) => {
            const matchesCode =
                code === "" ||
                discount.code.toLowerCase().includes(code.toLowerCase());

            // const matchesStatus =
            //     status === "" ||
            //     discount.status === status;

            // const matchesVip =
            //     isVip === "" ||
            //     String(discount.isVip) === isVip;

            // const matchesGovernorate =
            //     governorate === "" ||
            //     discount.governorates.some((g) =>
            //         g.name.toLowerCase().includes(governorate.toLowerCase())
            //     );

            return (
                matchesCode
                // matchesStatus &&
                // matchesVip &&
                // matchesGovernorate
            );
        });
    }, [data, code,]);

    return { filteredData };
};