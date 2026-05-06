"use client";

import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import { DiscountCode } from "@/types/types";
import { Column, ColumnDef } from "@tanstack/react-table";
import { useTranslations } from "next-intl";
import React from "react";

export function useDiscountCodesColumns() {
    const t = useTranslations("client_used_discount_codes");

    return React.useMemo<ColumnDef<DiscountCode>[]>(() => [
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
            id: "code",
            accessorKey: "code",
            header: ({ column }: { column: Column<DiscountCode, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("code")} />
            ),
            meta: {
                label: t("code"),
                placeholder: t("codePlaceholder"),
                variant: "text",
            },
            enableColumnFilter: true,
        },
        {
            id: "discount",
            accessorFn: (row) => `${row.discountAmount > 0 ? row.discountAmount : `${row.percentageDiscount}%`}`,
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("discount")} />
            ),
            cell: ({ cell }) => (
                <span className="font-semibold">
                    {cell.getValue<number>()}
                </span>
            ),
            meta: {
                label: t("discount"),
            },
            enableColumnFilter: true,
            enableSorting: true,
        },

        // {
        //     id: "minimum",
        //     accessorKey: "minimum",
        //     header: ({ column }: { column: Column<DiscountCode, unknown> }) => (
        //         <DataTableColumnHeader column={column} label={t("minimum")} />
        //     ),
        // },

        {
            id: "maxTrips",
            accessorKey: "maxTrips",
            header: ({ column }: { column: Column<DiscountCode, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("maxTrips")} />
            ),
        },

        {
            id: "remainingTrips",
            accessorKey: "remainingTrips",
            header: ({ column }: { column: Column<DiscountCode, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("remainingTrips")} />
            ),
        },

        {
            id: "clientsUsedCount",
            accessorKey: "clientsUsedCount",
            header: ({ column }: { column: Column<DiscountCode, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("clientsUsed")} />
            ),
        },

        {
            id: "status",
            accessorKey: "status",
            header: ({ column }: { column: Column<DiscountCode, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("status")} />
            ),
            meta: {
                label: t("status"),
                variant: "multiSelect",
                options: [
                    { label: "Active", value: "active" },
                    { label: "Finished", value: "finish" },
                ],
            },
            enableColumnFilter: true,
        },

        {
            id: "startAt",
            accessorKey: "startAt",
            header: ({ column }: { column: Column<DiscountCode, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("startDate")} />
            ),
            cell: ({ cell }) =>
                new Date(cell.getValue<string>()).toLocaleDateString(),
        },

        {
            id: "expiredAt",
            accessorKey: "expiredAt",
            header: ({ column }: { column: Column<DiscountCode, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("expiredDate")} />
            ),
            cell: ({ cell }) =>
                new Date(cell.getValue<string>()).toLocaleDateString(),
        },
    ], [t]);
}