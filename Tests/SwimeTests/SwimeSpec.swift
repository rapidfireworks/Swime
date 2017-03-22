import Foundation
import Nimble
import Quick

@testable import Swime

class SwimeSpec: QuickSpec {
  override func spec() {
    describe(".readBytes()") {
      context("when we want to read 4 bytes of string data") {
        let str = "hello"
        let data = str.data(using: .utf8)!
        let swime = Swime(data: data)
        let bytes = swime.readBytes(count: 4)

        it("should return 4 bytes") {
          expect(bytes.count) == 4
        }

        it("should return correct bytes") {
          let endIndex = str.index(str.startIndex, offsetBy: 4)
          let substr = str.substring(to: endIndex)
          let expectation = [UInt8](substr.utf8)

          expect(bytes) == expectation
        }
      }
    }

    describe(".mimeType()") {
      let extensions = [
        "7z",
        "amr",
        "ar",
        "avi",
        "bmp",
        "bz2",
        "cab",
        "cr2",
        "crx",
        "deb",
        "dmg",
        "eot",
        "epub",
        "exe",
        "flac",
        "flif",
        "flv",
        "gif",
        "ico",
        "jpg",
        "jxr",
        "m4a",
        "m4v",
        "mid",
        "mkv",
        "mov",
        "mp3",
        "mp4",
        "mpg",
        "msi",
        "mxf",
        "nes",
        "ogg",
        "opus",
        "otf",
        "pdf",
        "png",
        "ps",
        "psd",
        "rar",
        "rpm",
        "rtf",
        "sqlite",
        "swf",
        "tar",
        "tar.Z",
        "tar.gz",
        "tar.lz",
        "tar.xz",
        "ttf",
        "wav",
        "webm",
        "webp",
        "wmv",
        "woff",
        "woff2",
        "xpi",
        "zip"
      ]

      let mimeTypeByExtension = [
        "tar.Z": "application/x-compress",
        "tar.gz": "application/gzip",
        "tar.lz": "application/x-lzip",
        "tar.xz": "application/x-xz"
      ]

      for ext in extensions {
        context("when extension is \(ext)") {
          let projectDir = FileManager.default.currentDirectoryPath
          let path = "\(projectDir)/Tests/SwimeTests/fixtures/fixture.\(ext)"
          let url = URL(fileURLWithPath: path, isDirectory: false)
          let data = try! Data(contentsOf: url)

          it("shoud guess the correct mime type") {
            let swime = Swime(data: data)

            if let mimeType = mimeTypeByExtension[ext] {
              expect(swime.mimeType()?.mime) == Optional.some(mimeType)
            } else {
              expect(swime.mimeType()?.ext) == Optional.some(ext)
            }
          }
        }
      }
    }
  }
}
