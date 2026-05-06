"use client";

import { ImageUploader } from "@/components/ImageUploader";
import { Button } from "@/components/ui/button";
import {
    Dialog,
    DialogContent,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Spinner } from "@/components/ui/spinner";
import {
    Tooltip,
    TooltipContent,
    TooltipProvider,
    TooltipTrigger,
} from "@/components/ui/tooltip";
import { updateCategory } from "@/lib/actions";
import { UpdateCategorySchema, UpdateCategorySchemaType } from "@/schemas/schemas";
import { Category } from "@/types/types";
import { zodResolver } from "@hookform/resolvers/zod";
import { Edit } from "lucide-react";
import { useTranslations } from "next-intl";
import { useEffect, useState } from "react";
import { useForm } from "react-hook-form";
import { toast } from "sonner";

interface UpdateCategoryProps {
    category: Category;
}

export function UpdateCategory({ category }: UpdateCategoryProps) {
    const t = useTranslations("updateCategory");
    const [open, setOpen] = useState(false);

    const form = useForm<UpdateCategorySchemaType>({
        resolver: zodResolver(UpdateCategorySchema),
        defaultValues: {
            nameAr: category.nameAr,
            nameEn: category.nameEn,
            nameKu: category.nameKu,
            price: category.price,
            category_image: undefined, // Start with undefined, will be set in useEffect
        },
    });

    const { register, handleSubmit, reset, formState, setValue } = form;

    const handleImageCropped = (blob: Blob) => {
        const file = new File([blob], "category_image.png", { type: blob.type });
        setValue("category_image", file, { shouldValidate: true });
    };

    useEffect(() => {
        const loadImageAsFile = async () => {
            let file: File | undefined = undefined;

            if (category.image) {
                try {
                    const proxyUrl = `/api/image-proxy?url=${encodeURIComponent(
                        process.env.NEXT_PUBLIC_APP_DOMAIN_FOR_IMAGES + "/" + category.image
                    )}`;

                    const res = await fetch(proxyUrl);
                    const blob = await res.blob();

                    file = new File([blob], "category_image.jpg", {
                        type: blob.type,
                    });
                } catch (err) {
                    console.error("Failed to load image as file", err);
                }
            }

            reset({
                nameAr: category.nameAr,
                nameEn: category.nameEn,
                nameKu: category.nameKu,
                price: category.price,
                category_image: file,
            });
        };

        if (open) {
            loadImageAsFile();
        }
    }, [open, category, reset]);

    const onSubmit = async (data: UpdateCategorySchemaType) => {
        const res = await updateCategory(category._id, data);
        if (res.status) {
            toast.success(t("messages.success"));
        } else {
            toast.error(res.message);
        }
        setOpen(false);
    };

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <TooltipProvider>
                <Tooltip>
                    <TooltipTrigger asChild>
                        <DialogTrigger asChild>
                            <Button variant="outline" size="icon">
                                <Edit className="h-4 w-4" />
                            </Button>
                        </DialogTrigger>
                    </TooltipTrigger>
                    <TooltipContent>{t("title")}</TooltipContent>
                </Tooltip>
            </TooltipProvider>

            <DialogContent className="max-w-sm">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                    <ImageUploader onImageCropped={handleImageCropped} initialImage={category.image} />

                    {formState.errors.category_image && (
                        <p className="text-sm text-destructive">
                            {t(formState.errors.category_image.message as string)}
                        </p>
                    )}

                    <div className="space-y-1">
                        <Input placeholder={t("form.nameAr.placeholder")} {...register("nameAr")} />
                        {formState.errors.nameAr && (
                            <p className="text-sm text-destructive">{t(formState.errors.nameAr.message as string)}</p>
                        )}
                    </div>

                    <div className="space-y-1">
                        <Input placeholder={t("form.nameEn.placeholder")} {...register("nameEn")} />
                        {formState.errors.nameEn && (
                            <p className="text-sm text-destructive">{t(formState.errors.nameEn.message as string)}</p>
                        )}
                    </div>

                    <div className="space-y-1">
                        <Input placeholder={t("form.nameKu.placeholder")} {...register("nameKu")} />
                        {formState.errors.nameKu && (
                            <p className="text-sm text-destructive">{t(formState.errors.nameKu.message as string)}</p>
                        )}
                    </div>

                    <div className="space-y-1">
                        <Input
                            type="number"
                            placeholder={t("form.price.placeholder")}
                            {...register("price", { valueAsNumber: true })}
                        />
                        {formState.errors.price && (
                            <p className="text-sm text-destructive">{t(formState.errors.price.message as string)}</p>
                        )}
                    </div>

                    <DialogFooter className="pt-4">
                        <Button
                            type="button"
                            variant="secondary"
                            onClick={() => {
                                reset();
                                setOpen(false);
                            }}
                        >
                            {t("actions.cancel")}
                        </Button>
                        <Button type="submit" disabled={formState.isSubmitting}>
                            {formState.isSubmitting ? <Spinner /> : t("actions.update")}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}