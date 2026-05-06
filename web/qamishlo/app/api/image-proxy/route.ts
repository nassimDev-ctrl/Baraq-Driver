// app/api/image-proxy/route.ts
export async function GET(req: Request) {
    const { searchParams } = new URL(req.url);
    const url = searchParams.get("url");
    const lang = searchParams.get("lang") || "ar"; // default to Arabic

    if (!url) return new Response("Missing url", { status: 400 });

    const response = await fetch(url, {
        headers: {
            "Accept-Language": lang,
        },
    });

    if (!response.ok) return new Response("Failed to fetch image", { status: response.status });

    const arrayBuffer = await response.arrayBuffer();
    const contentType = response.headers.get("content-type") || "image/webp";

    return new Response(arrayBuffer, {
        headers: {
            "Content-Type": contentType,
            "Cache-Control": "public, max-age=3600",
            "Cross-Origin-Resource-Policy": "cross-origin",
            "Content-Security-Policy": "default-src *; img-src * data:;",
        },
    });
}