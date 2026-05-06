"use client";
import { DiscountCode } from "@/types/types";
import { parseAsArrayOf, parseAsString, useQueryState } from "nuqs";
import React from "react";

export const useDiscountCodeFilter = (data: DiscountCode[]) => {
    const [code] = useQueryState("code", parseAsString.withDefault(""));
    const [status] = useQueryState(
        "status",
        parseAsArrayOf(parseAsString).withDefault([])
    );

    const filteredData = React.useMemo(() => {
        return data?.filter((item) => {
            const matchesCode =
                code === "" ||
                item.code.toLowerCase().includes(code.toLowerCase());

            const matchesStatus =
                status.length === 0 || status.includes(item.status);

            return matchesCode && matchesStatus;
        });
    }, [data, code, status]);

    return { filteredData };
};
