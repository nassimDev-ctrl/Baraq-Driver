"use client";

import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import { TripsMapDialog } from "@/components/trip-map";
import { Button } from "@/components/ui/button";
import { DropdownMenu, DropdownMenuContent, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { formatDate, formatDuration } from "@/lib/utils";
import { City, FinishedTrips, finishedTripStatus } from "@/types/types";
import type { ColumnDef } from "@tanstack/react-table";
import { MoreHorizontal } from "lucide-react";
import { useLocale, useTranslations } from "next-intl";
import * as React from "react";

const finishedTripsOptions: finishedTripStatus[] = [
    "completed",
    "canceled",
    "driver_accepted",
    "driver_canceled",
    "requested",
    "no_driver_available",
    "searching",
    "started"
];



export default function useFinishedTripsColumns({ cities }: { cities: City[] }) {
    const t = useTranslations("finishedTripsColumns");
    const fts = useTranslations("finishedTripsStatus");
    const tSP = useTranslations("currency");
    const locale = useLocale();

    return React.useMemo<ColumnDef<FinishedTrips>[]>(() => [
        {
            id: "index",
            header: "#",
            cell: ({ row }) => row.index + 1,
            enableSorting: false,
            size: 40,
        },
        {
            id: "client",
            accessorFn: (row) =>
                `${row.client?.firstName ?? "Unknown"} ${row.client?.lastName ?? "user"}`,
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("client")} />
            ),
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
                const status = cell.getValue<finishedTripStatus>();
                return <div>{fts(status)}</div>;
            },
            meta: {
                label: t("status"),
                variant: "multiSelect",
                options: finishedTripsOptions.map((s) => ({
                    label: fts(s),
                    value: s,
                })),
            },
            enableColumnFilter: true,
        },
        {
            id: "startedAt",
            accessorKey: "startedAt",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("startedAt")} />
            ),
            cell: ({ cell }) => formatDate(
                cell.getValue<Date>()),
            meta: {
                label: t("startedAt"),
            },
        },
        {
            id: "completedAt",
            accessorKey: "completedAt",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("completedAt")} />
            ),
            cell: ({ cell }) =>
                formatDate(cell.getValue<Date>()),
            meta: {
                label: t("completedAt"),
            },
        },
        {
            id: "durationInsideCar",
            accessorKey: "durationInsideCar",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("durationInsideCar")} />
            ),
            cell: ({ cell }) => formatDuration(cell.getValue<number>()),
            meta: {
                label: t("durationInsideCar"),
            },
        },
        {
            id: "totalTime",
            accessorFn: (row) =>
                row.durationInsideCar + row.waitingDuration,
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("totalTime")} />
            ),
            cell: ({ cell }) => formatDuration(cell.getValue<number>()),
            enableSorting: true,
            meta: {
                label: t("totalTime"),
            },
        },
        {
            id: "totalPrice",
            accessorKey: "price",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("totalPrice")} />
            ),
            cell: ({ cell }) => {
                const value = cell.getValue<number>();

                if (value == null) return "-";

                return Number.isInteger(value)
                    ? `${value} ${tSP("SYP")}`
                    : `${value.toFixed(2)} ${tSP("SYP")}`;
            },
            meta: {
                label: t("totalPrice"),
            },
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
            id: "emergency",
            accessorFn: (row) => (row.emergency ? "true" : "false"),
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("emergency")} />
            ),
            cell: ({ row }) => {
                const emergency = row.original.emergency;
                const translation =
                    locale === "en"
                        ? (emergency ? "Yes" : "No")
                        : locale === "ar"
                            ? (emergency ? "نعم" : "لا")
                            : (emergency ? "Erê" : "Na");
                return (
                    <>
                        {translation}
                    </>
                )
            }
            ,
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
        {
            id: "actions",
            cell: function Cell({ row }) {
                return (
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="ghost" size="icon">
                                <MoreHorizontal className="h-4 w-4" />
                                <span className="sr-only">Open menu</span>
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="center">
                            <TripsMapDialog trip={row.original} />
                        </DropdownMenuContent>
                    </DropdownMenu>
                );
            },
            size: 32,
        },
    ], [t, fts, tSP, locale, cities]);
}
