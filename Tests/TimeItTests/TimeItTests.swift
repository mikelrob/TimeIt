import XCTest
import TimeIt

final class TimeItTests: XCTestCase {

    func testTimeIt() {
        TimeIt.log("test", entry: "first")
        TimeIt.log("test", entry: "second")

        let e = expectation(description: "logs in correct order")

        TimeIt.complete(log: "test") { logs in
            guard logs[0].contains("first") else { XCTFail("first log message not correct"); return }
            guard logs[1].contains("second") else { XCTFail("second log message not correct"); return }
            e.fulfill()
        }

        waitForExpectations(timeout: 0.5)
    }

    static var allTests = [
        ("testExample", testTimeIt),
    ]
}
