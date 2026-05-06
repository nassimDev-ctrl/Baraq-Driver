"use client";

import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import { TripComparison } from "@/types/types";
import { ReportsTableWrapper } from "../reports-table-wrapper";
import { useComparisonColumns } from "./use-comparison-columns";

interface ComparisonTableProps {
    data: TripComparison[];
}

export default function ComparisonTable({ data }: ComparisonTableProps) {
    const columns = useComparisonColumns();

    const { table } = useDataTable({
        data,
        columns,
        pageCount: Math.ceil(data.length / 10),
        initialState: {
            pagination: { pageIndex: 0, pageSize: 10 },
            sorting: [{ id: "tripType", desc: false }],
        },
        getRowId: (row) => row._id ?? Math.random().toString()
    });

    return (
        <ReportsTableWrapper
            titleKey="comparison_title"
            data={data}
            mapExportData={(rows) =>
                rows.map((row) => ({
                    ["trip_type"]: row.tripType,
                    ["total_trips"]: row.totalTrips,
                    ["total_revenue"]: row.totalRevenue,
                    ["avg_price"]: row.avgPrice,
                    ["percentage"]: `${row.percentage}%`
                }))
            }
        >

            <div className="data-table-container">
                <DataTable table={table}>
                    <DataTableToolbar table={table} />
                </DataTable>
            </div>
        </ReportsTableWrapper>
    );
}