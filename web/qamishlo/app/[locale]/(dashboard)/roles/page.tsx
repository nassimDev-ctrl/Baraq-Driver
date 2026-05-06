import { Suspense } from "react";
import { Loader } from "@/components/loader";
import { getGroups, getRoles } from "@/lib/data";
import { CreateRole } from "./components/create-role";
import { getTranslations } from "next-intl/server";
import RolesTable from "./components/roles-table";
import Unauthorized from "@/components/unauthorized";
import { filterGroups } from "@/lib/utils";

export default async function RolesPage() {
    const [roles, groups, t] = await Promise.all([
        getRoles(),
        getGroups(),
        getTranslations("RolesPage")
    ]);
    if (groups.message === "Forbidden" || roles.message === "Forbidden") return <Unauthorized />;

    const filteredGroups = filterGroups(groups);

    return (
        <main className="space-y-8">
            <div className="flex items-center justify-between">
                <h1 className="h1-title text-start flex-1">{t("title")}</h1>
                <CreateRole groups={filteredGroups} />
            </div>
            <Suspense fallback={<Loader />}>
                <RolesTable data={roles} groups={filteredGroups} />
            </Suspense>
        </main>
    )
}