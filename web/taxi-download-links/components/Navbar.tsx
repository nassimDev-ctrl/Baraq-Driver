"use client";

import { useState } from "react";
import Link from "next/link";
import Image from "next/image";
import { motion, AnimatePresence } from "framer-motion";
import { Menu, X } from "lucide-react";
import { ThemeToggle } from "./ThemeToggle";
import waar_taxi from "../public/waar-qamishlo.png"

const navLinks = [
  { href: "#features", label: "المميزات" },
  { href: "#download", label: "التحميل" },
  { href: "#safety", label: "الأمان" },
  { href: "/privacy-policy", label: "سياسة الخصوصية" },
];

export function Navbar() {
  const [mobileOpen, setMobileOpen] = useState(false);

  return (
    <nav className="fixed top-0 left-0 right-0 z-50">
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="mt-4 glass-strong rounded-2xl px-6 py-3 flex items-center justify-between">
          {/* Logo */}
          <Link href="/" className="flex items-center gap-3 group">
            <div className="relative w-10 h-10 rounded-xl overflow-hidden icon-brand flex items-center justify-center p-0.5">
              <div className="w-full h-full rounded-[10px] overflow-hidden bg-white flex items-center justify-center">
                <Image
                  src={waar_taxi}
                  alt="Waar Taxi Logo"
                  width={36}
                  height={36}
                  className="object-contain"
                />
              </div>
            </div>
            <div className="flex flex-col">
              <span className="text-brand font-bold text-lg leading-tight tracking-tight">
                وار تكسي
              </span>
              <span className="text-brand-light/60 text-[10px] font-medium tracking-wider uppercase">
                Waar Taxi
              </span>
            </div>
          </Link>

          {/* Desktop Links */}
          <div className="hidden md:flex items-center gap-1">
            {navLinks.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                className="relative px-4 py-2 text-sm text-subtle hover:text-brand transition-colors rounded-xl hover:bg-[var(--brand-primary)]/5"
              >
                {link.label}
              </Link>
            ))}
            <ThemeToggle />
            <Link
              href="#download"
              className="mr-2 px-5 py-2 text-sm font-semibold text-white btn-brand rounded-xl shadow-lg shadow-[var(--brand-primary)]/20 hover:shadow-[var(--brand-primary)]/40"
            >
              حمّل الآن
            </Link>
          </div>

          {/* Mobile: Toggle + Theme */}
          <div className="flex md:hidden items-center gap-2">
            <ThemeToggle />
            <button
              onClick={() => setMobileOpen(!mobileOpen)}
              className="p-2 text-subtle hover:text-brand transition-colors"
              aria-label="Toggle menu"
            >
              {mobileOpen ? <X size={24} /> : <Menu size={24} />}
            </button>
          </div>
        </div>

        {/* Mobile Menu */}
        <AnimatePresence>
          {mobileOpen && (
            <motion.div
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -10 }}
              transition={{ duration: 0.2 }}
              className="mt-2 glass-strong rounded-2xl overflow-hidden md:hidden"
            >
              <div className="p-4 space-y-1">
                {navLinks.map((link) => (
                  <Link
                    key={link.href}
                    href={link.href}
                    onClick={() => setMobileOpen(false)}
                    className="block px-4 py-3 text-subtle hover:text-brand hover:bg-[var(--brand-primary)]/5 rounded-xl transition-colors text-sm"
                  >
                    {link.label}
                  </Link>
                ))}
                <Link
                  href="#download"
                  onClick={() => setMobileOpen(false)}
                  className="block text-center mt-3 px-5 py-3 text-sm font-semibold text-white btn-brand rounded-xl"
                >
                  حمّل الآن
                </Link>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </nav>
  );
}
