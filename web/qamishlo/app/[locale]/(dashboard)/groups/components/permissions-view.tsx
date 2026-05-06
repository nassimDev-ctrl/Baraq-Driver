"use client";

import { useState } from "react";
import { Permission } from "@/types/types";
import { Button } from "@/components/ui/button";
import { Switch } from "@/components/ui/switch";
import {
    Dialog,
    DialogContent,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialog";
import { useTranslations } from "next-intl";
import { Spinner } from "@/components/ui/spinner";
import { toast } from "sonner";
import { updateGroupPermissions } from "@/lib/actions";

interface PermissionsViewProps {
    group_id: string;
    permissions: Permission[];
    group_permissions: Permission[];
}

// view + update group permissions
export default function PermissionsView({
    group_id,
    permissions,
    group_permissions,
}: PermissionsViewProps) {
    const t = useTranslations("permissions");
    const tView = useTranslations("groupsPage.permissions_view");

    const defaultSelected = group_permissions.map((p) => p._id);

    const [open, setOpen] = useState(false);
    const [selected, setSelected] = useState<string[]>(defaultSelected);
    const [isSubmitting, setIsSubmitting] = useState(false);

    const togglePermission = (id: string) => {
        setSelected((prev) =>
            prev.includes(id)
                ? prev.filter((p) => p !== id)
                : [...prev, id]
        );
    };

    async function handleUpdatePermissions() {
        setIsSubmitting(true);

        const add = selected.filter(
            (id) => !defaultSelected.includes(id)
        );

        const remove = defaultSelected.filter(
            (id) => !selected.includes(id)
        );

        const res = await updateGroupPermissions(group_id, add, remove);

        if (res.status) {
            toast.success(tView("update_success"));
            setOpen(false);
        } else {
            toast.error(res.message ?? tView("update_error"));
        }

        setIsSubmitting(false);
    }

    function handleOpenChange(value: boolean) {
        setOpen(value);

        // reset state if dialog closed without saving
        if (!value) {
            setSelected(defaultSelected);
        }
    }

    return (
        <Dialog open={open} onOpenChange={handleOpenChange}>
            <DialogTrigger asChild>
                <Button variant="secondary" className="w-full">
                    {tView("view_permissions")}
                </Button>
            </DialogTrigger>

            <DialogContent className="max-w-lg overflow-y-scroll max-h-96">
                <DialogHeader>
                    <DialogTitle>{tView("manage_permissions")}</DialogTitle>
                </DialogHeader>

                <div className="space-y-3">
                    <div className="grid grid-cols-1 gap-2">
                        {permissions.map((permission) => {
                            const checked = selected.includes(permission._id);

                            return (
                                <div
                                    key={permission._id}
                                    className="flex items-center justify-between rounded-lg border px-3 py-2"
                                >
                                    <span className="text-sm">
                                        {t(permission.name)}
                                    </span>

                                    <Switch
                                        dir="ltr"
                                        checked={checked}
                                        onCheckedChange={() =>
                                            togglePermission(permission._id)
                                        }
                                    />
                                </div>
                            );
                        })}
                    </div>

                    <DialogFooter>
                        <Button
                            onClick={handleUpdatePermissions}
                            className="w-full"
                            disabled={isSubmitting}
                        >
                            {isSubmitting ? <Spinner /> : tView("save_changes")}
                        </Button>
                    </DialogFooter>
                </div>
            </DialogContent>
        </Dialog>
    );
}
