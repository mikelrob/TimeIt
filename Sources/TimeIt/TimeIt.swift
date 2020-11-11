import Foundation

public class TimeIt {
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

    public static func log(_ log: String, entry: String) {
        queue.async {
            storage[log, default: []].append(LogEntry(entry: entry))
        }
    }

    public static func access(log: String, completion: @escaping ([String]) -> Void) {
        queue.async {
            if let logEntries = storage[log], let start = logEntries.first?.stamp {
                let logDescriptions = describe(logEntries: logEntries, started: start, titled: log)
                completion(logDescriptions)
            }
        }
    }

    public static func complete(log: String, completion: @escaping ([String]) -> Void) {
        queue.async {
            if let logEntries = storage.removeValue(forKey: log), let start = logEntries.first?.stamp {
                let logs = describe(logEntries: logEntries, started: start, titled: log)
                completion(logs)
            }
        }
    }

    private static func describe(logEntries: [LogEntry], started start: Date, titled title: String) -> [String] {
        let logs = logEntries.map { logEntry -> String in
            let interval = String(format: "%.4f", logEntry.stamp.timeIntervalSince(start))
            return "[\(title)] \(formatter.string(from: logEntry.stamp)) \(interval)secs \(logEntry.entry)"
        }
        return logs
    }
}
