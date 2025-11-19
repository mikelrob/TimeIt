import Foundation

/// A debugging tool for investigating code execution coordination, sequencing, and timing.
///
/// `TimeIt` helps you track timing information and execution order in your code by
/// logging entries with timestamps and computing time intervals between events.
///
/// ## Overview
///
/// Use `TimeIt` to create named logs that capture execution events with timestamps.
/// When you're done logging, call ``complete(log:completion:)`` to retrieve
/// formatted log entries showing time intervals from the start.
///
/// ## Usage
///
/// ```swift
/// // Log some events
/// TimeIt.log("myOperation", entry: "Started processing")
/// // ... do some work ...
/// TimeIt.log("myOperation", entry: "Finished step 1")
/// // ... do more work ...
/// TimeIt.log("myOperation", entry: "Completed")
///
/// // Retrieve the formatted log
/// TimeIt.complete(log: "myOperation") { logs in
///     logs.forEach { print($0) }
/// }
/// ```
///
/// ## Thread Safety
///
/// All operations are thread-safe and use an internal serial dispatch queue.
public class TimeIt {
    /// A log entry capturing a message and timestamp.
    struct LogEntry {
        let entry: String
        let stamp = Date()
    }

    private static let queue = DispatchQueue(label: "com.mikerobinson.me.timeit")
    private static var storage = [String: [LogEntry]]()
    private static let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "H:mm:ss.SSSS"
        return df
    }()

    /// Logs an entry with a timestamp to a named log.
    ///
    /// Creates a new log entry associated with the specified log name. Each entry is
    /// timestamped automatically. Multiple entries can be logged to the same log name,
    /// and they will be stored in order until retrieved with ``complete(log:completion:)``.
    ///
    /// - Parameters:
    ///   - log: The name of the log to add this entry to. Multiple calls with the same
    ///          log name will accumulate entries in the same log.
    ///   - entry: A descriptive message for this log entry.
    ///
    /// - Note: This operation is asynchronous and thread-safe.
    ///
    /// ## Example
    ///
    /// ```swift
    /// TimeIt.log("download", entry: "Started download")
    /// // ... perform download ...
    /// TimeIt.log("download", entry: "Download complete")
    /// ```
    public static func log(_ log: String, entry: String) {
        queue.async {
            storage[log, default: []].append(LogEntry(entry: entry))
        }
    }

    /// Completes a log and returns all entries with timing information.
    ///
    /// Retrieves and removes all entries for the specified log name, formatting each entry
    /// with its timestamp and time interval from the first entry.
    ///
    /// Each formatted log line contains:
    /// - The log name in brackets
    /// - The absolute timestamp (H:mm:ss.SSSS format)
    /// - The time interval in seconds from the first entry
    /// - The entry message
    ///
    /// - Parameters:
    ///   - log: The name of the log to complete and retrieve.
    ///   - completion: A closure called with an array of formatted log strings.
    ///                 If the log doesn't exist, the array will be empty.
    ///
    /// - Note: This operation is asynchronous and thread-safe. The log is removed
    ///         from storage after completion, so subsequent calls with the same
    ///         log name will return empty arrays.
    ///
    /// ## Example
    ///
    /// ```swift
    /// TimeIt.complete(log: "myLog") { logs in
    ///     for log in logs {
    ///         print(log)
    ///         // Prints: [myLog] 14:23:45.1234 0.1234secs Entry message
    ///     }
    /// }
    /// ```
    public static func complete(log: String, completion: @escaping ([String]) -> Void) {
        queue.async {
            if let logEntries = storage.removeValue(forKey: log), let start = logEntries.first?.stamp {
                let logs = logEntries.map { logEntry -> String in
                    let interval = String(format: "%.4f", logEntry.stamp.timeIntervalSince(start))
                    return "[\(log)] \(formatter.string(from: logEntry.stamp)) \(interval)secs \(logEntry.entry)"
                }
                completion(logs)
            }
        }
    }
}
