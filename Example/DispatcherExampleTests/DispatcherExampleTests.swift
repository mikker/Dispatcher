import XCTest

class MockCallback {
    var name: String = ""
    var calls: [[String: Any]] = []
    init(name: String) {
        self.name = name
    }
    func call(payload: Any?) -> Void {
        print("calling \(name) with \(payload)")
        self.calls.append(payload as! [String: Any])
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
    
    func testGeneratesTokens() {
        let tokenA = dispatcher.tokenGenerator.next()!
        let tokenB = dispatcher.tokenGenerator.next()!
        XCTAssertNotEqual(tokenA, tokenB)
    }
    
    func testExecutesAllSubscriberCallbacks() {
        dispatcher.register(callbackA.call)
        dispatcher.register(callbackB.call)
        let payload: [String: Any] = ["test": 1]
        
        dispatcher.dispatch(payload)
        
        XCTAssertEqual(callbackA.calls.count, 1)
        XCTAssertEqual(callbackA.calls[0]["test"] as! Int, 1)
        
        XCTAssertEqual(callbackB.calls.count, 1)
        XCTAssertEqual(callbackB.calls[0]["test"] as! Int, 1)
        
        dispatcher.dispatch(payload)
        
        XCTAssertEqual(callbackA.calls.count, 2)
        XCTAssertEqual(callbackA.calls[1]["test"] as! Int, 1)
        
        XCTAssertEqual(callbackB.calls.count, 2)
        XCTAssertEqual(callbackB.calls[1]["test"] as! Int, 1)
    }
    
    func testWaitsForCallbacksRegisteredEarlier() {
        let tokenA = dispatcher.register(callbackA.call)
        
        dispatcher.register { (payload) -> Void in
            self.dispatcher.waitFor([tokenA])
            XCTAssertEqual(self.callbackA.calls.count, 1)
            XCTAssertEqual(self.callbackA.calls[0]["test"] as! Int, 1)
            self.callbackB.call(payload)
        }
        
        let payload: [String: Any] = ["test": 1]
        dispatcher.dispatch(payload)
        
        XCTAssertEqual(callbackA.calls.count, 1)
        XCTAssertEqual(callbackA.calls[0]["test"] as! Int, 1)
        
        XCTAssertEqual(callbackB.calls.count, 1)
        XCTAssertEqual(callbackB.calls[0]["test"] as! Int, 1)
    }
    
    func testProperlyUnregistersCallbacks() {
        dispatcher.register(callbackA.call)
        let tokenB = dispatcher.register(callbackB.call)
        let payload: [String: Any] = ["test": 1]
        dispatcher.dispatch(payload)
        
        XCTAssertEqual(callbackA.calls.count, 1)
        XCTAssertEqual(callbackA.calls[0]["test"] as! Int, 1)
        
        XCTAssertEqual(callbackB.calls.count, 1)
        XCTAssertEqual(callbackB.calls[0]["test"] as! Int, 1)
        
        dispatcher.unregister(tokenB)
        dispatcher.dispatch(payload)
        
        XCTAssertEqual(callbackA.calls.count, 2)
        XCTAssertEqual(callbackA.calls[1]["test"] as! Int, 1)
        
        XCTAssertEqual(callbackB.calls.count, 1)
    }
    
}
