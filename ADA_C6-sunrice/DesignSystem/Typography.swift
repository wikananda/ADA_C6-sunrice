import SwiftUI

extension Font {
    // MARK: - SF Pro – Body & Labels

    /// Small body / description / helper text
    static let bodySM = Font.system(size: 12, weight: .regular, design: .default)

    /// Small body with emphasis (alert, etc)
    static let bodySMEmphasis = Font.system(size: 12, weight: .semibold, design: .default)

    /// Small labels (small buttons, badges, strong alerts)
    static let labelSM = Font.system(size: 12, weight: .bold, design: .default)

    /// Medium labels (buttons, numbers next to symbols, small subheadings)
    static let labelMD = Font.system(size: 16, weight: .bold, design: .default)

    /// Large input, for example PIN or name input
    static let inputXL = Font.system(size: 32, weight: .bold, design: .default)
    
    /// Extra Large input, for example PIN or name input
    static let inputXXL = Font.system(size: 64, weight: .bold, design: .default)
    
    /// Medium symbols or large numbers
    static let symbolM = Font.system(size: 16, weight: .regular, design: .default)

    /// Large symbols or large numbers
    static let symbolL = Font.system(size: 24, weight: .bold, design: .default)
}

extension Font {
    // MARK: - Manrope ExtraBold – Titles

    /// Title indicating the current screen
    static let titleSM = Font.custom("Manrope-ExtraBold",
                                    size: 20,
                                    relativeTo: .title3)

    /// Title for splash, loading, storytelling screen
    static let titleMD = Font.custom("Manrope-ExtraBold",
                                    size: 24,
                                    relativeTo: .title2)

    /// Title special case / big hero
    static let titleLG = Font.custom("Manrope-ExtraBold",
                                    size: 32,
                                    relativeTo: .largeTitle)
}
