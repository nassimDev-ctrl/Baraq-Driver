import { defineRouting } from 'next-intl/routing';

export const routing = defineRouting({
    // A list of all locales that are supported
    locales: ["kmr", 'ar', 'en'],

    // Used when no locale matches
    defaultLocale: 'kmr',
    localePrefix: 'always',
    localeDetection: false
});