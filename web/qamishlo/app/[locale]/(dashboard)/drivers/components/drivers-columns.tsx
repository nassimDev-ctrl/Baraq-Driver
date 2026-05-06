"use client";
import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import { Badge } from "@/components/ui/badge";
import { Button, buttonVariants } from "@/components/ui/button";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { cn } from "@/lib/utils";
import { City, Driver, DriverStatus } from "@/types/types";
import type { Column, ColumnDef } from "@tanstack/react-table";
import {
    CarFront,
    CheckCircle,
    CircleOff,
    Hourglass,
    MoreHorizontal,
    Snowflake,
    Text,
    XCircle
} from "lucide-react";
import { useLocale, useTranslations } from "next-intl";
import { Link } from "@/i18n/navigation";
import * as React from "react";
import { DeleteDriverDialog } from "./delete-driver";
import { BlockDriverDialog } from "./block-driver";
import UnblockDriverDialog from "./unblock-driver";
import UpdateClientNumber from "../../clients/components/update-client-number";

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


export type FinalDriverStatus =
    | DriverStatus
    | "frozen"
    | "blocked";

function getDriverStatus(
    status: DriverStatus,
    isFrozen: boolean,
    isBlocked: boolean
): FinalDriverStatus {
    if (isBlocked) return "blocked";
    if (isFrozen) return "frozen";
    return status;
}

export function useDriversColumns({ cities }: { cities: City[] }) {
    const t = useTranslations("driversPage.drivers_columns");
    const tGender = useTranslations("gender");
    const tStatus = useTranslations("driversPage.driver_status")
    const locale = useLocale();

    return React.useMemo<ColumnDef<Driver>[]>(() => [
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
            id: "id",
            accessorKey: "_id",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label="id" />
            ),
            enableHiding: false,
        },

        {
            id: "name",
            accessorFn: (row) => `${row.firstName} ${row.lastName}`,
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("fullname")} />
            ),
            cell: ({ row }) => {
                const id = row.original._id;
                const driver = row.original;
                return (
                    <Link
                        href={{ pathname: `/drivers/${id}` }}
                        className={cn(buttonVariants({ variant: "link" }), "mx-0 px-0", driver.isBlocked && "text-destructive")}
                    >
                        {row.original.firstName} {row.original.lastName}
                    </Link>
                );
            },
            meta: {
                label: t("fullname"),
                placeholder: t("name_placeholder"),
                variant: "text",
                icon: Text,
            },
            enableColumnFilter: true,
        },
        {
            id: "status",
            accessorFn: (row) =>
                getDriverStatus(row.status as DriverStatus, row.isFrozen, row.isBlocked),
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("status")} />
            ),
            cell: ({ row }) => {
                const finalStatus = row.getValue("status") as FinalDriverStatus;
                const statusVariantMap: Record<
                    FinalDriverStatus,
                    "outline" | "secondary" | "destructive"
                > = {
                    active: "outline",
                    waiting: "secondary",
                    "change-sub-category": "outline",
                    rejected: "destructive",
                    frozen: "secondary",
                    blocked: "destructive",
                };
                const Icon =
                    statusVariantMap[finalStatus] === "outline"
                        ? CheckCircle
                        : statusVariantMap[finalStatus] === "destructive"
                            ? XCircle
                            : Snowflake;
                return (
                    <Badge
                        variant={statusVariantMap[finalStatus]}
                        className="capitalize flex items-center gap-2"
                    >
                        <Icon className="size-4" />
                        <span>{tStatus(finalStatus)}</span>
                    </Badge>
                );
            },

            meta: {
                label: t("status"),
                variant: "multiSelect",
                options: [
                    { label: tStatus("active"), value: "active", icon: CheckCircle },
                    { label: tStatus("rejected"), value: "rejected", icon: XCircle },
                    { label: tStatus("frozen"), value: "frozen", icon: Snowflake },
                    { label: tStatus("waiting"), value: "waiting", icon: Hourglass },
                    { label: tStatus("blocked"), value: "blocked", icon: CircleOff },
                    { label: tStatus("change-sub-category"), value: "change-sub-category", icon: CarFront },
                ],
            },

            enableColumnFilter: true,
        },
        {
            id: "car",
            accessorFn: (row) =>
                locale === "ar" ? row.car?.category.nameAr : locale === "en" ? row.car?.category.nameEn : row.car?.category.nameKu,
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("car")} />
            ),
            cell: ({ row, cell }) => {
                const driver = row.original;
                return (
                    <CellWrapper blocked={driver.isBlocked}>
                        <div>{cell.getValue<string>()}</div>
                    </CellWrapper>
                )
            },
            meta: {
                label: t("car"),
                variant: "text",
                placeholder: t("car_placeholder"),
            },
            enableColumnFilter: true,
        },

        {
            id: "city",
            accessorKey: "city",
            header: ({ column }: { column: Column<Driver, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("city")} />
            ),
            cell: ({ row, cell }) => {
                const city = cell.getValue<Driver["city"]>();
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
            id: "gender",
            accessorKey: "gender",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("gender")} />
            ),
            cell: ({ row, cell }) => {
                const value = cell.getValue<Driver["gender"]>();
                const driver = row.original;
                return (
                    <CellWrapper blocked={driver.isBlocked}>
                        <Badge
                            className={cn(
                                value === "male" ? "bg-blue-400" : "bg-pink-400"
                            )}
                        >
                            {value}
                        </Badge>
                    </CellWrapper>
                );
            },
            meta: {
                label: t("gender"),
                variant: "multiSelect",
                options: [
                    { label: tGender("male"), value: "male" },
                    { label: tGender("female"), value: "female" },
                ],
            },
            enableColumnFilter: true,
        },

        {
            id: "mobilePhone",
            accessorKey: "authUser.mobilePhone",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("mobilePhone")} />
            ),
            cell: ({ row, cell }) => {
                const driver = row.original
                return (
                    <CellWrapper blocked={driver.isBlocked}>
                        <span className="font-mono">
                            {cell.getValue<string>()}
                        </span>
                    </CellWrapper>
                )
            },
            meta: {
                label: t("mobilePhone"),
                placeholder: t("phone_placeholder"),
                variant: "text",
            },
            enableColumnFilter: true,
        },

        {
            id: "emergencyNumber",
            accessorKey: "emergencyNumber",
            header: ({ column }: { column: Column<Driver, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("emergencyNumber")} />
            ),
            cell: ({ row, cell }) => {
                const driver = row.original;
                return (
                    <CellWrapper blocked={driver.isBlocked}>
                        {cell.getValue<Driver["emergencyNumber"]>()}
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
                const driver = row.original;
                return (
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="ghost" size="icon">
                                <MoreHorizontal className="h-4 w-4" />
                                <span className="sr-only">Open menu</span>
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="start">
                            {/* * Used the same component for both driver and client */}
                            <UpdateClientNumber clientId={driver.authUser?._id} />
                            {driver.isBlocked ? (
                                <UnblockDriverDialog driverId={driver.authUser?._id ?? ""} />
                            ) : (
                                <BlockDriverDialog driverId={driver.authUser?._id ?? ""} />
                            )}
                            <DeleteDriverDialog driverId={driver?._id ?? ""} />
                        </DropdownMenuContent>
                    </DropdownMenu>
                )
            },
            size: 32,
        },
    ], [t, tGender, locale, tStatus, cities]);
}