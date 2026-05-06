"use client"

import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header"
import { City, Notifications } from "@/types/types"
import type { Column, ColumnDef } from "@tanstack/react-table"
import { useTranslations } from "next-intl"
import * as React from "react"
import CitiesViewOnly from "./cities-view"

interface Props {
    allCities: City[]
    // categories: Category[]
}

export function useNotificationsColumns({ allCities }: Props) {
    const t = useTranslations("notificationColumns");
    return React.useMemo<ColumnDef<Notifications>[]>(() => [
        {
            id: "index",
            header: () => (
                <div className="size-8 text-right font-medium">
                    #
                </div>
            ),
            cell: ({ row }) => (
                <div className="size-8 text-right text-muted-foreground">
                    {row.index + 1}
                </div>
            ),
            size: 48,
            enableSorting: false,
        },
        {
            id: "titleAr",
            accessorKey: "titleAr",
            header: ({ column }: { column: Column<Notifications, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("titleAr")} />
            ),
            cell: ({ cell }) => (
                <div className="flex items-center gap-2 max-w-25 truncate">
                    {cell.getValue<string>()}
                </div>
            ),
            meta: {
                label: t("titleAr")
            }
        },
        {
            id: "titleEn",
            accessorKey: "titleEn",
            header: ({ column }: { column: Column<Notifications, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("titleEn")} />
            ),
            cell: ({ cell }) => (
                <div className="flex items-center gap-2 max-w-25 truncate">
                    {cell.getValue<string>()}
                </div>
            ),
            meta: {
                label: t("titleEn")
            }
        },
        {
            id: "titleKu",
            accessorKey: "titleKu",
            header: ({ column }: { column: Column<Notifications, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("titleKmr")} />
            ),
            cell: ({ cell }) => (
                <div className="flex items-center gap-2 max-w-25 truncate">
                    {cell.getValue<string>()}
                </div>
            ),
            meta: {
                label: t("titleAr")
            }
        },
        {
            id: "messageAr",
            accessorKey: "messageAr",
            header: ({ column }: { column: Column<Notifications, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("messageAr")} />
            ),
            cell: ({ cell }) => (
                <div className="max-w-45 whitespace-normal wrap-break-word line-clamp-none">
                    {cell.getValue<string>()}
                </div>
            ),
            meta: {
                label: t("messageAr")
            }
        },
        {
            id: "messageEn",
            accessorKey: "messageEn",
            header: ({ column }: { column: Column<Notifications, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("messageEn")} />
            ),
            cell: ({ cell }) => (
                <div className="max-w-45 whitespace-normal wrap-break-word line-clamp-none">
                    {cell.getValue<string>()}
                </div>
            ),
            meta: {
                label: t("messageEn")
            }
        },
        {
            id: "messageKu",
            accessorKey: "messageKu",
            header: ({ column }: { column: Column<Notifications, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("messageKmr")} />
            ),
            cell: ({ cell }) => (
                <div className="max-w-45 whitespace-normal wrap-break-word line-clamp-none">
                    {cell.getValue<string>()}
                </div>
            ),
            meta: {
                label: t("titleAr")
            }
        },
        {
            id: "cities",
            accessorKey: "cities",
            header: ({ column }: { column: Column<Notifications, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("governorate")} />
            ),
            cell: ({ row }) => (
                <div className="flex items-center gap-1">
                    <CitiesViewOnly cities={row.original.cities} allCities={allCities} />
                </div>
            ),
            meta: {
                label: t("governorate"),
                variant: "multiSelect",
            },
            // enableColumnFilter: true,
        },
        {
            id: "target",
            accessorKey: "usersType",
            header: ({ column }: { column: Column<Notifications, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("target")} />
            ),
            cell: ({ cell }) => {
                const value = cell.getValue<string>();
                return (
                    <div className="flex items-center gap-1">
                        {t(value)}
                    </div>
                );
            },
            meta: {
                label: t("target"),
            }

        },
        // {
        //     id: "subCategories",
        //     accessorFn: (row) => row.subCategories.length,
        //     header: ({ column }) => (
        //         <DataTableColumnHeader column={column} label={t("categories")} />
        //     ),
        //     cell: ({ row }) => {
        //         return (
        //             <SubCategoryViewOnly
        //                 selectedSubs={row.original.subCategories}
        //                 categories={categories}
        //                 isVip={row.original.isVip}
        //             />
        //         );
        //     },
        //     meta: {
        //         label: t("categories"),
        //     },
        // },
        {
            id: "createdAt",
            accessorKey: "createdAt",
            header: ({ column }: { column: Column<Notifications, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("createdAt")} />
            ),
            cell: ({ cell }) => {
                const date = new Date(cell.getValue<Date>());
                return (
                    <div className="flex items-center gap-1">
                        {date.toLocaleDateString()}
                    </div>
                )
            },
            meta: {
                label: t("createdAt"),
                variant: "date",
            },
            enableColumnFilter: true,
        },
    ], [t, allCities])
}
