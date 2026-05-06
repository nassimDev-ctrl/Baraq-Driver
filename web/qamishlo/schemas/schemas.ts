import { z } from "zod";
import isStrongPassword from 'validator/lib/isStrongPassword';

// Login Schema
export const loginFormSchema = z.object({
    email: z.email(),
    password: z.string().min(8).max(20)
})

export type loginFormSchemaType = z.infer<typeof loginFormSchema>;

// Create Group Schema
export const createGroupSchema = z.object({
    name: z.string().min(1, "Name is required"),
    permissions: z.array(z.string()).min(1, "Select at least one permission"),
});

export type CreateGroupSchema = z.infer<typeof createGroupSchema>;

// Create Role Schema
export const createRoleSchema = z.object({
    name: z.string().min(2),
    groups: z.array(z.string()).min(1),
});

export type CreateRoleSchema = z.infer<typeof createRoleSchema>;

// Create Admin Schema
export const createAdminSchema = z.object({
    firstName: z.string().min(1),
    lastName: z.string().min(1),
    email: z.email(),
    password: z.string().refine((password) =>
        isStrongPassword(password, {
            minLength: 8,
            minLowercase: 1,
            minUppercase: 1,
            minNumbers: 1,
            minSymbols: 1,
            returnScore: false,
        })
    ),
    roles: z.array(z.string()).min(1),
});

export type CreateAdminSchemaType = z.infer<typeof createAdminSchema>;

export const UpdateCommissionPercentage = z.object({
    commissionPercentage: z.number().min(0).max(100).positive()
})

// Update Commission Percentage Schema
export type UpdateCommissionPercentageType = z.infer<typeof UpdateCommissionPercentage>

// Update Admin Password Schema
export const UpdateAdminPasswordSchema = z
    .object({
        currentPassword: z.string().min(6, "Minimum 6 characters"),
        newPassword: z.string().refine((password) =>
            isStrongPassword(password, {
                minLength: 8,
                minLowercase: 1,
                minUppercase: 1,
                minNumbers: 1,
                minSymbols: 1,
                returnScore: false,
            })
        ),
        confirmPassword: z.string().refine((password) =>
            isStrongPassword(password, {
                minLength: 8,
                minLowercase: 1,
                minUppercase: 1,
                minNumbers: 1,
                minSymbols: 1,
                returnScore: false,
            })
        ),
    })
    .refine((data) => data.newPassword === data.confirmPassword, {
        message: "Passwords do not match",
        path: ["confirmPassword"],
    })

export type UpdateAdminPasswordSchemaType = z.infer<typeof UpdateAdminPasswordSchema>

export const CreateCitySchema = z.object({
    nameEn: z.string().min(2, { message: "errors.nameEn" }),
    nameAr: z.string().min(2, { message: "errors.nameAr" }),
    nameKu: z.string().min(2, { message: "errors.nameKu" }),
});

export type CreateCitySchemaType = z.infer<typeof CreateCitySchema>;

// Create Category Schema
const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

export const CreateCategorySchema = z.object({
    nameAr: z.string().min(1, "form.nameAr.required"),
    nameEn: z.string().min(1, "form.nameEn.required"),
    nameKu: z.string().min(1, "form.nameKu.required"),
    price: z.number().min(1, "form.price.min"),
    category_image: z
        .instanceof(File, { message: "form.category_image.required" })
        .refine((file) => file.size <= MAX_FILE_SIZE, "form.category_image.maxSize")
        .refine(
            (file) => ["image/png", "image/jpeg", "image/webp"].includes(file.type),
            "form.category_image.format"
        ),
});

export type CreateCategorySchemaType = z.infer<typeof CreateCategorySchema>;

