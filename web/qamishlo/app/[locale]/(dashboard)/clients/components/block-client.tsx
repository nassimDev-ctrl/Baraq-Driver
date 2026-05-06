
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
import { blockUser } from "@/lib/actions";
import { useTranslations } from "next-intl";
import { useState } from "react";
import { toast } from "sonner";

interface BlockClientDialogProps {
    userId: string;
}

export function BlockClientDialog({ userId }: BlockClientDialogProps) {
    const [open, setOpen] = useState(false);
    const t = useTranslations("block_client");
    const handleBlock = async () => {
        const res = await blockUser(userId);
        if (res?.status) {
            toast.success(t("success"));
            setOpen(false);
        } else {
            toast.error(t("error"));
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
                    {t("trigger")}
                </DropdownMenuItem>
            </AlertDialogTrigger>

            <AlertDialogContent>
                <AlertDialogHeader>
                    <AlertDialogTitle>{t("title")}</AlertDialogTitle>
                    <AlertDialogDescription>
                        {t("description")}
                        <br />
                        {t("warning")}
                    </AlertDialogDescription>
                </AlertDialogHeader>

                <AlertDialogFooter>
                    <AlertDialogCancel>{t("cancel")}</AlertDialogCancel>
                    <AlertDialogAction
                        variant="destructive"
                        className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
                        onClick={handleBlock}
                    >
                        {t("confirm")}
                    </AlertDialogAction>
                </AlertDialogFooter>
            </AlertDialogContent>
        </AlertDialog>
    );
}