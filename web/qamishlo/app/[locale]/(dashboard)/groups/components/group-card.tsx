import { Group, Permission } from "@/types/types"
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { DeleteGroup } from "./delete-group";
import PermissionsView from "./permissions-view";

interface GroupCardProps {
    group: Group;
    allPermissions: Permission[];
}

export default async function GroupCard({ group, allPermissions }: GroupCardProps) {

    return (
        <Card className="relative">
            <CardHeader className="flex flex-row items-center justify-between">
                <div className="w-full flex items-center justify-between gap-2">
                    <h3 className="font-semibold">{group.name}</h3>
                    {!group.readOnly && <DeleteGroup id={group._id} />}
                </div>
            </CardHeader>
            <CardContent>
                <PermissionsView
                    permissions={allPermissions}
                    group_id={group._id}
                    group_permissions={group.permissions}
                />
            </CardContent>
        </Card>
    )
}