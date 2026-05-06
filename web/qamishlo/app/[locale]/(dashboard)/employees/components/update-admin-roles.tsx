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
import { updateAdminRoles } from "@/lib/actions";
import { Role } from "@/types/types";
import { X } from "lucide-react";
import { useTranslations } from "next-intl";
import { useMemo, useState } from "react";
import { toast } from "sonner";

interface EditAdminRolesProps {
    adminId: string;
    roles: Role[];
    allRoles: Role[];
}

export default function EditAdminRoles({
    adminId,
    roles,
    allRoles,
}: EditAdminRolesProps) {
    const [open, setOpen] = useState(false);
    const [selectedRoles, setSelectedRoles] = useState<Role[]>(roles);
    const [loading, setLoading] = useState(false);
    const t = useTranslations("EmployeesPage.update_admin_roles")

    const handleOpenChange = (value: boolean) => {
        setOpen(value);
        if (value) {
            setSelectedRoles(roles);
        }
    };

    const handleAdd = (role: Role) => {
        if (!selectedRoles.some((r) => r._id === role._id)) {
            setSelectedRoles((prev) => [...prev, role]);
        }
    };

    const handleRemove = (roleId: string) => {
        setSelectedRoles((prev) =>
            prev.filter((r) => r._id !== roleId)
        );
    };

    const availableRoles = useMemo(() => {
        return allRoles.filter(
            (role) => !selectedRoles.some((r) => r._id === role._id)
        );
    }, [allRoles, selectedRoles]);

    const handleSave = async () => {
        setLoading(true);

        const originalIds = roles.map((r) => r._id);
        const newIds = selectedRoles.map((r) => r._id);

        const add = newIds.filter((id) => !originalIds.includes(id));
        const remove = originalIds.filter((id) => !newIds.includes(id));

        const res = await updateAdminRoles(adminId, add, remove);
        setOpen(false);
        setLoading(false);
        if (res.status) {
            toast.success(t("success"));
            setOpen(false);
        } else {
            toast.error(t("error"));
        }

    };

    return (
        <Dialog open={open} onOpenChange={handleOpenChange}>
            <DialogTrigger asChild>
                <DropdownMenuItem
                    onSelect={(e) => e.preventDefault()}
                >
                    {t("trigger")}
                </DropdownMenuItem>
            </DialogTrigger>

            <DialogContent className="max-w-lg">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                {/* Selected Roles */}
                <div>
                    <h3 className="mb-2 font-medium"></h3>
                    <div className="flex flex-wrap gap-2">
                        {selectedRoles.map((role) => (
                            <Badge
                                key={role._id}
                                className="flex items-center gap-2 cursor-pointer"
                                onClick={() => handleRemove(role._id)}
                            >
                                {role.name}
                                <X className="h-4 w-4" />
                            </Badge>
                        ))}
                        {selectedRoles.length === 0 && (
                            <p className="text-sm text-muted-foreground">
                                {t("current_roles")}
                            </p>
                        )}
                    </div>
                </div>

                {/* Add Roles */}
                <div className="mt-6">
                    <h3 className="mb-2 font-medium">{t("add_role")}</h3>
                    <div className="flex flex-wrap gap-2">
                        {availableRoles.map((role) => (
                            <Button
                                key={role._id}
                                variant="outline"
                                size="sm"
                                onClick={() => handleAdd(role)}
                            >
                                {role.name}
                            </Button>
                        ))}
                        {availableRoles.length === 0 && (
                            <p className="text-sm text-muted-foreground">
                                {t("no_roles_available")}
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
                    <Button onClick={handleSave} disabled={loading || selectedRoles.length === 0} className="disabled:opacity-50">
                        {loading ? <Spinner /> : t("save")}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
}