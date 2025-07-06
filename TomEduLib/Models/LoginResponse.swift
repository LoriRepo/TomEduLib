//
//  LoginResponse.swift
//  TomEdu
//
//  Created by Федор Дуля on 02.07.2025.
//

import Foundation

public struct AuthSummary: Codable {
    public let organizationName: String // Название техникума
    public let groupID: String // Номер группы
    public let userID: Int // Номер студента для обращения к API
    public let firstName: String // Имя
    public let lastName: String // Фамилия
    public let middleName: String // Отчество
}

internal struct LoginResponse: Codable {
    internal let installName: String
    internal let localNetwork: Bool
    internal let tenantName: String
    internal let tenants: [String: Tenant]
}

internal struct Tenant: Codable {
    internal let isTrusted: Bool
    internal let settings: Settings
    internal let studentRole: StudentRole
    internal let firstName: String
    internal let lastName: String
    internal let middleName: String
}

internal struct Settings: Codable {
    internal let organization: Organization
}

internal struct Organization: Codable {
    internal let organizationType: String
    internal let name: String
    internal let shortName: String
    internal let abbreviation: String
    internal let legalStatus: String
    internal let address: Address
    internal let organizationDeptId: Int
    internal let phone: String
    internal let fax: String
    internal let email: String
    internal let site: String
    internal let directorName: String
    internal let directorPosition: String
    internal let studyUnitNumber: String
    internal let organizationStatus: String
    internal let isEntrepreneurOwned: Bool
    internal let entrepreneurName: String
    internal let organizationId: String
    internal let headOrganizationName: String
    internal let isSubdepartment: Bool
    internal let additionalName: String
    internal let type: String
    internal let occupancy: Int
    internal let shiftCount: Int
    internal let legalAddress: String
    internal let actualAddress: String
    internal let rosobrId: String
    internal let bankingDetails: BankingDetails
    internal let administration: Administration
}

internal struct Address: Codable {
    internal let region: String
    internal let settlement: String
    internal let mailAddress: String
    internal let kladr: String
}

internal struct BankingDetails: Codable {
    internal let okved: String
    internal let inn: String
    internal let kpp: String
    internal let ogrn: String
    internal let oktmo: String
    internal let okopth: String
    internal let okths: String
    internal let okpo: String
    internal let others: String
    internal let okogu: String
    internal let founderType: String
    internal let founders: String
    internal let okato: String
}

internal struct Administration: Codable {
    internal let eService: EService
    internal let organizationId: String
    internal let attestation: Attestation
    internal let factHours: FactHours
    internal let vkChats: VkChats
}

internal struct EService: Codable {
    internal let isEnabled: Bool
    internal let cacheEnrolleeListTimeout: Int
    internal let cacheSpecialtyListTimeout: Int
    internal let cacheEnrolleeTimeout: Int
    internal let useRestIntegration: Bool
}

internal struct Attestation: Codable {
    internal let isEnabled: Bool
}

internal struct FactHours: Codable {
    internal let isEnabled: Bool
}

internal struct VkChats: Codable {
    internal let communityId: String
    internal let communityToken: String
}

internal struct StudentRole: Codable {
    internal let id: Int
    internal let studentGroupId: Int
    internal let students: [Student]
}

internal struct Student: Codable {
    internal let groupId: Int
    internal let groupName: String
    internal let firstName: String
    internal let lastName: String
    internal let middleName: String
    internal let id: Int
}
