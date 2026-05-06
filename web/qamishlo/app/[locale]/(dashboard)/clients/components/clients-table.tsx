"use client";

import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import { City, Client } from "@/types/types";
import { useClientsFilter } from "../hooks/use-clients-filter";
import { useClientsColumns } from "./clients-columns";

interface ClientsTableProps {
    data: Client[];
    cities: City[];
}

export default function ClientsTable({ data, cities }: ClientsTableProps) {
    const { filteredData } = useClientsFilter(data);
    const columns = useClientsColumns({ cities });
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
            <DataTable table={table} >
                <DataTableToolbar table={table} />
            </DataTable>
        </div>
    )
}