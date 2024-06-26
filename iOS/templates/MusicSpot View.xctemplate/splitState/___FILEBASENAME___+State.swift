// ___FILEHEADER___

struct ___VARIABLE_productName___ {
    // MARK: - Global
    /// Place global states here which are not owned by any particular view.
    /// These states are shared with the whole view tree.
    /// Initialization can be whenever it is in need (commonly along with the app start) and it lives as long as the app does.
    /// Use ``@Environment`` to use global value types and ``@EnvironmentObject`` for global object types.
    /// > e.g
    /// > ```swift
    /// > @Environment(\.colorScheme) var colorScheme: ColorScheme
    /// > @EnvironmentObject private var stateController: StateController
    /// > ```
    ///
    /// > Note:
    /// > If your observable object conforms to the ``Observable`` protocol, use `Environment` instead of `EnvironmentObject` and set the model object in an ancestor view by calling its ``environment(_:)`` or ``environment(_:_:)`` modifiers.

    // MARK: - Shared
    /// Place shared states here which are owned by an ancestor and shared with the current view.
    /// These states' lifecycle is not managed by current view, but the ancestor owning them.
    /// Use regular property or ``@Binding`` for shared value types and ``@ObservedObject`` for shared object types.
    /// Regular properties are immutable but with ``@Binding``, they can be mutated and is applied to source of truth.
    /// > e.g
    /// > ```swift
    /// > let contact: Contact
    /// > @Binding var isUpdatedRecently: Bool
    /// > ```

    // MARK: - Local
    /// Place local states here which are owned by current view.
    /// These states can also be passes to child views.
    /// They're usually temporary and lives only as long as the view that owns them.
    /// Use a regular constant for immutable local value types, or ``@State`` for mutable local value types.
    /// If you need an object (reference) type, ``@StateObject`` is the right choice.
    /// > e.g
    /// > ```swift
    /// > private let targetModel: ContactModel
    /// > @State private var contact: Contact
    /// > @StateObject private var viewModel: ContactViewModel
    /// > ```
    ///
    /// > Note:
    /// > Use ``@State`` if you need to store a reference type that conforms to the ``Observable`` protocol.
    /// > It's recommended to use access modifiers such as `private`, `internal`, or `fileprivate` to clarify that it is a local state.
}
