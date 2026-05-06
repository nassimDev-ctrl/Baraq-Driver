import { getTranslations } from "next-intl/server";
import { Suspense } from "react";
import { getPermissions } from "@/lib/data";
import { Loader } from "@/components/loader";
import { PermissionsTable } from "./components/permissions-table";
import Unauthorized from "@/components/unauthorized";
export default async function PermissionsPage() {
    const [t, permissions] = await Promise.all([getTranslations("permissionsPage"), getPermissions()])
    if (permissions.message === "Forbidden") return <Unauthorized />;

    console.log(permissions)

    return (
        <main className="space-y-8">
            <h1 className="h1-title ">{t("title")}</h1>
            <Suspense fallback={<Loader />}>
                <PermissionsTable data={permissions} />
            </Suspense>
        </main>
    )
}