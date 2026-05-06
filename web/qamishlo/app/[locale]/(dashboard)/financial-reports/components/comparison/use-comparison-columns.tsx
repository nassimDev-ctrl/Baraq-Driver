"use client";

import { ColumnDef } from "@tanstack/react-table";
import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import { useTranslations } from "next-intl";
import * as React from "react";
import { TripComparison } from "@/types/types";
import { Percent } from "lucide-react";
import { formatCurrency } from "@/lib/utils";

export function useComparisonColumns(): ColumnDef<TripComparison>[] {
    const t = useTranslations("financialReportsPage.comparison");

    const tSYP = useTranslations("currency");

    return React.useMemo<ColumnDef<TripComparison>[]>(() => [
        {
            id: "index",
            header: () => <div className="w-8 text-center">#</div>,
            cell: ({ table, row }) => {
                const index = table.getRowModel().rows.findIndex(r => r.id === row.id);
                return <div className="text-center">{index + 1}</div>;
            },
            enableSorting: false,
            size: 40,
        },
        {
            accessorKey: "tripType",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("trip_type")} />,
            cell: ({ cell }) => cell.getValue<string>(),
            meta: { label: t("trip_type") },
        },
        {
            accessorKey: "totalTrips",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("total_trips")} />,
            cell: ({ cell }) => cell.getValue<number>(),
            meta: { label: t("total_trips") },
        },
        {
            accessorKey: "totalRevenue",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("total_revenue")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            ),
            meta: { label: t("total_revenue") },
        },
        {
            accessorKey: "avgPrice",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("avg_price")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            ),
            meta: { label: t("avg_price") },
        },
        {
            accessorKey: "percentage",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("percentage")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    {cell.getValue<number>()}%
                    <Percent className="size-3 text-muted-foreground" />
                </div>
            ),
            meta: { label: t("percentage") },
        },
    ], [t, tSYP]);
}