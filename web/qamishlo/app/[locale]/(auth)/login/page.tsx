import { LanguageSwitcher } from "@/components/language-switcher";
import LoginForm from "./components/login-form";
export default function LoginPage() {
    return (
        <section className="flex min-h-screen px-4 pt-4">
            <LanguageSwitcher />
            <LoginForm />
        </section>
    );
}
