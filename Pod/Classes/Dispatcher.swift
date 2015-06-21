let prefix = "ID_"
var lastId = 1

public class Dispatcher {
    public static let instance = Dispatcher()

    var callbacks: [String: (AnyObject?) -> Void] = [:]
    var isPending: [String: (Bool)] = [:]
    var isHandled: [String: (Bool)] = [:]
    var isDispatching: Bool = false
    var pendingPayload: AnyObject?
    
    public init() {}
    
    // Public
    
    public func register(callback: (payload: AnyObject?) -> Void) -> String {
        let id = "\(prefix)\(lastId++)"
        callbacks[id] = (callback)
        return id
    }
    
    public func unregister(id: String) {
        if !callbacks.keys.contains(id) {
            debugPrint("Dispatcher.unregister(...): `\(id)` does not map to a registered callback.")
        }
        callbacks.removeValueForKey(id)
    }
    
    public func waitFor(ids: [String]) {
        if !isDispatching {
            debugPrint("Dispatcher.waitFor(...): Must be invoked while dispatching.")
        }
        for id in ids {
            if (isPending[id]!) {
                if !isHandled[id]! {
                    debugPrint("Dispatcher.waitFor(...): Circular dependency detected while waiting for `\(id)`.")
                }
                continue
            }
            invokeCallback(id)
        }
    }
    
    public func dispatch(payload: AnyObject?) {
        if isDispatching {
            debugPrint("Dispatch.dispatch(...): Cannot dispatch in the middle of a dispatch.")
        }
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
    
    private func startDispatching(payload: AnyObject?) {
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