"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useTranslations, useLocale } from "next-intl";
import { useState } from "react";
import { Controller, useForm } from "react-hook-form";

import {
    Dialog,
    DialogContent,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    DialogTrigger,
} from "@/components/ui/dialog";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { toast } from "sonner";

import {
    UpdateDriverSchema,
    UpdateDriverSchemaType,
} from "@/schemas/schemas";

import { updateDriver } from "@/lib/actions";
import { City, Driver } from "@/types/types";

interface UpdateDriverProps {
    driver: Driver;
    cities: City[];
}

export default function UpdateDriver({ driver, cities }: UpdateDriverProps) {
    const t = useTranslations("driverDialog");
    const locale = useLocale();

    const [open, setOpen] = useState(false);

    const {
        control,
        handleSubmit,
        reset,
        formState: { errors, isSubmitting },
    } = useForm<UpdateDriverSchemaType>({
        resolver: zodResolver(UpdateDriverSchema),
        defaultValues: {
            firstName: driver.firstName,
            lastName: driver.lastName,
            email: driver?.authUser?.email ?? undefined,
            emergencyNumber: driver.emergencyNumber,
            gender: driver.gender as "male" | "female",
            city: driver.city._id,
        },
    });

    const getCityName = (city: City) => {
        if (locale === "ar") return city.nameAr;
        if (locale === "ku") return city.nameKu;
        return city.nameEn;
    };

    const onSubmit = async (data: UpdateDriverSchemaType) => {
        const res = await updateDriver(driver._id, data);

        if (res.status) {
            toast.success(t("messages.success"));
            setOpen(false);
            reset();
        } else {
            toast.error(res.message ?? t("messages.error"));
        }
    };

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <Button variant="secondary">{t("openButton")}</Button>
            </DialogTrigger>

            <DialogContent className="sm:max-w-100">
                <DialogHeader>
                    <DialogTitle>{t("title")}</DialogTitle>
                </DialogHeader>

                <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                    {/* First Name */}
                    <div>
                        <label className="block text-sm font-medium mb-2">
                            {t("fields.firstName")}
                        </label>

                        <Controller
                            name="firstName"
                            control={control}
                            render={({ field }) => <Input {...field} />}
                        />

                        {errors.firstName && (
                            <p className="text-sm text-red-500 mt-1">
                                {errors.firstName.message}
                            </p>
                        )}
                    </div>

                    {/* Last Name */}
                    <div>
                        <label className="block text-sm font-medium mb-2">
                            {t("fields.lastName")}
                        </label>

                        <Controller
                            name="lastName"
                            control={control}
                            render={({ field }) => <Input {...field} />}
                        />

                        {errors.lastName && (
                            <p className="text-sm text-red-500 mt-1">
                                {errors.lastName.message}
                            </p>
                        )}
                    </div>

                    {/* Gender */}
                    <div>
                        <label className="block text-sm font-medium mb-2">
                            {t("fields.gender")}
                        </label>

                        <Controller
                            name="gender"
                            control={control}
                            render={({ field }) => (
                                <select
                                    className="w-full border rounded-md p-2"
                                    {...field}
                                >
                                    <option value="male">{t("fields.male")}</option>
                                    <option value="female">{t("fields.female")}</option>
                                </select>
                            )}
                        />

                        {errors.gender && (
                            <p className="text-sm text-red-500 mt-1">
                                {errors.gender.message}
                            </p>
                        )}
                    </div>

                    {/* Email */}
                    <div>
                        <label className="block text-sm font-medium mb-2">
                            {t("fields.email")}
                        </label>

                        <Controller
                            name="email"
                            control={control}
                            render={({ field }) => (
                                <Input type="email" {...field} />
                            )}
                        />

                        {errors.email && (
                            <p className="text-sm text-red-500 mt-1">
                                {errors.email.message}
                            </p>
                        )}
                    </div>

                    {/* Emergency Number */}
                    <div>
                        <label className="block text-sm font-medium mb-2">
                            {t("fields.emergencyNumber")}
                        </label>

                        <Controller
                            name="emergencyNumber"
                            control={control}
                            render={({ field }) => (
                                <Input type="tel" inputMode="numeric" {...field} />
                            )}
                        />

                        {errors.emergencyNumber && (
                            <p className="text-sm text-red-500 mt-1">
                                {errors.emergencyNumber.message}
                            </p>
                        )}
                    </div>

                    {/* City */}
                    <div>
                        <label className="block text-sm font-medium mb-2">
                            {t("fields.city")}
                        </label>

                        <Controller
                            name="city"
                            control={control}
                            render={({ field }) => (
                                <select
                                    className="w-full border rounded-md p-2"
                                    {...field}
                                >
                                    <option value="">
                                        {t("selectCity")}
                                    </option>

                                    {cities
                                        .filter((c) => c.status)
                                        .map((city) => (
                                            <option key={city._id} value={city._id}>
                                                {getCityName(city)}
                                            </option>
                                        ))}
                                </select>
                            )}
                        />

                        {errors.city && (
                            <p className="text-sm text-red-500 mt-1">
                                {errors.city.message}
                            </p>
                        )}
                    </div>

                    {/* Footer */}
                    <DialogFooter className="flex justify-end gap-2">
                        <Button
                            type="button"
                            variant="secondary"
                            onClick={() => setOpen(false)}
                        >
                            {t("actions.cancel")}
                        </Button>

                        <Button type="submit" disabled={isSubmitting}>
                            {isSubmitting
                                ? t("actions.updating")
                                : t("actions.update")}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}