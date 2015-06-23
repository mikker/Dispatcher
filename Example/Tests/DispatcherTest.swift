import XCTest
import Dispatcher

class MockCallback {
    var name: String = ""
    var calls: [Any?] = []
    init(name: String) {
        self.name = name
    }
    func call(payload: Any?) -> Void {
        print("calling \(name) with \(payload)")
        self.calls.append(payload)
    }
}

class DispatcherTest: XCTestCase {
    
    var dispatcher: Dispatcher!
    var callbackA: MockCallback!
    var callbackB: MockCallback!
    
    override func setUp() {
        super.setUp()
        dispatcher = Dispatcher()
        callbackA = MockCallback(name: "A")
        callbackB = MockCallback(name: "B")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExecutesAllSubscriberCallbacks() {
        dispatcher.register(callbackA.call)
        dispatcher.register(callbackB.call)
        let payload = [:]
        
        dispatcher.dispatch(payload)
        
        XCTAssertEqual(callbackA.calls.count, 1)
        XCTAssertEqual(callbackA.calls[0]! === payload)

        XCTAssertEqual(callbackB.calls.count, 1)
        XCTAssert(callbackB.calls[0]! === payload)

        dispatcher.dispatch(payload)
        
        XCTAssertEqual(callbackA.calls.count, 2)
        XCTAssert(callbackA.calls[1]! === payload)
        
        XCTAssertEqual(callbackB.calls.count, 2)
        XCTAssert(callbackB.calls[1]! === payload)
    }
    
    func testWaitsForCallbacksRegisteredEarlier() {
        let tokenA = dispatcher.register(callbackA.call)
        
        dispatcher.register { (payload) -> Void in
            self.dispatcher.waitFor([tokenA])
            XCTAssertEqual(self.callbackA.calls.count, 1)
            XCTAssert(payload === self.callbackA.calls[0]!)
            self.callbackB.call(payload)
        }
        
        let payload = [:]
        dispatcher.dispatch(payload)
        
        XCTAssertEqual(callbackA.calls.count, 1)
        XCTAssert(callbackA.calls[0]! === payload)
   
        XCTAssertEqual(callbackB.calls.count, 1)
        XCTAssert(callbackB.calls[0]! === payload)
    }
    
    func testProperlyUnregistersCallbacks() {
        dispatcher.register(callbackA.call)
        let tokenB = dispatcher.register(callbackB.call)
        let payload = [:]
        dispatcher.dispatch(payload)
        
        XCTAssertEqual(callbackA.calls.count, 1)
        XCTAssert(callbackA.calls[0]! === payload)
        
        XCTAssertEqual(callbackB.calls.count, 1)
        XCTAssert(callbackB.calls[0]! === payload)
        
        dispatcher.unregister(tokenB)
        dispatcher.dispatch(payload)
        
        XCTAssertEqual(callbackA.calls.count, 2)
        XCTAssert(callbackA.calls[1]! === payload)
        
        XCTAssertEqual(callbackB.calls.count, 1)
    }
    
}
