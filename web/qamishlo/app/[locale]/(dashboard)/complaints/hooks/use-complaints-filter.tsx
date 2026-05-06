"use client";

import { Complaint } from "@/types/types";
import { parseAsString, useQueryState } from "nuqs";
import React from "react";

export const useComplaintsFilter = (data: Complaint[]) => {
    const [note] = useQueryState("note", parseAsString.withDefault(""));
    const [phone] = useQueryState("mobilePhone", parseAsString.withDefault(""));
    const [status] = useQueryState("isRead", parseAsString.withDefault(""));
    const normalizePhone = (value: string) =>
        value.replace(/\s+/g, "").replace("+", "");
    const filteredData = React.useMemo(() => {
        return data.filter((complaint) => {
            const matchesNote =
                note === "" ||
                complaint.note.toLowerCase().includes(note.toLowerCase());

            const matchesPhone =
                phone === "" ||
                (complaint?.mobilePhone &&
                    normalizePhone(complaint?.mobilePhone).includes(
                        normalizePhone(phone)
                    )
                );

            const matchesStatus =
                status === "" ||
                complaint.isRead.toString() === status.at(0);

            return matchesNote
                && matchesPhone
                && matchesStatus;
        });
    }, [data, note, status, phone]);

    return { filteredData };
};