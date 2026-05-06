"use client";

import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import { Button } from "@/components/ui/button";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Admin, Role } from "@/types/types";
import type { Column, ColumnDef } from "@tanstack/react-table";
import { MoreHorizontal } from "lucide-react";
import * as React from "react";
import { DeleteAdmin } from "./delete-admin";

import { useTranslations } from "next-intl";
import EditAdminRoles from "./update-admin-roles";

export function useAdminsColumns(allRoles: Role[]) {
    const t = useTranslations("EmployeesPage.admins_table");
    return React.useMemo<ColumnDef<Admin>[]>(() => [
        {
            id: "index",
            header: () => (
                <div className="w-8 px-8 text-right font-medium">
                    {t("columns.index")}
                </div>
            ),
            cell: ({ table, row }) => {
                const rowIndex = table
                    .getRowModel()
                    .rows.findIndex(r => r.id === row.id);

                return (
                    <div className="w-8 px-8 text-right text-muted-foreground">
                        {rowIndex + 1}
                    </div>
                );
            },
            enableSorting: false,
            enableColumnFilter: false,
            size: 40,
        },
        {
            id: "_id",
            accessorKey: "_id",
            header: ({ column }: { column: Column<Admin, unknown> }) => (
                <DataTableColumnHeader column={column} label="ID" />
            ),
            enableHiding: false,
        },
        {
            id: "fullname",
            accessorFn: (row) => `${row.firstName} ${row.lastName}`,
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("columns.full_name")} />
            ),
            cell: ({ row }) => {
                const admin = row.original;

                return (
                    <div>
                        {admin.firstName} {admin.lastName}
                    </div>
                );
            },
            meta: {
                label: t("columns.full_name"),
                placeholder: t("filters.search_name"),
                variant: "text",
            },
            enableColumnFilter: true,
        },
        {
            id: "email",
            accessorKey: "email",
            header: ({ column }: { column: Column<Admin, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("columns.email")} />
            ),
            meta: {
                label: t("columns.email"),
                placeholder: t("filters.search_email"),
                variant: "text",
            },
            enableColumnFilter: true,
        },
        {
            id: "roles",
            accessorFn: (row) =>
                row.roles.map((r) => r.name).join(", "),
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("columns.roles")} />
            ),
            cell: ({ row }) => {
                const roles = row.original.roles
                return (
                    <div className="flex flex-wrap gap-1">
                        {roles.map((role) => (
                            <span
                                key={role._id}
                                className="px-2 py-1 text-xs rounded-md bg-muted"
                            >
                                {role.name}
                            </span>
                        ))}
                    </div>
                )
            },
            meta: {
                label: t("columns.roles"),
                placeholder: t("filters.search_role"),
                variant: "text",
            },
            enableColumnFilter: true,
        },
        {
            id: "createdAt",
            accessorKey: "createdAt",
            header: ({ column }: { column: Column<Admin, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("columns.created_at")} />
            ),
            cell: ({ cell }) =>
                new Date(cell.getValue<Date>()).toLocaleDateString(),
        },
        {
            id: "actions",
            cell: ({ row }) => {
                const admin = row.original;
                return (
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="ghost" size="icon">
                                <MoreHorizontal className="h-4 w-4" />
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="start">
                            <EditAdminRoles adminId={admin._id} roles={admin.roles} allRoles={allRoles} />
                            <DeleteAdmin id={admin._id} />
                        </DropdownMenuContent>
                    </DropdownMenu>
                );
            },
            size: 32,
        },
    ], [allRoles, t]);
}
