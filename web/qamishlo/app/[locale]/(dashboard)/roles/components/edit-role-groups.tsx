"use client";

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
    Dialog,
    DialogContent,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialog";
import { DropdownMenuItem } from "@/components/ui/dropdown-menu";
import { Spinner } from "@/components/ui/spinner";
import { updateRoleGroups } from "@/lib/actions";
import { Group } from "@/types/types";
import { X } from "lucide-react";
import { useTranslations } from "next-intl";
import { useMemo, useState } from "react";
import { toast } from "sonner";

interface EditRoleGroupsProps {
    roleId: string;
    groups: Group[];
    allGroups: Group[];
}

export default function EditRoleGroups({
    roleId,
    groups,
    allGroups,
}: EditRoleGroupsProps) {
    const [open, setOpen] = useState(false);
    const [selectedGroups, setSelectedGroups] = useState<Group[]>(groups);
    const [loading, setLoading] = useState(false);
    const t = useTranslations("RolesPage.edit_role_groups");

    // Reset state when dialog opens
    const handleOpenChange = (value: boolean) => {
        setOpen(value);
        if (value) {
            setSelectedGroups(groups);
        }
    };

    const handleAdd = (group: Group) => {
        if (!selectedGroups?.some((g) => g._id === group._id)) {
            setSelectedGroups([...selectedGroups, group]);
        }
    };

    const handleRemove = (groupId: string) => {
        setSelectedGroups((prev) =>
            prev.filter((g) => g._id !== groupId)
        );
    };

    const availableGroups = useMemo(() => {
        return allGroups.filter(
            (group) => !selectedGroups?.some((g) => g._id === group._id)
        );
    }, [allGroups, selectedGroups]);

    const handleSave = async () => {
        setLoading(true);

        // Original IDs
        const originalIds = groups?.map((g) => g._id);

        // Updated IDs
        const newIds = selectedGroups?.map((g) => g._id);

        // Compute difference
        const add = newIds.filter((id) => !originalIds.includes(id));
        const remove = originalIds.filter((id) => !newIds.includes(id));

        setOpen(false);
        const res = await updateRoleGroups(roleId, add, remove);
        if (res.status) {
            toast.success(t("success"));
        } else {
            toast.error(t("error"));
        }
        setLoading(false);
    };

    return (
        <Dialog open={open} onOpenChange={handleOpenChange}>
            <DialogTrigger asChild>
                <DropdownMenuItem
                    onSelect={(e) => e.preventDefault()}
                >
                    {t("edit")}
                </DropdownMenuItem>
            </DialogTrigger>

            <DialogContent className="max-w-lg">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                {/* Selected Groups */}
                <div>
                    <h3 className="mb-2 font-medium">{t("current_groups")}</h3>
                    <div className="flex flex-wrap gap-2">
                        {selectedGroups?.map((group) => (
                            <Badge key={group._id} className="flex items-center gap-2" onClick={() => handleRemove(group._id)}>
                                {group.name}
                                <X
                                    className="h-4 w-4 cursor-pointer"

                                />
                            </Badge>
                        ))}
                        {selectedGroups?.length === 0 && (
                            <p className="text-sm text-muted-foreground">
                                {t("no_groups")}
                            </p>
                        )}
                    </div>
                </div>

                {/* Add Groups */}
                <div className="mt-6">
                    <h3 className="mb-2 font-medium">{t("add_group")}</h3>
                    <div className="flex flex-wrap gap-2">
                        {availableGroups?.map((group) => (
                            <Button
                                key={group._id}
                                variant="outline"
                                size="sm"
                                onClick={() => handleAdd(group)}
                            >
                                {group.name}
                            </Button>
                        ))}
                        {availableGroups?.length === 0 && (
                            <p className="text-sm text-muted-foreground">
                                {t("no_available_groups")}
                            </p>
                        )}
                    </div>
                </div>

                <DialogFooter className="mt-6">
                    <Button
                        variant="secondary"
                        onClick={() => setOpen(false)}
                        disabled={loading}
                    >
                        {t("cancel")}
                    </Button>
                    <Button onClick={handleSave} disabled={loading || selectedGroups?.length === 0}>
                        {loading ? <Spinner /> : t("save")}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
}
