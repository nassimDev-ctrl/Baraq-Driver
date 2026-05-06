"use client";

import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import { formatCurrency } from "@/lib/utils";
import { DriverRevenue } from "@/types/types";
import { ColumnDef } from "@tanstack/react-table";
import { Star, Users } from "lucide-react";
import { useTranslations } from "next-intl";
import React from "react";

export function useDriversColumns(): ColumnDef<DriverRevenue>[] {
    const t = useTranslations("financialReportsPage.drivers_columns");

    const tSYP = useTranslations("currency");

    return React.useMemo<ColumnDef<DriverRevenue>[]>(() => [
        {
            id: "index",
            header: () => <div className="w-8 text-center">#</div>,
            cell: ({ row, table }) => {
                const index = table.getRowModel().rows.findIndex(r => r.id === row.id);
                return <div className="text-center">{index + 1}</div>;
            },
            size: 40,
            enableSorting: false,
        },
        {
            accessorKey: "driverName",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("driver")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-2">
                    <Users className="h-4 w-4 text-muted-foreground" />
                    {cell.getValue<string>()}
                </div>
            ),
            meta: { label: t("driver"), variant: "text" },
        },
        {
            accessorKey: "totalTrips",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("trips")} />,
            meta: { label: t("trips"), variant: "text" },
        },
        {
            accessorKey: "totalRevenue",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("revenue")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            ),
            meta: { label: t("revenue"), variant: "text" },
        },
        {
            accessorKey: "totalCommission",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("commission")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            ),
            meta: { label: t("commission"), variant: "text" },
        },
        {
            accessorKey: "totalDiscount",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("discount")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            ),
            meta: { label: t("discount"), variant: "text" },
        },
        {
            accessorKey: "rating",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("rating")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    {cell.getValue<number>()}
                    <Star className="size-3 text-muted-foreground" />
                </div>
            ),
            meta: { label: t("rating"), variant: "text" },
        },
    ], [t, tSYP]);
}