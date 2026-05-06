import createMiddleware from 'next-intl/middleware';
import { routing } from './i18n/routing';
import { NextRequest, NextResponse } from 'next/server';

const intlMiddleware = createMiddleware(routing);

const PUBLIC_ROUTES = ["/login"];

export default function proxy(request: NextRequest) {
    const response = intlMiddleware(request);

    const { pathname } = request.nextUrl;

    const segments = pathname.split('/');
    const locale = segments[1]; // safer

    if (!locale) return response;

    const path = pathname.replace(`/${locale}`, "") || "/";

    const token = request.cookies.get('auth_token')?.value;
    const isPublic = PUBLIC_ROUTES.includes(path);

    if (!token && !isPublic) {
        const url = request.nextUrl.clone();
        url.pathname = `/${locale}/login`;
        return NextResponse.redirect(url);
    }

    const isSessionExpired = request.nextUrl.searchParams.get("session") === "expired";

    if (token && path === "/login" && !isSessionExpired) {
        const url = request.nextUrl.clone();
        url.pathname = `/${locale}`;
        return NextResponse.redirect(url);
    }

    return response;
}

export const config = {
    matcher: ['/((?!api|trpc|_next|_vercel|.*\\..*).*)']
};