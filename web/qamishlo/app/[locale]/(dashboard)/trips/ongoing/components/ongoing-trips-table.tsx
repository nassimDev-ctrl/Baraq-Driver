"use client";
import { City, OngoingTrip } from "@/types/types";
import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import useOngoingTripsColumns from "./ongoing-trips-columns";
import { useOngoingTripsFilter } from "../hooks/use-ongoing-trips-filter";

export default function OngoingTripsTable({ data, cities }: { data: OngoingTrip[]; cities: City[] }) {
    const { filteredData } = useOngoingTripsFilter(data);
    const columns = useOngoingTripsColumns({ cities });
    const { table } = useDataTable({
        data: filteredData,
        columns,
        pageCount: Math.ceil(filteredData.length / 10),
        initialState: {
            pagination: {
                pageIndex: 0,
                pageSize: 10
            },
            // sorting: [{ id: "createdAt", desc: true }],
            columnPinning: { right: ["actions"] },
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