"use client";

import Image from "next/image";
import {
    Dialog,
    DialogContent,
    DialogTrigger,
} from "@/components/ui/dialog";

interface ImageCellProps {
    src?: string;
}


const API_DOMAIN = process.env.NEXT_PUBLIC_APP_API_DOMAIN!;

export function ImageCell({ src }: ImageCellProps) {

    if (!src) {
        return (
            <div className="h-12 w-12 flex items-center justify-center text-xs text-muted-foreground border rounded-md">
                N/A
            </div>
        );
    }

    return (
        <Dialog>
            <DialogTrigger asChild>
                <div className="cursor-pointer">
                    <Image
                        src={`${API_DOMAIN}/${src}`}
                        alt="complaint image"
                        width={48}
                        height={48}
                        className="h-12 w-12 object-cover rounded-md border"
                    />
                </div>
            </DialogTrigger>

            <DialogContent className="max-w-3xl">
                <Image
                    src={`${API_DOMAIN}/${src}`}
                    alt="complaint image"
                    width={800}
                    height={600}
                    className="w-full h-auto rounded-md"
                />
            </DialogContent>
        </Dialog>
    );
}