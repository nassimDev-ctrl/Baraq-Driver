"use client"

import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header"
import { Button } from "@/components/ui/button"
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuTrigger
} from "@/components/ui/dropdown-menu"
import { Group, Role } from "@/types/types"
import type { Column, ColumnDef } from "@tanstack/react-table"
import { Calendar, MoreHorizontal, Users } from "lucide-react"
import * as React from "react"
import { useTranslations } from "next-intl"
import { DeleteRoleDialog } from "./delete-role"
import EditRoleGroups from "./edit-role-groups"

export function useRolesColumns({ all_groups }: { all_groups: Group[] }) {
    const t = useTranslations("RolesPage.table.columns");
    return React.useMemo<ColumnDef<Role>[]>(() => [
        {
            id: "name",
            accessorKey: "name",
            header: ({ column }: { column: Column<Role, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("name")} />
            ),
            cell: ({ cell }) => (
                <div className="flex items-center gap-2">
                    <Users className="h-4 w-4 text-muted-foreground" />
                    {cell.getValue<string>()}
                </div>
            ),
        },
        {
            id: "groups",
            accessorKey: "groups",
            header: ({ column }: { column: Column<Role, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("groups")} />
            ),
            cell: ({ row }) => {
                const groups = row.original.groups
                return (
                    <div className="flex flex-wrap gap-1">
                        {groups?.map((group) => (
                            <span
                                key={group._id}
                                className="px-2 py-1 text-xs rounded-md bg-muted"
                            >
                                {group.name}
                            </span>
                        ))}
                    </div>
                )
            },
            meta: {
                label: t("groups"),
                variant: "multiSelect",
                options: all_groups.map((group) => ({
                    label: group.name,
                    value: group._id,
                })),

            },
            enableColumnFilter: true,
        },
        {
            id: "createdAt",
            accessorKey: "createdAt",
            header: ({ column }: { column: Column<Role, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("created_at")} />
            ),
            cell: ({ cell }) => {
                const date = new Date(cell.getValue<Date>())
                return (
                    <div className="flex items-center gap-1">
                        <Calendar className="h-4 w-4 text-muted-foreground" />
                        {date.toLocaleDateString()}
                    </div>
                )
            },
            meta: {
                label: t("created_at"),
                variant: "date",
            },
            enableColumnFilter: true,
        },
        {
            id: "actions",
            cell: ({ row }) => {
                const role = row.original;

                return (
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="ghost" size="icon">
                                <MoreHorizontal className="size-4" />
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="start">
                            <EditRoleGroups
                                roleId={role._id}
                                groups={role.groups}
                                allGroups={all_groups}
                            />
                            <DeleteRoleDialog roleId={role._id} />
                        </DropdownMenuContent>
                    </DropdownMenu>
                );
            },
            size: 32,
        },
    ], [all_groups, t])
}