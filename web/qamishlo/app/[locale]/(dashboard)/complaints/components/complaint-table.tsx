"use client";

import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import { Complaint } from "@/types/types";
import { useComplaintsFilter } from "../hooks/use-complaints-filter";
import { useComplaintsColumns } from "./complaints-columns";

interface ComplaintsTableProps {
    data: Complaint[];
}

export default function ComplaintsTable({ data }: ComplaintsTableProps) {
    const { filteredData } = useComplaintsFilter(data);
    const columns = useComplaintsColumns();

    const { table } = useDataTable({
        data: filteredData,
        columns,
        pageCount: Math.ceil(filteredData.length / 10),
        initialState: {
            pagination: {
                pageIndex: 0,
                pageSize: 10
            },
            sorting: [{ id: "createdAt", desc: true }],
            columnVisibility: {},
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