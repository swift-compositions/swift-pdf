// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-pdf",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "PDF", targets: ["PDF"]),
        .library(name: "PDF Test Support", targets: ["PDF Test Support"]),
    ],
    traits: [
        .trait(name: "HTML", description: "Author documents with HTML views and CSS"),
        .trait(name: "Markdown", description: "Author documents with Markdown", enabledTraits: ["HTML"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-byte.git", branch: "main"),
        .package(
            url: "https://github.com/swift-compositions/swift-html.git",
            branch: "main",
            traits: [.trait(name: "Markdown", condition: .when(traits: ["Markdown"]))]
        ),
        .package(url: "https://github.com/swift-compositions/swift-pdf-render.git", branch: "main"),
        .package(
            url: "https://github.com/swift-compositions/swift-pdf-html-render.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-compositions/swift-file-system.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "PDF",
            dependencies: [
                .product(name: "PDF Rendering", package: "swift-pdf-render"),
                .product(name: "File System", package: "swift-file-system"),
                .product(name: "HTML", package: "swift-html", condition: .when(traits: ["HTML"])),
                .product(
                    name: "PDF HTML Rendering",
                    package: "swift-pdf-html-render",
                    condition: .when(traits: ["HTML"])
                ),
            ]
        ),
        .target(
            name: "PDF Test Support",
            dependencies: [
                .target(name: "PDF")
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "PDF Tests",
            dependencies: [
                .product(name: "Byte", package: "swift-byte"),
                .target(name: "PDF"),
                .product(name: "HTML", package: "swift-html", condition: .when(traits: ["HTML"])),
                .target(name: "PDF Test Support"),
            ],
            path: "Tests/PDF Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
