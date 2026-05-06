"use client";

import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import { Button, buttonVariants } from "@/components/ui/button";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { cn } from "@/lib/utils";
import { City, Client } from "@/types/types";
import type { Column, ColumnDef } from "@tanstack/react-table";
import { Mars, MoreHorizontal, Venus } from "lucide-react";
import { useLocale, useTranslations } from "next-intl";
import { Link } from "@/i18n/navigation";
import * as React from "react";
import { DeleteClientDialog } from "./delete-client";
import { BlockClientDialog } from "./block-client";
import UnblockClientDialog from "./unblock-client";
import UpdateClientNumber from "./update-client-number";


const CellWrapper = ({
    blocked,
    children,
}: {
    blocked: boolean;
    children: React.ReactNode;
}) => (
    <div
        className={cn(
            "-mx-2 -my-1 px-2 py-1 rounded",
            blocked && "text-destructive"
        )}
    >
        {children}
    </div>
);

export function useClientsColumns({ cities }: { cities: City[] }) {
    const t = useTranslations("client_columns");
    const tGen = useTranslations("gender");
    const locale = useLocale();
    return React.useMemo<ColumnDef<Client>[]>(() => [
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
            header: ({ column }: { column: Column<Client, unknown> }) => (
                <DataTableColumnHeader column={column} label="_id" />
            ),
            enableHiding: false,
            cell: ({ getValue }) => (
                getValue<string>()
            ),
        },
        {
            id: "fullname",
            accessorFn: (row) => `${row.firstName} ${row.lastName}`,
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("fullname")} />
            ),
            cell: ({ row }) => {
                const client = row.original;
                return (
                    <Link
                        href={{ pathname: `clients/client-trips/${client._id}` }}
                        className={cn(
                            buttonVariants({ variant: "link" }),
                            "mx-0 px-0",
                            client.isBlocked && "text-destructive"
                        )}
                    >
                        {client.firstName} {client.lastName}
                    </Link>
                );
            },
            meta: {
                label: t("fullname"),
                placeholder: t("fullNamePlaceholder"),
                variant: "text",
            },
            enableColumnFilter: true,
        },
        {
            id: "gender",
            accessorKey: "gender",
            header: ({ column }: { column: Column<Client, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("gender")} />
            ),
            cell: ({ row, cell }) => {
                const gender = cell.getValue<Client["gender"]>();
                const Icon = gender === "female" ? Venus : Mars;
                const client = row.original;
                return (
                    <CellWrapper blocked={client.isBlocked}>
                        <div className="flex items-center gap-1">
                            <Icon className="size-4" />
                            {tGen(gender)}
                        </div>
                    </CellWrapper>
                );
            },
            meta: {
                label: t("gender"),
                variant: "multiSelect",
                options: [
                    { label: tGen("male"), value: "male" },
                    { label: tGen("female"), value: "female" },
                ],
            },
            enableColumnFilter: true,
        },
        {
            id: "city",
            accessorKey: "city",
            header: ({ column }: { column: Column<Client, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("city")} />
            ),
            cell: ({ row, cell }) => {
                const city = cell.getValue<Client["city"]>();
                const client = row.original;
                return (
                    <CellWrapper blocked={client.isBlocked}>
                        {city && locale === "ar" ? city.nameAr : locale === "en" ? city.nameEn : city.nameKu}
                    </CellWrapper>
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
            id: "phoneNumber",
            accessorKey: "authUser.mobilePhone",
            header: ({ column }: { column: Column<Client, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("phoneNumber")} />
            ),
            cell: ({ row, cell }) => {
                const client = row.original;
                return (
                    <CellWrapper blocked={client.isBlocked}>
                        {cell.getValue<Client["authUser"]["mobilePhone"]>()}
                    </CellWrapper>
                )
            },
            meta: {
                label: t("phoneNumber"),
                placeholder: t("phoneNumberPlaceholder"),
                variant: "text",
            },
            enableColumnFilter: true,
        },
        {
            id: "emergencyNumber",
            accessorKey: "emergencyNumber",
            header: ({ column }: { column: Column<Client, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("emergencyNumber")} />
            ),
            cell: ({ row, cell }) => {
                const client = row.original;
                return (
                    <CellWrapper blocked={client.isBlocked}>
                        {cell.getValue<Client["emergencyNumber"]>()}
                    </CellWrapper>
                )
            },
            meta: {
                label: t("emergencyNumber"),
            },
            enableColumnFilter: false,
        },
        {
            id: "actions",
            cell: ({ row }) => {
                const client = row.original;

                return (
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="ghost" size="icon">
                                <MoreHorizontal className="h-4 w-4" />
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="start">
                            <UpdateClientNumber clientId={client.authUser?._id} />
                            {client.isBlocked ? (
                                <UnblockClientDialog userId={client.authUser?._id} />
                            ) : (
                                <BlockClientDialog userId={client.authUser?._id} />
                            )}

                            <DeleteClientDialog userId={client?._id} />
                        </DropdownMenuContent>
                    </DropdownMenu>
                );
            },
            size: 32,
        },
    ], [t, locale, cities, tGen]);
}
