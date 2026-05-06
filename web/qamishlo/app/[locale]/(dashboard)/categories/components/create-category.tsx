"use client";

import { ImageUploader } from "@/components/ImageUploader";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
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
import { createCategory } from "@/lib/actions";
import { CreateCategorySchema, CreateCategorySchemaType } from "@/schemas/schemas";
import { zodResolver } from "@hookform/resolvers/zod";
import { Plus } from "lucide-react";
import { useTranslations } from "next-intl";
import { useState } from "react";
import { useForm } from "react-hook-form";
import { toast } from "sonner";

export function CreateCategory() {
    const t = useTranslations("createCategory");
    const [open, setOpen] = useState(false);

    const form = useForm<CreateCategorySchemaType>({
        resolver: zodResolver(CreateCategorySchema),
        defaultValues: {
            nameAr: "",
            nameEn: "",
            nameKu: "",
            price: 0,
            category_image: undefined as unknown as File,
        },
    });

    const handleImageCropped = (blob: Blob) => {
        const file = new File([blob], "category_image.png", {
            type: blob.type,
        });

        form.setValue("category_image", file, {
            shouldValidate: true,
        });
    };

    const { register, handleSubmit, reset, formState } = form;

    const onSubmit = async (data: CreateCategorySchemaType) => {
        const res = await createCategory(data)
        if (res.status) {
            toast.success(res.message ?? "Created Category Successfully")
        }
        reset();
        setOpen(false);
    };

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <Card className="border-2 border-dashed w-full  h-full p-0 shadow-none hover:scale-105 cursor-pointer">
                    <CardContent className="p-6 h-full min-h-28 w-full flex items-center justify-center">
                        <Plus className="size-10 h-full text-foreground/80" />
                    </CardContent>
                </Card>
            </DialogTrigger>

            <DialogContent className="max-w-sm">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                    {/* Category name */}
                    <ImageUploader onImageCropped={handleImageCropped} />
                    {formState.errors.category_image && (
                        <p className="text-sm text-destructive">
                            {t(formState.errors.category_image.message as string)}
                        </p>
                    )}
                    <div className="space-y-1">
                        <Input
                            placeholder={t("form.nameAr.placeholder")}
                            {...register("nameAr")}
                        />
                        {formState.errors.nameAr && (
                            <p className="text-sm text-destructive">
                                {t(formState.errors.nameAr.message as string)}
                            </p>
                        )}
                    </div>
                    <div className="space-y-1">
                        <Input
                            placeholder={t("form.nameEn.placeholder")}
                            {...register("nameEn")}
                        />
                        {formState.errors.nameEn && (
                            <p className="text-sm text-destructive">
                                {t(formState.errors.nameEn.message as string)}
                            </p>
                        )}
                    </div>
                    <div className="space-y-1">
                        <Input
                            placeholder={t("form.nameKu.placeholder")}
                            {...register("nameKu")}
                        />
                        {formState.errors.nameKu && (
                            <p className="text-sm text-destructive">
                                {t(formState.errors.nameKu.message as string)}
                            </p>
                        )}
                    </div>
                    <div className="space-y-1">
                        <Input
                            type="number"
                            placeholder={t("form.price.placeholder")}
                            {...register("price", { valueAsNumber: true })}
                        />
                        {formState.errors.price && (
                            <p className="text-sm text-destructive">
                                {t(formState.errors.price.message as string)}
                            </p>
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
                        <Button type="submit">
                            {form.formState.isSubmitting ?
                                <>
                                    <Spinner />
                                </>
                                :
                                t("actions.create")
                            }
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}