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
