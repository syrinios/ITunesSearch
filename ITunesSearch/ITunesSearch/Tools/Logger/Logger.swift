import UIKit
import Foundation
import MessageUI


/**
 * Used to manage all app logs. Same usage as print function. Please do not use print(). See shortend below
 ``````````````
  LOG("my message", category: mycategory)
  WLOG("my message") -> category = .warning
  ELOG("my message") -> category = .error
 ``````````````
 */
class Logger: NSObject, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {

    var loggerViewDisplayed: Bool = false
    var logMessages: [String] = Array()
    
    // MARK: Singleton
    static let sharedInstance: Logger = {
        let instance = Logger()
        return instance
    }()

    // MARK: Public interface
    enum LogCategory: String {
        case none      = "   "
        case info      = "ℹ️ "
        case warning   = "⚠️ "
        case error     = "⛔️ "
        case success   = "✅ "
        case likeABoss = "😎 "
        case test      = "❔ "
        case request   = "➡️ "
        case response  = "⬅️ "
        case start     = "🚀 "
        case end       = "🏁 "
        case package   = "📦 "
    }


    
    /// Used to print message. Use shortend instead of this method
    ///
    /// - Parameters:
    ///   - message: message to print
    ///   - category: category of the message
    func log(message: Any..., category: LogCategory) {
        let fullMessage = category.rawValue
            .appending(self.getString(from: message))
            .replacingOccurrences(of: "\n", with: "\n   ")
        logMessages.append(fullMessage)
        if let logFile = self.logFile, let data = fullMessage.appending("\n").data(using: .utf8) {
            logFile.write(data)
        }
        
        print(fullMessage)
    }
    
    
    /// Send the logs by email
    func sendDebugLogs() {
        let files = self.listAllLogs()

        if files.count > 1 {
            let ac = UIAlertController(title: "Debug logs",
                                       message: String(format: "%d logs saved.",
                                                       files.count),
                                       preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Send all",
                                       style: .default,
                                       handler: self.sendAllLogs))
            ac.addAction(UIAlertAction(title: "Send the previous one",
                                       style: .default,
                                       handler: self.sendLastLog))
            ac.addAction(UIAlertAction(title: "Send the current one",
                                       style: .default,
                                       handler: self.sendCurrentLog))

            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            if ac.popoverPresentationController != nil {
                // don't present alert controller for iPad
                return
            }

            if let rvc = UIApplication.shared.keyWindow?.rootViewController {
                rvc.present(ac, animated: true, completion: nil)
            }
        } else if files.count > 0 {
            self.sendCurrentLog(UIAlertAction(title: "Log", style: .default, handler: nil))
        }

    }

    // MARK: Properties
    lazy private var logDirectory: URL? = {
        guard let docsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                           in: .userDomainMask).first else {
                                                            return nil
        }

        let logDirectory = docsDirectory.appendingPathComponent("debugLogs")
        do {
            try FileManager.default.createDirectory(at: logDirectory,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            LOG("Cannot create log directory at \(logDirectory)", category: .error)
            return nil
        }
        return logDirectory
    }()

    lazy private var logFilename: URL? = {
        guard let logDirectory = self.logDirectory else {
            return nil
        }
        if let projectName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String {
            return logDirectory
                .appendingPathComponent("\(projectName)-log-\(round(Date().timeIntervalSince1970)).txt")
        } else {
            return logDirectory.appendingPathComponent("log.txt")
        }

    }()

    lazy private var logFile: FileHandle? = {
        guard let fn = self.logFilename else {
            return nil
        }

        let fileHandle: FileHandle?
        do {
            FileManager.default.createFile(atPath: fn.path, contents: nil, attributes: nil)
            fileHandle = try FileHandle(forWritingTo: fn)
        } catch {
            LOG("Cannot create file handle for writing at \(fn.path): \(error)", category: .error)
            return nil
        }
        fileHandle?.seekToEndOfFile()
        return fileHandle
    }()
    
    lazy private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ssSS"
        return dateFormatter
    }()

    private func listAllLogs() -> [String] {
        guard let dir = self.logDirectory else { return [] }

        var files: [String]
        do {
            files = try FileManager.default.contentsOfDirectory(atPath: dir.path)
        } catch { return [] }
        files.sort()

        return files
    }

    private func getString(from obj: Any, withoutTime: Bool = false) -> String {
        if let o = obj as? String {
            return withoutTime ? o : dateFormatter.string(from: Date()) + " " + o
        } else if let o = obj as? [Any] {
            var msg = withoutTime ? "" : dateFormatter.string(from: Date()) + " "
            for item in o {
                msg += self.getString(from: item, withoutTime: true) + " "
            }
            return msg
        } else {
            return withoutTime ? String(describing: obj) : dateFormatter.string(from: Date()) + " " + String(describing: obj)
        }
    }
    
    private func sendAllLogs(_ action: UIAlertAction) {
        self.sendLogs(self.listAllLogs())
    }
 
    private func sendLastLog(_ action: UIAlertAction) {
        let files = listAllLogs()
        if files.count >= 2 {
            self.sendLogs([files[files.count - 2]])
        }
    }

    private func sendCurrentLog(_ action: UIAlertAction) {
        if let f = self.logFilename {
            self.sendLogs([f.lastPathComponent])
        }
    }

    private var logsToDelete: [String] = []

    private func sendLogs(_ filenames: [String]) {
        guard let dir = self.logDirectory else { return }
        
        let mailer = MFMailComposeViewController()
        mailer.delegate = self
        mailer.mailComposeDelegate = self
        mailer.setToRecipients(["ferjanisyrine91@gmail.com"])
        mailer.setSubject("Debug logs Itunes Serach")
        logsToDelete = []
        filenames.forEach { filename in
            var data: Data
            do {
                data = try Data(contentsOf: dir.appendingPathComponent(filename))
            } catch {
                return
            }
            mailer.addAttachmentData(data, mimeType: "text/plain", fileName: filename)

            if filename != self.logFilename?.lastPathComponent {
                logsToDelete.append(filename)
            }
        }

        if let rvc = UIApplication.shared.keyWindow?.rootViewController, MFMailComposeViewController.canSendMail() {
            rvc.present(mailer, animated: true, completion: nil)
        }
    }

    internal func mailComposeController(_ controller: MFMailComposeViewController,
                                        didFinishWith result: MFMailComposeResult,
                                        error: Error?) {

        controller.dismiss(animated: true) {

            switch result {
            case .sent:

                //TODO ask to delete sent logs (except current)

                let ac = UIAlertController(title: nil,
                                           message: "Delete sent logs ?",
                                           preferredStyle: .actionSheet)
                ac.addAction(UIAlertAction(title: "Delete",
                                           style: .destructive,
                                           handler: { _ in
                    guard let dir = self.logDirectory else { return }
                    self.logsToDelete.forEach { filename in
                        do {
                            try FileManager.default.removeItem(at: dir.appendingPathComponent(filename))
                        } catch {
                            return
                        }
                    }
                    self.logsToDelete = []

                }))
                ac.addAction(UIAlertAction(title: "Keep", style: .cancel, handler: nil))

                if let rvc = UIApplication.shared.keyWindow?.rootViewController {
                    rvc.present(ac, animated: true, completion: nil)
                }

            default: break
            }
        }
    }
}



/// Shorthand
#if FILDISTR
    func LOG(_ message: String, _ category: Logger.LogCategory = .none) {
    }
    func LOG(_ message: Any..., category: Logger.LogCategory = .none) {
    }
    func WLOG(_ message: Any...) {
    }
    func ELOG(_ message: Any...) {
    }
#else
    func LOG(_ message: String, _ category: Logger.LogCategory = .none) {
        Logger.sharedInstance.log(message: message, category: category)
    }
    func LOG(_ message: Any..., category: Logger.LogCategory = .none) {
        Logger.sharedInstance.log(message: message, category: category)
    }
    func WLOG(_ message: Any...) {
        Logger.sharedInstance.log(message: message, category: .warning)
    }
    func ELOG(_ message: Any...) {
        Logger.sharedInstance.log(message: message, category: .error)
    }
#endif
