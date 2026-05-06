"use client";

import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import { formatCurrency } from "@/lib/utils";
import { CashCollection } from "@/types/types";
import { ColumnDef } from "@tanstack/react-table";
import { Users } from "lucide-react";
import { useTranslations } from "next-intl";
import * as React from "react";

export function useCashCollectionColumns(): ColumnDef<CashCollection>[] {
    const t = useTranslations("financialReportsPage.cashCollection");

    const tSYP = useTranslations("currency");

    return React.useMemo<ColumnDef<CashCollection>[]>(() => [
        {
            id: "index",
            header: () => <div className="w-8 text-center">#</div>,
            cell: ({ table, row }) => {
                const index = table.getRowModel().rows.findIndex(r => r.id === row.id);
                return <div className="text-center">{index + 1}</div>;
            },
            enableSorting: false,
            size: 40
        },
        {
            accessorKey: "driverName",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("driver")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-2">
                    <Users className="h-4 w-4 text-muted-foreground" />
                    {cell.getValue<string>()}
                </div>
            )
        },
        {
            accessorKey: "totalTrips",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("total_trips")} />,
        },
        {
            accessorKey: "totalCashCollected",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("total_collected")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            )
        },
        {
            accessorKey: "totalCommission",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("total_commission")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            )
        },
        {
            accessorKey: "submitted",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("submitted")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            )
        },
        {
            accessorKey: "difference",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("difference")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1">
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            )
        }
    ], [tSYP, t]);
}