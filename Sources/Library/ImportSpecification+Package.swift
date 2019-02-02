import struct Foundation.URL
import ImportSpecification

public extension ImportSpecification {
    var packageLine: String {
        var requirement: String {
            switch constraint {
            case .upToNextMajor(from: let v):
                return """
                .upToNextMajor(from: "\(v)")
                """
            case .exact(let v):
                return ".exact(\"\(v.major).\(v.minor).\(v.patch)\")"
            case .ref(let ref):
                return """
                .revision("\(ref)")
                """
            }
        }
        let urlstr: String
        if let url = URL(string: dependencyName), url.scheme != nil {
            urlstr = dependencyName
        } else {
            urlstr = "https://github.com/\(dependencyName).git"
        }
        return """
        .package(url: "\(urlstr)", \(requirement))
        """
    }
}

public extension Array where Element == ImportSpecification {
    var mainTargetDependencies: String {
        return map { """
            "\($0.importName)"
            """
        }.joined(separator: ", ")
    }

    var packageLines: String {
        return map{ $0.packageLine }.joined(separator: ",\n    ")
    }
}
