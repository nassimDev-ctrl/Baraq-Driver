export const Loader = () => {
    return (
        <div className="flex h-[calc(100vh-16rem)]  w-full items-center justify-center">
            <svg
                className="w-32 h-32 md:w-40 md:h-40"
                viewBox="0 0 56 56"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
            >
                {/* Outer rotating ring */}
                <circle
                    cx="28"
                    cy="28"
                    r="24"
                    stroke="#a064db"
                    strokeWidth="3"
                    strokeLinecap="round"
                    strokeDasharray="70 40"
                >
                    <animateTransform
                        attributeName="transform"
                        type="rotate"
                        from="0 28 28"
                        to="360 28 28"
                        dur="1.2s"
                        repeatCount="indefinite"
                    />
                </circle>

                {/* Inner soft ring */}
                <circle
                    cx="28"
                    cy="28"
                    r="18"
                    stroke="#a064db"
                    strokeWidth="2"
                    strokeLinecap="round"
                    strokeDasharray="40 30"
                >
                    <animateTransform
                        attributeName="transform"
                        type="rotate"
                        from="360 28 28"
                        to="0 28 28"
                        dur="1.6s"
                        repeatCount="indefinite"
                    />
                </circle>
                {/* Taxi Front Icon */}
            </svg>
        </div>
    );
};
