public class Dispatcher {
    public typealias Callback = Any? -> Void
    
    public var tokenGenerator: TokenStream.Generator = TokenStream(prefix: "ID_").generate()
    
    var callbacks: [String: Callback] = [:]
    var isPending: [String: (Bool)] = [:]
    var isHandled: [String: (Bool)] = [:]
    var isDispatching: Bool = false
    var pendingPayload: Any?
    
    public init() {}
    
    // Public
    
    public func register(callback: Callback) -> String {
        if let id = tokenGenerator.next() {
            callbacks[id] = callback
            return id
        }
        
        preconditionFailure("Dispatcher.register(...): Failed to generate token for registration.")
    }
    
    public func unregister(id: String) {
        precondition(callbacks.keys.contains(id),
            "Dispatcher.unregister(...): `\(id)` does not map to a registered callback.")
        callbacks.removeValueForKey(id)
    }
    
    public func waitFor(ids: [String]) {
        precondition(isDispatching, "Dispatcher.waitFor(...): Must be invoked while dispatching.")
        
        for id in ids {
            if (isPending[id]!) {
                precondition(isHandled[id] != nil, "Dispatcher.waitFor(...): Circular dependency detected while waiting for `\(id)`.")
                continue
            }
            invokeCallback(id)
        }
    }
    
    public func dispatch(payload: Any?) {
        precondition(!isDispatching, "Dispatch.dispatch(...): Cannot dispatch in the middle of a dispatch.")

        startDispatching(payload)
        defer { stopDispatching() }

        for id in callbacks.keys {
            if isPending[id]! {
                continue
            }
            invokeCallback(id)
        }
    }
    
    // Private
    
    private func invokeCallback(id: String) {
        isPending[id] = true
        callbacks[id]!(pendingPayload)
        isHandled[id] = true
    }
    
    private func startDispatching(payload: Any?) {
        for id in callbacks.keys {
            isPending[id] = false
            isHandled[id] = false
        }
        pendingPayload = payload
        isDispatching = true
    }
    
    private func stopDispatching() {
        pendingPayload = nil
        isDispatching = false
    }
}

// TokenStream

extension Dispatcher {
    public struct TokenStream {
        let prefix: String
    }
}

extension Dispatcher.TokenStream: CollectionType {
    public typealias Index = Int
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return Int.max }
    
    public subscript(index: Int) -> String {
        get { return "\(prefix)\(index)" }
    }
    
    public func generate() -> IndexingGenerator<Dispatcher.TokenStream> {
        return IndexingGenerator(self)
    }
}