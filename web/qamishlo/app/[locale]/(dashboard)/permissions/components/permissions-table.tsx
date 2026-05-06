"use client";

import { DataTable } from "@/components/data-table/data-table";
import { useDataTable } from "@/hooks/use-data-table";
import { Permission } from "@/types/types";
import { getPaginationRowModel } from "@tanstack/react-table";
import { usePermissionsColumns } from "./use-permission-columns";
interface PermissionsTableProps {
    data: Permission[];
}

export function PermissionsTable({ data }: PermissionsTableProps) {
    const columns = usePermissionsColumns();

    const { table } = useDataTable({
        data,
        columns,
        pageCount: Math.ceil(data?.length / 10),
        getPaginationRowModel: getPaginationRowModel(),
        initialState: {
            pagination: {
                pageIndex: 0,
                pageSize: 10,
            },
        },
        getRowId: (row) => row._id,
    });

    return (
        <div className="data-table-container">
            <DataTable table={table} />
        </div>
    );
}