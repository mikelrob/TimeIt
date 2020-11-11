import XCTest
import TimeIt

final class TimeItTests: XCTestCase {

    static var allTests = [
        ("testTimeItAccesses", testTimeItAccesses),
        ("testTimeItCompletes", testTimeItCompletes),
    ]

    func testTimeItAccesses() {
        TimeIt.log("test", entry: "first")
        TimeIt.log("test", entry: "second")

        let e = expectation(description: "logs in correct order")

        TimeIt.access(log: "test") { logs in
            guard logs[0].contains("first") else { XCTFail("first log message not correct"); return }
            guard logs[1].contains("second") else { XCTFail("second log message not correct"); return }
        }

        TimeIt.log("test", entry: "third")

        TimeIt.access(log: "test") { logs in
            guard logs[2].contains("third") else { XCTFail("third log message not correct"); return }
            e.fulfill()
        }
        waitForExpectations(timeout: 0.5)
    }

    func testTimeItCompletes() {
        TimeIt.log("test", entry: "first")
        TimeIt.log("test", entry: "second")

        let e = expectation(description: "logs in correct order")

        TimeIt.complete(log: "test") { logs in
            guard logs[0].contains("first") else { XCTFail("first log message not correct"); return }
            guard logs[1].contains("second") else { XCTFail("second log message not correct"); return }
        }

        TimeIt.log("test", entry: "second")

        TimeIt.complete(log: "test") { logs in
            guard logs[0].contains("third") else { e.fulfill(); return }
        }
        waitForExpectations(timeout: 0.5)
    }
}
