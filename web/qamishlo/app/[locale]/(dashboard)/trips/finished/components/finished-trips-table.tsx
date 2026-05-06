"use client";

import { City, FinishedTrips } from "@/types/types";
import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import useFinishedTripsColumns from "./finished-trips-columns";
import { useFinishedTripsFilter } from "../hooks/use-finished-trips-filter";

export default function FinishedTripsTable({
    data,
    cities
}: {
    data: FinishedTrips[];
    cities: City[];
}) {
    const { filteredData } = useFinishedTripsFilter(data);
    const columns = useFinishedTripsColumns({ cities });

    const { table } = useDataTable({
        data: filteredData,
        columns,
        pageCount: Math.ceil(filteredData.length / 10),
        initialState: {
            pagination: {
                pageIndex: 0,
                pageSize: 10
            },
            // sorting: [{ id: "index", desc: true }],
        },
        getRowId: (row) => row._id,
    });

    return (
        <div className="data-table-container space-x-8">
            <DataTable table={table}>
                <DataTableToolbar table={table} />
            </DataTable>
        </div>
    );
}
