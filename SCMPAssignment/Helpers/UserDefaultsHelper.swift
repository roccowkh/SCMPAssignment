import Foundation

class UserDefaultsHelper {
    static let shared = UserDefaultsHelper()
    private let memberListKey = "memberList"

    private init() {}

    func saveMemberList(_ members: [MemberDetails]) {
        if let data = try? JSONEncoder().encode(members) {
            UserDefaults.standard.set(data, forKey: memberListKey)
            print("saved member list to userdefault")
        }
    }

    func getMemberList() -> [MemberDetails]? {
        print("loading member list from userdefault")
        guard let data = UserDefaults.standard.data(forKey: memberListKey) else { return nil }
        print("data size \(data.count)")
        return try? JSONDecoder().decode([MemberDetails].self, from: data)
    }

    func clearMemberList() {
        UserDefaults.standard.removeObject(forKey: memberListKey)
    }
} 
