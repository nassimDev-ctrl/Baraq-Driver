"use client";

import { DataTableColumnHeader } from "@/components/data-table/data-table-column-header";
import type { ColumnDef, Column } from "@tanstack/react-table";
import { Complaint } from "@/types/types";
import { useTranslations } from "next-intl";
import React from "react";
import { Badge } from "@/components/ui/badge";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { MoreHorizontal } from "lucide-react";
import { Button } from "@/components/ui/button";
// TODO: wrong path --- must be fixed
import { MarkComplainAsRead } from "../../emergencies/components/mark-complain-as-read";
import { ImageCell } from "./image-cell";
import { formatDate } from "@/lib/utils";

export function useComplaintsColumns() {
    const t = useTranslations("complaints_columns");

    return React.useMemo<ColumnDef<Complaint>[]>(() => [
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
            id: "note",
            accessorKey: "note",
            header: ({ column }: { column: Column<Complaint, unknown> }) => (
                <DataTableColumnHeader column={column} label={t("note")} />
            ),
            meta: {
                label: t("note"),
                variant: "text",
            },
            enableColumnFilter: true,
        },
        {
            id: "mobilePhone",
            accessorFn: (row) => row?.mobilePhone ?? "",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("phone")} />
            ),
            meta: {
                label: t("phone"),
                variant: "text",
            },
            enableColumnFilter: true,
        },
        {
            id: "isRead",
            accessorKey: "isRead",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("status")} />
            ),
            cell: ({ row }) => (
                row.original.isRead ? (
                    <Badge variant="secondary">{t("read")}</Badge>
                ) : (
                    <Badge variant="destructive">{t("unread")}</Badge>
                )
            ),
            meta: {
                label: t("status"),
                variant: "multiSelect",
                options: [
                    { label: t("read"), value: "true" },
                    { label: t("unread"), value: "false" },
                ],
            },
            enableColumnFilter: true,
        },
        {
            id: "image",
            accessorKey: "image",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("image")} />
            ),
            cell: ({ row }) => (
                <ImageCell src={row.original.image} />
            ),
            enableColumnFilter: false,
        },
        {
            id: "createdAt",
            accessorKey: "createdAt",
            header: ({ column }) => (
                <DataTableColumnHeader column={column} label={t("createdAt")} />
            ),
            cell: ({ row }) => formatDate(row.original.createdAt),
            enableColumnFilter: false,
        },
        {
            id: "actions",
            cell: ({ row }) => {
                const complaint = row.original;

                if (complaint.isRead) return null;

                return (
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="ghost" size="icon">
                                <MoreHorizontal className="h-4 w-4" />
                            </Button>
                        </DropdownMenuTrigger>

                        <DropdownMenuContent align="start">
                            <MarkComplainAsRead complaintId={complaint._id} />
                        </DropdownMenuContent>
                    </DropdownMenu>
                );
            },
            size: 32,
        }
    ], [t]);
}