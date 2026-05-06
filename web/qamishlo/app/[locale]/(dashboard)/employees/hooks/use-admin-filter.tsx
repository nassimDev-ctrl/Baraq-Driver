"use client";

import { Admin } from "@/types/types";
import { parseAsString, useQueryState } from "nuqs";
import React from "react";

export const useAdminsFilter = (data: Admin[]) => {
    const [fullname] = useQueryState(
        "fullname",
        parseAsString.withDefault("")
    );

    const [email] = useQueryState(
        "email",
        parseAsString.withDefault("")
    );

    const [role] = useQueryState(
        "roles",
        parseAsString.withDefault("")
    );

    const filteredData = React.useMemo(() => {
        return data.filter((admin) => {
            const matchesName =
                fullname === "" ||
                `${admin.firstName} ${admin.lastName}`
                    .toLowerCase()
                    .includes(fullname.toLowerCase());

            const matchesEmail =
                email === "" ||
                admin.email.toLowerCase().includes(email.toLowerCase());

            const matchesRole =
                role.length === 0 ||
                (admin.roles?.some((r) =>
                    r.name?.toLowerCase().includes(role.toLowerCase())
                ) ?? false);

            return matchesName && matchesEmail && matchesRole;
        });
    }, [data, fullname, email, role]);

    return { filteredData };
};