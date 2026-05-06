"use client";

import { DataTable } from "@/components/data-table/data-table";
import { DataTableToolbar } from "@/components/data-table/data-table-toolbar";
import { useDataTable } from "@/hooks/use-data-table";
import { CashCollection } from "@/types/types";
import { useCashCollectionColumns } from "./cash-collection-columns";
import { useCashCollectionFilter } from "../../hooks/use-cash-collection-filter";
import { ReportsTableWrapper } from "../reports-table-wrapper";

interface CashCollectionTableProps {
    data: CashCollection[];
}

export default function CashCollectionTable({ data }: CashCollectionTableProps) {
    const columns = useCashCollectionColumns();

    const { filteredData } = useCashCollectionFilter(data);

    const { table } = useDataTable({
        data: filteredData,
        columns,
        pageCount: Math.ceil(filteredData.length / 10),
        initialState: {
            pagination: {
                pageIndex: 0,
                pageSize: 10
            },
            sorting: [{ id: "driverName", desc: false }]
        },
        getRowId: (row) => row._id
    });

    return (
        <ReportsTableWrapper
            titleKey="cash_collection_title"
            data={filteredData}
            mapExportData={(rows) =>
                rows.map((row) => ({
                    Driver: row.driverName,
                    TotalTrips: row.totalTrips,
                    TotalRevenue: row.totalCashCollected,
                    Commission: row.totalCommission,
                    Submitted: row.submitted,
                    Difference: row.difference
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