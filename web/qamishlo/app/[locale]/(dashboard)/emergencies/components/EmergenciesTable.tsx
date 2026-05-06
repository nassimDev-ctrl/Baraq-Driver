"use client";

import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import { useEmergenciesColumns } from "./emergencies-columns";
import { useEmergenciesFilter } from "../hooks/use-emergencies-filter";
import { City, Emergency } from "@/types/types";

interface EmergenciesTableProps {
    data: Emergency[];
    cities: City[]
}

export default function EmergenciesTable({ data, cities }: EmergenciesTableProps) {
    const { filteredData } = useEmergenciesFilter(data);
    const columns = useEmergenciesColumns({ cities });


    const { table } = useDataTable({
        data: filteredData,
        columns,
        pageCount: Math.ceil(filteredData.length / 10),
        initialState: {
            pagination: {
                pageIndex: 0,
                pageSize: 10
            },
            // sorting: [{ id: "status", desc: false }],
            // sorting: [{ id: "_id", desc: true }],
            columnPinning: { right: ["actions"] },
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
