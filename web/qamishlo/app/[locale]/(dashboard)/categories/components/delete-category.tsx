"use client";

import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger } from "@/components/ui/alert-dialog";
import { Button } from "@/components/ui/button";
import { deleteCategory } from "@/lib/actions";
import { useTranslations } from "next-intl";
import { toast } from "sonner";
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip";
import { Trash } from "lucide-react";
import { useState } from "react";

interface DeleteCategoryProps {
    id: string
}

export function DeleteCategory({ id }: DeleteCategoryProps) {
    const [open, setOpen] = useState(false);
    const t = useTranslations("deleteCategory");
    const handleDelete = async () => {
        const res = await deleteCategory(id);
        if (res.status) {
            toast.success(res.message);
        } else {
            toast.error(res.message);
        }
    }
    return (
        <AlertDialog open={open} onOpenChange={setOpen}>
            <TooltipProvider>
                <Tooltip>
                    <AlertDialogTrigger asChild>
                        <TooltipTrigger asChild>
                            <Button variant="outline" size="icon">
                                <Trash className="size-4" />
                            </Button>
                        </TooltipTrigger>
                    </AlertDialogTrigger>
                    <TooltipContent>
                        {t("title")}
                    </TooltipContent>
                </Tooltip>
            </TooltipProvider>
            <AlertDialogContent>
                <AlertDialogHeader>
                    <AlertDialogTitle>{t("title")}</AlertDialogTitle>
                    <AlertDialogDescription>
                        {t("confirm_message")}<br />
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
    )
}