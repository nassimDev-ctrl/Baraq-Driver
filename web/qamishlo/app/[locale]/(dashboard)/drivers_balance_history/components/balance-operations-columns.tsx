"use client";

import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import { BalanceOperation } from "@/types/types";
import type { Column, ColumnDef } from "@tanstack/react-table";
import * as React from "react";
import { ArrowDownCircle, ArrowUpCircle } from "lucide-react";
import { format } from "date-fns";
import { useTranslations } from "next-intl";

export function useBalanceOperationsColumns() {
    const tOps = useTranslations("DriversBalanceHistoryPage.balance_operations.columns");
    const tOpsType = useTranslations("DriversBalanceHistoryPage.balance_operations.operationTypes");
    return React.useMemo<ColumnDef<BalanceOperation>[]>(() => [
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
            id: "_id",
            accessorKey: "_id",
            enableHiding: false,
        },
        {
            id: "driver",
            accessorKey: "driverId",
            header: ({ column }: { column: Column<BalanceOperation, unknown> }) => (
                <DataTableColumnHeader column={column} label={tOps("driver")} />
            ),
            cell: ({ row }) => {
                const driver = row.original.driverId;
                return (
                    <span>
                        {driver?.firstName} {driver?.lastName}
                    </span>
                );
            },
            meta: {
                label: tOps("driver"),
            }
        },
        {
            id: "operation",
            accessorKey: "operation",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={tOps("operation")} />
            ),
            cell: ({ cell }) => {
                const operation = cell.getValue<BalanceOperation["operation"]>();
                const isCharge = operation === "charge";
                const Icon = isCharge ? ArrowUpCircle : ArrowDownCircle;

                return (
                    <div className="flex items-center gap-2">
                        <Icon
                            className={`size-4 ${isCharge ? "text-green-600" : "text-red-600"
                                }`}
                        />
                        <span className="capitalize">{tOpsType(operation)}</span>
                    </div>
                );
            },
            meta: {
                label: tOps("operation"),
                variant: "multiSelect",
                options: [
                    { label: tOpsType("charge"), value: "charge" },
                    { label: tOpsType("withdraw"), value: "withdraw" },
                ],
            },
            enableColumnFilter: true,
        },
        {
            id: "balance",
            accessorKey: "balance",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={tOps("amount")} />
            ),
            cell: ({ cell }) => {
                const value = cell.getValue<number>();
                return <span>{value.toLocaleString()} </span>;
            },
            meta: {
                label: tOps("amount"),
            }
        },
        {
            id: "createdAt",
            accessorKey: "createdAt",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={tOps("createdAt")} />
            ),
            cell: ({ cell }) => {
                const date = cell.getValue<string>();
                return <span>{format(new Date(date), "yyyy-MM-dd HH:mm")}</span>;
            },
            meta: {
                label: tOps("createdAt"),
                variant: "date",
            },
            enableColumnFilter: true
        },
    ], [tOps, tOpsType]);
}