"use client";

import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import { City, OngoingTrip, ongoingTripStatus } from "@/types/types";
import type { ColumnDef } from "@tanstack/react-table";
import { useLocale, useTranslations } from "next-intl";
import * as React from "react";

const ongoingTripsOptions: ongoingTripStatus[] = [
    "On the way to the destination",
    "waiting driver",
];

export default function useOngoingTripsColumns({ cities }: { cities: City[] }) {
    const t = useTranslations("ongoingTripsColumns");
    const onts = useTranslations("ongoingTripsStatus");
    const locale = useLocale();
    return React.useMemo<ColumnDef<OngoingTrip>[]>(() => [
        {
            id: "index",
            header: "#",
            cell: ({ row }) => (
                <div className="w-6 text-center text-muted-foreground">
                    {row.index + 1}
                </div>
            ),
            enableSorting: false,
            enableColumnFilter: false,
            size: 40,
        },

        {
            id: "client",
            accessorFn: (row) =>
                `${row.client?.firstName ?? "Unknown"} ${row.client?.lastName ?? "user"}`,
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("client")} />
            ),
            cell: ({ cell }) => <div>{cell.getValue<string>()}</div>,
            meta: {
                label: t("client"),
            },
        },

        {
            id: "driver",
            accessorFn: (row) =>
                `${row.driver?.firstName ?? "Unknown"} ${row.driver?.lastName ?? "driver"}`,
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("driver")} />
            ),
            cell: ({ cell }) => <div>{cell.getValue<string>()}</div>,
            meta: {
                label: t("driver"),
            },
        },

        {
            id: "status",
            accessorKey: "status",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("status")} />
            ),
            cell: ({ cell }) => {
                const status = cell.getValue<OngoingTrip["status"]>();
                return <div>{onts(status)}</div>;
            },
            meta: {
                label: t("status"),
                variant: "multiSelect",
                options: ongoingTripsOptions.map((o) => ({
                    label: onts(o),
                    value: o,
                })),
            },
            enableColumnFilter: true,
        },

        {
            id: "city",
            accessorFn: ({ city }) => locale === "ar" ? city.nameAr : locale === "en" ? city.nameEn : city.nameKu,
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("city")} />
            ),
            cell: ({ cell }) => <div>{cell.getValue<string>()}</div>,
            meta: {
                label: t("city"),
                variant: "multiSelect",
                options: cities.map((c) => ({
                    label: locale === "ar" ? c.nameAr : locale === "en" ? c.nameEn : c.nameKu,
                    value: c._id,
                })),
            },
            enableColumnFilter: true,
        },

        {
            id: "waitingDuration",
            accessorKey: "waitingDuration",
            header: ({ column }) => (
                <DataTableColumnHeader
                    column={column}
                    label={t("waitingDuration")}
                />
            ),
            cell: ({ cell }) => <div>{cell.getValue<number>()}</div>,
            meta: {
                label: t("waitingDuration"),
            },
        },

        {
            id: "emergency",
            accessorKey: "emergency",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("emergency")} />
            ),
            cell: ({ cell }) => (
                <div>{cell.getValue<boolean>() ? "yes" : "no"}</div>
            ),
            meta: {
                label: t("emergency"),
                variant: "multiSelect",
                options: [
                    { label: "yes", value: "true" },
                    { label: "no", value: "false" },
                ],
            },
            enableColumnFilter: true,
        },
    ], [t, onts, locale, cities]);
}
