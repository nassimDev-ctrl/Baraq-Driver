"use client";

import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import { Admin, Role } from "@/types/types";
import { useAdminsFilter } from "../hooks/use-admin-filter";
import { useAdminsColumns } from "./use-admin-columns";

interface AdminsTableProps {
    data: Admin[];
    allRoles: Role[];
}

export default function AdminsTable({ data, allRoles }: AdminsTableProps) {
    const { filteredData } = useAdminsFilter(data);
    const columns = useAdminsColumns(allRoles);

    const { table } = useDataTable({
        data: filteredData,
        columns,
        pageCount: Math.ceil(filteredData.length / 10),
        initialState: {
            pagination: {
                pageIndex: 0,
                pageSize: 10
            },
            sorting: [{ id: "_id", desc: true }],
            columnPinning: { right: ["actions"] },
            columnVisibility: {
                _id: false,
            },
        },
        getRowId: (row) => row._id,
    });

    return (
        <div className="data-table-container">
            <DataTable table={table}>
                <DataTableToolbar table={table} />
            </DataTable>
        </div>
    );
}