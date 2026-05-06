"use client";

import { ColumnDef, Column } from "@tanstack/react-table";
import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import { useTranslations } from "next-intl";
import React from "react";
import { CityRevenue } from "@/types/types";
import { formatCurrency } from "@/lib/utils";

export function useCityRevenueColumns(): ColumnDef<CityRevenue>[] {
    const t = useTranslations("financialReportsPage.cityRevenue");

    const tSYP = useTranslations("currency");

    return React.useMemo<ColumnDef<CityRevenue>[]>(() => [
        {
            id: "index",
            header: () => <div className="w-8 px-4 text-center font-medium">#</div>,
            cell: ({ row }) => <div className="w-8 px-4 text-center text-muted-foreground">{row.index + 1}</div>,
            size: 48,
            enableSorting: false,
        },
        {
            id: "city",
            accessorKey: "city",
            header: ({ column }: { column: Column<CityRevenue, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("city")} />
            ),
            meta: { label: t("city") },
        },
        {
            id: "totalTrips",
            accessorKey: "totalTrips",
            header: ({ column }: { column: Column<CityRevenue, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("total_trips")} />
            ),
            meta: { label: t("total_trips") },
        },
        {
            id: "totalRevenue",
            accessorKey: "totalRevenue",
            header: ({ column }: { column: Column<CityRevenue, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("total_revenue")} />
            ),
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            ),
            meta: { label: t("total_revenue") },
        },
        {
            id: "avgPrice",
            accessorKey: "avgPrice",
            header: ({ column }: { column: Column<CityRevenue, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("avg_price")} />
            ),
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            ),
            meta: { label: t("avg_price") },
        },
        {
            id: "totalCommission",
            accessorKey: "totalCommission",
            header: ({ column }: { column: Column<CityRevenue, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("total_commission")} />
            ),
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            ),
            meta: { label: t("total_commission") },
        },
    ], [t, tSYP]);
}