export const UpdateCategorySchema = z.object({
    nameAr: z.string().min(1, "form.nameAr.required"),
    nameEn: z.string().min(1, "form.nameEn.required"),
    nameKu: z.string().min(1, "form.nameKu.required"),
    price: z.number().min(1, "form.price.min"),
    category_image: z
        .instanceof(File, { message: "form.category_image.required" })
        .refine((file) => file.size <= MAX_FILE_SIZE, "form.category_image.maxSize")
        .refine(
            (file) => ["image/png", "image/jpeg", "image/webp"].includes(file.type),
            "form.category_image.format"
        )
        .optional(),
});

export type UpdateCategorySchemaType = z.infer<typeof UpdateCategorySchema>;

export const PostNotificationSchema = z.object({
    titleAr: z.string().min(1, "form.titleAr.titleRequired"),
    titleEn: z.string().min(1, "form.titleEn.titleRequired"),
    titleKu: z.string().min(1, "form.titleKu.titleRequired"),
    messageAr: z.string().min(1, "form.messageAr.messageRequired"),
    messageEn: z.string().min(1, "form.messageEn.messageRequired"),
    messageKu: z.string().min(1, "form.messageKu.messageRequired"),
    target: z.enum(["all", "clients", "drivers"]),
    cities: z.array(z.string()).optional(),
    categories: z.array(z.string()).optional(),
});

export type PostNotificationSchemaType = z.infer<typeof PostNotificationSchema>;

export type CreateNotificationPayload = {
    titleAr: string;
    titleEn: string;
    titleKu: string;
    messageAr: string;
    messageEn: string;
    messageKu: string;
    usersType: "All" | "client" | "driver";
    cities: string[] | "All";
    categories: string[] | undefined | [];
};

// Create Discount Code Schema
export const CreateDiscountCodeSchema = z.object({
    discountAmount: z.number().min(0, { message: "discount_required" }),

    percentageDiscount: z.number().min(0).max(100).optional().default(0),

    numberOfUsers: z.number().min(0).default(0),

    maxTrips: z.number().min(1, { message: "trips_required" }),

    minimum: z.number().min(0, { message: "minimum_required" }),

    startAt: z.coerce.date({
        message: "start_required",
    }),

    expiredAt: z.coerce.date({
        message: "expired_required",
    }),

    cities: z.array(z.string()).optional(),

    // categories: z.array(z.string()).min(1, { message: "categoriesRequired" }),

    status: z.enum(["active", "finish"]).default("active"),
})
    .refine((data) => data.expiredAt > data.startAt, {
        message: "expired_invalid",
        path: ["expiredAt"],
    })
    .refine(
        (data) => data.discountAmount > 0 || data.percentageDiscount > 0,
        {
            message: "discount_required",
            path: ["discountAmount"],
        }
    );

export type CreateDiscountCodeSchemaType = z.infer<typeof CreateDiscountCodeSchema>;

export type UpdateDiscountCodeType =
    Partial<
        Omit<
            CreateDiscountCodeSchemaType,
            "cities"
            // | "categories"    
            | "startAt" | "status"
        >
    > & {
        addCities?: string[];
        removeCities?: string[];

        addCategory?: string[];
        removeCategory?: string[];
    };

// Update Client Number Schema
export const UpdateClientNumberSchema = z.object({
    phoneNumber: z.string().min(12).max(12).regex(/^963\d+$/, "Phone number must start with 963")
})

export type UpdateClientNumberSchemaType = z.infer<typeof UpdateClientNumberSchema>


// Add Driver Balance Schema
export const AddDriverBalance = z.object({
    amount: z.number().min(100).positive()
})

export type AddDriverBalanceType = z.infer<typeof AddDriverBalance>

// Update driver data Schema
export const UpdateDriverSchema = z.object({
    firstName: z.string().min(2, "First name is required"),
    lastName: z.string().min(2, "Last name is required"),
    email: z.email("Invalid email").optional(),
    gender: z.enum(["male", "female"]),
    emergencyNumber: z
        .string()
        .min(8, "Emergency number is required").optional(),
    city: z.string().min(1, "City is required"),
});

export type UpdateDriverSchemaType = z.infer<typeof UpdateDriverSchema>;