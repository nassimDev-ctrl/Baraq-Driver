"use client";

import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import { Button } from "@/components/ui/button";
import { DropdownMenu, DropdownMenuContent, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { City, Emergency } from "@/types/types";
import type { Column, ColumnDef } from "@tanstack/react-table";
import { Clock, MapPin, MoreHorizontal, Truck, User } from "lucide-react";
import { useLocale, useTranslations } from "next-intl";
import * as React from "react";
import { EmergencyMapDialog } from "./emergency-map-dialog";

export function useEmergenciesColumns({ cities }: { cities: City[] }) {
    console.log(cities);
    const t = useTranslations("emergency_columns");
    // const statusT = useTranslations("emergency_status");
    const locale = useLocale();

    return React.useMemo<ColumnDef<Emergency>[]>(() => [
        {
            id: "index",
            header: () => (
                <div className="w-8 px-8 text-right font-medium">
                    #
                </div>
            ),
            cell: ({ row }) => (
                <div className="w-8 px-8 text-right text-muted-foreground">
                    {row.index + 1}
                </div>
            ),
            size: 48,
            enableSorting: false,
        },
        {
            id: "location",
            accessorFn: (row) =>
                row.emergency?.location?.address ?? "N/A",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("location")} />
            ),
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    <MapPin className="size-4" />
                    {cell.getValue<string>()}
                </div>
            ),
            meta: {
                label: t("location"),
                // variant: "text",
                icon: MapPin,
            },
            enableColumnFilter: false,
        },
        {
            id: "client",
            accessorFn: (row) => `${row.client?.firstName ?? "Unknown"} ${row.client?.lastName ?? " User"}`,
            header: ({ column }: { column: Column<Emergency, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("client")} />
            ),
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    <User className="size-4" />
                    {cell.getValue<string>()}
                </div>
            ),
            meta: {
                label: t("client"),
            },
        },
        {
            id: "client_number",
            accessorFn: (row) => `${row.client?.authUser?.mobilePhone ?? "N/A"}`,
            header: ({ column }: { column: Column<Emergency, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("client_number")} />
            ),
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    <User className="size-4" />
                    {cell.getValue<string>()}
                </div>
            ),
            meta: {
                label: t("client"),
            },
        },
        {
            id: "driver",
            accessorFn: (row) => `${row.driver?.firstName ?? "Unknown"} ${row.driver?.lastName ?? " Driver"}`,
            header: ({ column }: { column: Column<Emergency, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("driver")} />
            ),
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    <Truck className="size-4" />
                    {cell.getValue<string>()}
                </div>
            ),
            meta: {
                label: t("driver"),
            },
        },
        {
            id: "driver_number",
            accessorFn: (row) => `${row.driver?.authUser?.mobilePhone ?? "N/A"}`,
            header: ({ column }: { column: Column<Emergency, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("driver_number")} />
            ),
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    <Truck className="size-4" />
                    {cell.getValue<string>()}
                </div>
            ),
            meta: {
                label: t("driver"),
            },
        },
        {
            id: "emergencyTime",
            accessorKey: "emergency.emergencyTime",
            header: ({ column }: { column: Column<Emergency, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("emergency_time")} />
            ),
            cell: ({ cell }) => {
                const date = new Date(cell.getValue<Date>());
                return (
                    <div className="flex items-center gap-1">
                        <Clock className="size-4" />
                        {date.toLocaleDateString("en-US", { hour: "2-digit", minute: "2-digit" })}
                    </div>
                )
            },
            meta: {
                label: t("emergency_time"),
            },
        },
        {
            id: "city",
            accessorKey: "city",
            header: ({ column }: { column: Column<Emergency, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("city")} />
            ),
            cell: ({ cell }) => {
                const city = cell.getValue<Emergency["city"]>();
                return (
                    <>
                        {city && locale === "ar" ? city.nameAr : locale === "en" ? city.nameEn : locale === "kmr" ? city.nameKu : "N/A"}
                    </>
                );
            },
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
            id: "actions",
            cell: ({ row }) => (
                <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                        <Button variant="ghost" size="icon">
                            <MoreHorizontal className="h-4 w-4" />
                        </Button>
                    </DropdownMenuTrigger>

                    <DropdownMenuContent>
                        <EmergencyMapDialog
                            emergency={row.original}
                        />
                    </DropdownMenuContent>
                </DropdownMenu>

            ),
        }
    ], [t, cities, locale]);

}
