import { Loader } from "@/components/loader";
import { getGroups, getPermissions } from "@/lib/data";
import { Group } from "@/types/types";
import { getTranslations } from "next-intl/server";
import { Suspense } from "react";
import { CreateGroup } from "./components/create-group";
import GroupCard from "./components/group-card";
import Unauthorized from "@/components/unauthorized";
import { filterGroups } from "@/lib/utils";

export default async function GroupsPage() {
    const [groups, allPermissions, t] = await Promise.all([getGroups(), getPermissions(), getTranslations("groupsPage")]);
    if (groups.message === "Forbidden" || allPermissions.message === "Forbidden") return <Unauthorized />;

    const filteredGroups = filterGroups(groups);

    return (
        <main className="space-y-8">
            <h1 className="h1-title">{t("title")}</h1>
            {/* display groups */}
            <Suspense fallback={<Loader />}>
                <div className="grid gap-4 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-4 mb-8">
                    {filteredGroups?.map((group: Group) => (
                        <GroupCard key={group._id} group={group} allPermissions={allPermissions} />
                    ))}
                    <CreateGroup permissions={allPermissions} />
                </div>
            </Suspense>
        </main>
    )
}