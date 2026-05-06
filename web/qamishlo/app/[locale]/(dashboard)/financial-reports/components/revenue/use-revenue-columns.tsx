"use client";

import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import { formatCurrency } from "@/lib/utils";
import { RevenueTrip } from "@/types/types";
import { ColumnDef } from "@tanstack/react-table";
import { Users } from "lucide-react";
import { useTranslations } from "next-intl";
import * as React from "react";


export function useRevenueColumns(): ColumnDef<RevenueTrip>[] {
    const t = useTranslations("financialReportsPage.revenue");

    const tSYP = useTranslations("currency");

    return React.useMemo<ColumnDef<RevenueTrip>[]>(() => [
        {
            id: "index",
            header: () => <div className="w-8 text-center"># </div>,
            cell: ({ table, row }) => {
                const index = table.getRowModel().rows.findIndex(r => r.id === row.id);
                return <div className="text-center" > {index + 1
                }</div>;
            },
            enableSorting: false,
            size: 40,
        },
        {
            accessorKey: "tripId",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("trip_id")} />,
        },
        {
            accessorKey: "date",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("date")} />,
            cell: ({ cell }) => new Date(cell.getValue<string>()).toLocaleString(),
            meta: { label: t("date"), variant: "date" },
        },

        {
            accessorKey: "city",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("city")} />,
            cell: ({ row }) => row.original.city || "-",
            meta: { label: t("city"), variant: "text" },
        },

        {
            accessorKey: "driverName",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("driver")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-2" >
                    <Users className="h-4 w-4 text-muted-foreground" />
                    {cell.getValue<string>()}
                </div>
            ),
            meta: { label: t("driver"), variant: "text" },
        },

        {
            accessorKey: "price",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("before")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1" >
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            ),
            meta: { label: t("before"), variant: "text" },
        },

        // Discount
        {
            accessorKey: "discount",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("discount")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1" >
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            ),
            meta: { label: t("discount"), variant: "text" },
        },

        // Total after discount
        {
            accessorKey: "totalPrice",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("after")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1" >
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            ),
            meta: { label: t("after"), variant: "text" },
        },

        // App Commission
        {
            accessorKey: "appCommission",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("app_share")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1" >
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            ),
            meta: { label: t("app_share"), variant: "text" },
        },

        // Driver Share
        {
            accessorKey: "driverShare",
            header: ({ column }) => <DataTableColumnHeader column={column} label={t("driver_share")} />,
            cell: ({ cell }) => (
                <div className="flex items-center gap-1" >
                    {formatCurrency(cell.getValue<number>())}
                    <span className="text-xs   text-muted-foreground px-0.5">{tSYP("SYP")}</span>
                </div>
            ),
            meta: { label: t("driver_share"), variant: "text" }
        },

        // * not needed now
        // Payment Way
        // {
        //     accessorKey: "paymentWay",
        //     header: ({ column }) => <DataTableColumnHeader column={column} label={t("payment")} />,
        //     cell: ({ cell }) => (
        //         <div className="flex items-center gap-1" >
        //             <CreditCard className="h-4 w-4 text-muted-foreground" />
        //             {cell.getValue<string>()}
        //         </div>
        //     ),
        //     meta: { label: t("payment"), variant: "text" },
        // },
    ], [t, tSYP]);
}