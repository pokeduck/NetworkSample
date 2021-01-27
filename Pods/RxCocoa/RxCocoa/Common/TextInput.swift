//
//  TextInput.swift
//  RxCocoa
//
//  Created by Krunoslav Zaher on 5/12/16.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//

import RxSwift

#if os(iOS) || os(tvOS)
    import UIKit

    /// Represents text input with reactive extensions.
    public struct TextInput<Base: UITextInput> {
        /// Base text input to extend.
        public let base: Base

        /// Reactive wrapper for `text` property.
        public let text: ControlProperty<String?>

        /// Initializes new text input.
        ///
        /// - parameter base: Base object.
        /// - parameter text: Textual control property.
        public init(base: Base, text: ControlProperty<String?>) {
            self.base = base
            self.text = text
        }
    }

    public extension Reactive where Base: UITextField {
        /// Reactive text input.
        var textInput: TextInput<Base> {
            TextInput(base: base, text: text)
        }
    }

    public extension Reactive where Base: UITextView {
        /// Reactive text input.
        var textInput: TextInput<Base> {
            TextInput(base: base, text: text)
        }
    }

#endif

#if os(macOS)
    import Cocoa

    /// Represents text input with reactive extensions.
    public struct TextInput<Base: NSTextInputClient> {
        /// Base text input to extend.
        public let base: Base

        /// Reactive wrapper for `text` property.
        public let text: ControlProperty<String?>

        /// Initializes new text input.
        ///
        /// - parameter base: Base object.
        /// - parameter text: Textual control property.
        public init(base: Base, text: ControlProperty<String?>) {
            self.base = base
            self.text = text
        }
    }

    public extension Reactive where Base: NSTextField, Base: NSTextInputClient {
        /// Reactive text input.
        var textInput: TextInput<Base> {
            TextInput(base: base, text: text)
        }
    }

#endif
