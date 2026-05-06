"use client";

import {
    AlertDialog,
    AlertDialogAction,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
    AlertDialogTrigger,
} from "@/components/ui/alert-dialog";
import { DropdownMenuItem } from "@/components/ui/dropdown-menu";
import { deleteRole } from "@/lib/actions";
import { useTranslations } from "next-intl";
import { useState } from "react";
import { toast } from "sonner";

interface DeleteRoleDialogProps {
    roleId: string;
}

export function DeleteRoleDialog({ roleId }: DeleteRoleDialogProps) {
    const [open, setOpen] = useState(false);
    const t = useTranslations("RolesPage.delete_role");
    const handleDelete = async () => {
        const res = await deleteRole(roleId);
        if (res?.status) {
            toast.success(t("success"));
            setOpen(false);
        } else {
            toast.error(t("error"))
        }
    };

    return (
        <AlertDialog open={open} onOpenChange={setOpen}>
            <AlertDialogTrigger asChild>
                <DropdownMenuItem
                    variant="destructive"
                    onSelect={(e) => {
                        e.preventDefault();
                        setOpen(true);
                    }
                    }
                >
                    {t("delete")}
                </DropdownMenuItem>
            </AlertDialogTrigger>

            <AlertDialogContent>
                <AlertDialogHeader>
                    <AlertDialogTitle>{t("title")}</AlertDialogTitle>
                    <AlertDialogDescription>
                        {t("description")}
                        <br />
                    </AlertDialogDescription>
                </AlertDialogHeader>
                <AlertDialogFooter>
                    <AlertDialogCancel>{t("cancel")}</AlertDialogCancel>
                    <AlertDialogAction
                        variant="destructive"
                        className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
                        onClick={handleDelete}
                    >
                        {t("confirm")}
                    </AlertDialogAction>
                </AlertDialogFooter>
            </AlertDialogContent>
        </AlertDialog>
    );
}