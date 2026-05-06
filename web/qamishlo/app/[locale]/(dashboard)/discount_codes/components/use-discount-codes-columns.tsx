"use client";

import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { City, DiscountCode } from "@/types/types";
import type { Column, ColumnDef } from "@tanstack/react-table";
import {
    CalendarClock,
    CheckCircle2,
    MoreHorizontal,
    XCircle,
} from "lucide-react";
import { useTranslations } from "next-intl";
import * as React from "react";
import { DeleteDiscountCode } from "./delete-discount-code";
import CityView from "./city-view";
// import CategoryView from "./category-view";
import UpdateDiscountCodeDialog from "./update-discount-code";

interface Props {
    allCities: City[]
    // categories: Category[] //* removed for now
}

export function useDiscountCodeColumns({ allCities }: Props) {
    const t = useTranslations("discountCodePage.discountCodesTable");

    return React.useMemo<ColumnDef<DiscountCode>[]>(() => [
        {
            id: "code",
            accessorKey: "code",
            header: ({ column }: { column: Column<DiscountCode, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("code")} />
            ),
            meta: {
                label: t("code"),
                placeholder: t("searchCode"),
                variant: "text",
            },
            enableColumnFilter: true,
        },
        {
            id: "discountAmount",
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
        {
            id: "usage",
            accessorKey: "maxTrips",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("usage")} />
            ),
            meta: {
                label: t("usage"),
            },
        },
        {
            id: "minimum",
            accessorKey: "minimum",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("minimum")} />
            ),
            meta: {
                label: t("minimum"),
            },
        },
        {
            id: "cities",
            accessorFn: (row) => row.cities.length === 0 ? t("all") : `${row.cities.length} ${t("city")}`,
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("cities")} />
            ),
            cell: ({ row }) => {
                return (
                    <CityView
                        discountCodeId={row.original._id}
                        cities={row.original.cities}
                        allCities={allCities}
                    />
                );
            },
            meta: {
                label: t("city"),
            },
        },
        // {
        //     id: "categories",
        //     accessorFn: (row) => row.categories.length,
        //     header: ({ column }) => (
        //         <DataTableColumnHeader column={column} label={t("categories")} />
        //     ),
        //     cell: ({ row }) => {
        //         return (
        //             <CategoryView
        //                 discountCodeId={row.original._id}
        //                 categories={row.original.categories}
        //                 allCategories={categories}
        //             />
        //         );
        //     },
        //     meta: {
        //         label: t("categories"),
        //     },
        // },
        {
            id: "status",
            accessorKey: "status",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("status")} />
            ),
            cell: ({ row }) => {
                const status = row.original.status;
                const expired =
                    new Date(row.original.expiredAt) < new Date();

                if (expired) {
                    return (
                        <Badge variant="destructive">
                            <XCircle className="mr-1 h-4 w-4" />
                            {t("expired")}
                        </Badge>
                    );
                }

                return (
                    <Badge
                        variant={status === "active" ? "outline" : "secondary"}
                    >
                        {status === "active" ? (
                            <CheckCircle2 className="mr-1 h-4 w-4" />
                        ) : (
                            <CalendarClock className="mr-1 h-4 w-4" />
                        )}
                        {t(status)}
                    </Badge>
                );
            },
            meta: {
                label: t("status"),
                variant: "multiSelect",
                options: [
                    { label: t("active"), value: "active" },
                    { label: t("finish"), value: "finish" },
                ],
            },
            enableColumnFilter: true,
        },
        {
            id: "StartedAt",
            accessorKey: "startAt",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("startedAt")} />
            ),
            cell: ({ cell }) => {
                const date = new Date(cell.getValue<Date>());
                return date.toLocaleDateString();
            },
            meta: {
                label: t("startedAt"),
            },
            enableSorting: true,
        },
        {
            id: "expiredAt",
            accessorKey: "expiredAt",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("expiryDate")} />
            ),
            cell: ({ cell }) => {
                const date = new Date(cell.getValue<Date>());
                return date.toLocaleDateString();
            },
            meta: {
                label: t("expiryDate"),
            },
            enableSorting: true,
        },
        {
            id: "actions",
            cell: ({ row }) => {
                const discountCode = row.original;

                return (
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="ghost" size="icon">
                                <MoreHorizontal className="h-4 w-4" />
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="start">
                            <UpdateDiscountCodeDialog discountCodeId={discountCode._id} initialData={discountCode} />
                            <DeleteDiscountCode discountCodeId={discountCode._id} />
                        </DropdownMenuContent>
                    </DropdownMenu>
                );
            },
            size: 32,
        },
    ], [t, allCities]);
}
