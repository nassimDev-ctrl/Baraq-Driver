import { Loader } from "@/components/loader";
import { getAdmins, getRoles } from "@/lib/data"
import { Suspense } from "react";
import AdminsTable from "./components/admins-table";
import { getTranslations } from "next-intl/server";
import { CreateAdmin } from "./components/create-admin";
import Unauthorized from "@/components/unauthorized";
export default async function EmployeesPage() {
    const [employees, roles, t] = await Promise.all([getAdmins(), getRoles(), getTranslations("EmployeesPage")]);
    if (!employees.admins || employees.message === "Forbidden" || roles.message === "Forbidden") return <Unauthorized />;
    return (
        <main className="md:px-4 space-y-8">
            <div className="flex items-center justify-between">
                <h1 className="flex-1 h1-title">{t("title")}</h1>
                <CreateAdmin roles={roles} />
            </div>
            <Suspense fallback={<Loader />}>
                <AdminsTable data={employees.admins} allRoles={roles} />
            </Suspense>
        </main >
    )
}