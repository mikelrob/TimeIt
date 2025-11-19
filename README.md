# TimeIt

A debugging tool for investigating code execution coordination, sequencing, and timing.

## Overview

TimeIt is a lightweight debugging utility that helps you track timing information and execution order in your Swift code. It provides a simple API to log events with automatic timestamps and compute time intervals between operations.

## Usage

```swift
import TimeIt

// Log events with timestamps
TimeIt.log("myOperation", entry: "Started processing")
// ... do some work ...
TimeIt.log("myOperation", entry: "Finished step 1")
// ... do more work ...
TimeIt.log("myOperation", entry: "Completed")

// Retrieve formatted logs with timing information
TimeIt.complete(log: "myOperation") { logs in
    logs.forEach { print($0) }
    // Output: [myOperation] 14:23:45.1234 0.0000secs Started processing
    //         [myOperation] 14:23:45.2234 0.1000secs Finished step 1
    //         [myOperation] 14:23:45.3234 0.2000secs Completed
}
```

## Documentation

Full API documentation is available as DocC documentation. To generate and view the documentation:

```bash
swift package generate-documentation
```

Or explore the inline documentation in Xcode by Option-clicking on any TimeIt method.

## Installation

Add TimeIt as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/mikelrob/TimeIt.git", from: "1.0.0")
]
```

## Features

- **Simple API**: Just two static methods to log events and retrieve results
- **Thread-Safe**: All operations use a serial dispatch queue for thread safety
- **Time Tracking**: Automatically captures timestamps and computes intervals
- **Organized Logs**: Group related events using named logs
 
