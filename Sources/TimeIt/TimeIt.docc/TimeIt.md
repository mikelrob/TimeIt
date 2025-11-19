# ``TimeIt``

A debugging tool for investigating code execution coordination, sequencing, and timing.

## Overview

TimeIt is a lightweight debugging utility that helps you track timing information and execution order in your Swift code. It provides a simple API to log events with automatic timestamps and compute time intervals between operations.

### Key Features

- **Simple API**: Just two static methods to log events and retrieve results
- **Thread-Safe**: All operations use a serial dispatch queue for thread safety
- **Time Tracking**: Automatically captures timestamps and computes intervals
- **Organized Logs**: Group related events using named logs

### Usage Example

Here's a simple example of using TimeIt to track the execution of an async operation:

```swift
import TimeIt

// Start tracking events
TimeIt.log("networkRequest", entry: "Request started")

// ... perform network request ...
TimeIt.log("networkRequest", entry: "Response received")

// ... process response ...
TimeIt.log("networkRequest", entry: "Processing complete")

// Retrieve formatted logs with timing information
TimeIt.complete(log: "networkRequest") { logs in
    for log in logs {
        print(log)
        // Output format: [networkRequest] 14:23:45.1234 0.1234secs Request started
    }
}
```

### When to Use TimeIt

TimeIt is particularly useful for:

- Debugging asynchronous code execution order
- Measuring performance of different code paths
- Understanding timing dependencies in complex operations
- Investigating race conditions and timing-related bugs

## Topics

### Logging and Completion

- ``TimeIt/log(_:entry:)``
- ``TimeIt/complete(log:completion:)``
