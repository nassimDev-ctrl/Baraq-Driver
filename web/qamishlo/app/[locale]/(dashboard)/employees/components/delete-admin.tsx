"use client";

import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger } from "@/components/ui/alert-dialog";
import { DropdownMenuItem } from "@/components/ui/dropdown-menu";
import { deleteAdmin } from "@/lib/actions";
import { useTranslations } from "next-intl";
import { useState } from "react";
import { toast } from "sonner";

interface DeleteGroupProps {
    id: string;
}

export function DeleteAdmin({ id }: DeleteGroupProps) {
    const [open, setOpen] = useState(false);
    const t = useTranslations("EmployeesPage.delete_admin");

    const handleDelete = async () => {
        const res = await deleteAdmin(id);
        if (res?.status) {
            toast.success(t("success"));
            setOpen(false);
        } else {
            toast.error(t("error"));
        }
    }
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
                    {t("trigger")}
                </DropdownMenuItem>
            </AlertDialogTrigger>
            <AlertDialogContent>
                <AlertDialogHeader>
                    <AlertDialogTitle> {t("title")} </AlertDialogTitle>
                    <AlertDialogDescription>
                        {t("description")}
                    </AlertDialogDescription>
                </AlertDialogHeader>
                <AlertDialogFooter>
                    <AlertDialogCancel>{t("cancel")}</AlertDialogCancel>
                    <AlertDialogAction
                        variant="destructive"
                        className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
                        onClick={handleDelete}
                    >
                        {t("delete")}
                    </AlertDialogAction>
                </AlertDialogFooter>
            </AlertDialogContent>
        </AlertDialog>
    )
}