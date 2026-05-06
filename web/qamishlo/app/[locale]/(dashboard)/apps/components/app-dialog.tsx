"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";

import { Button } from "@/components/ui/button";
import {
    Dialog,
    DialogContent,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialog";
import { updateAppVersion } from "@/lib/actions";
import { toast } from "sonner";
import { Input } from "@/components/ui/input";
import { Edit } from "lucide-react";
import { AppRelease } from "./apps-client";

interface Props {
    type: "client" | "driver";
    data: AppRelease;
}


function normalizeUrl(url: string) {
    if (!url) return "";
    if (url.startsWith("http://") || url.startsWith("https://")) {
        return url;
    }
    return `https://${url}`;
}

export function AppDialog({ type, data }: Props) {
    const t = useTranslations("apps");

    const [open, setOpen] = useState(false);
    const [form, setForm] = useState({
        version: data.version,
        downloadLink: data.downloadLink,
    });

    const handleSubmit = async () => {
        const res = await updateAppVersion(type, {
            version: form.version,
            downloadLink: form.downloadLink,
        });

        if (res?.status) {
            toast.success(t("updated"));
        } else {
            toast.error(res?.message || "Error");
        }

        setOpen(false);
    };

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            {/* CARD */}
            <div className="border rounded-2xl p-6 space-y-4">
                <div className="flex justify-between items-center">
                    <h2 className="font-semibold capitalize">
                        {t(type)}
                    </h2>

                    <DialogTrigger asChild>
                        <Button variant="outline" size="icon">
                            <Edit className="h-4 w-4" />
                        </Button>
                    </DialogTrigger>
                </div>

                {/* Version */}
                <p className="text-3xl font-bold">
                    v{data.version}
                </p>

                {/* Date */}
                <div className="space-y-1">
                    <p className="text-sm text-muted-foreground">
                        {t("date")}
                    </p>

                    <p className="text-sm font-medium">
                        {new Date(data.updatedAt).toLocaleDateString()}
                    </p>
                </div>

                {/* Link */}
                <div className="space-y-1">
                    <p className="text-sm text-muted-foreground">
                        {t("link")}
                    </p>

                    <div className="flex items-center justify-between border rounded-lg px-3 py-2 bg-muted/30">
                        <span className="text-sm truncate">
                            {data.downloadLink}
                        </span>

                        <a
                            href={normalizeUrl(data.downloadLink)}
                            target="_blank"
                            className="text-xs font-medium text-blue-600 hover:underline ml-3 shrink-0"
                        >
                            {t("open")}
                        </a>
                    </div>
                </div>
            </div>

            {/* DIALOG */}
            <DialogContent className="max-w-sm">
                <DialogHeader>
                    <DialogTitle className="capitalize">
                        {t("edit")} {type}
                    </DialogTitle>
                </DialogHeader>

                <div className="space-y-4">
                    <Input
                        value={form.version}
                        onChange={(e) =>
                            setForm({ ...form, version: e.target.value })
                        }
                        placeholder="Version"
                    />

                    <Input
                        value={form.downloadLink}
                        onChange={(e) =>
                            setForm({ ...form, downloadLink: e.target.value })
                        }
                        placeholder="Link"
                    />
                </div>

                <DialogFooter>
                    <Button
                        variant="secondary"
                        onClick={() => setOpen(false)}
                    >
                        {t("cancel")}
                    </Button>

                    <Button onClick={handleSubmit}>
                        {t("save")}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    );
}