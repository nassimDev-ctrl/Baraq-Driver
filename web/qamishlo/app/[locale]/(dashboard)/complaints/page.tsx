import { Loader } from "@/components/loader";
import { getComplaints } from "@/lib/data";
import { Suspense } from "react";
import { getTranslations } from "next-intl/server";
import ComplaintsTable from "./components/complaint-table";
import Unauthorized from "@/components/unauthorized";


export default async function ComplaintsPage() {
    const [complaints, t] = await Promise.all([getComplaints(), getTranslations("complaintsPage")]);
    if (complaints.message === "Forbidden") return <Unauthorized />;
    return (
        <main className="md:px-4 space-y-8">
            <h1 className="h1-title mt-8">{t("complaints")}</h1>
            <Suspense fallback={<Loader />}>
                <ComplaintsTable data={complaints} />
            </Suspense>
        </main>
    );
}