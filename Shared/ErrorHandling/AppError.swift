//
//  AppError.swift
//  RekClient
//
//  Created by Ivan C Myrvold on 02/05/2021.
//

import Foundation

enum AppError: LocalizedError {
    case unknown
    case auth_generic_error
    case auth_invalidCredential
    case auth_userDisabled
    case auth_operationNotAllowed
    case auth_emailAlreadyInUse
    case auth_invalidEmail
    case auth_wrongPassword
    case auth_codeTooManyRequests
    case auth_userNotFound
    case auth_accountExistsWithDifferentCredential
    case auth_networkError(moreDetails: String)
    case auth_invalidUserToken
    case auth_userTokenExpired
    case auth_userMismatch
    case auth_credentialAlreadyInUse
    case auth_missingPhoneNumber
    case auth_invalidPhoneNumber
    case auth_missingVerificationCode
    case auth_invalidVerificationCode
    case auth_missingAppCredential
    case auth_invalidAppCredential
    case auth_sessionExpired
    case auth_quotaExceeded
    case auth_notificationNotForwarded
    case auth_captchaCheckFailed
    case auth_signInUserInteractionFailure
    case auth_rejectedCredential
    case genericWithMessage(message: String)
    case auth_internalError
    case auth_malformedJWT
    case failedToOpenDatabaseModel
    case failedToRetrieveTokenForTheUser
    case apiRequestFailed(error: Error)
    case apiRequestFailedWithMessage(errorMessage: String)
    case apiRequestBadResponseCode(statusCode: Int)
    case currentAuthUserNotFound
    case failedToSaveCurrentUserToDatabase(underlyingError: Error)
    case failedToDecode(error: Error)
    case failedToOpenPersitentStack(error: Error)
    case transactionFailed(status: String)
    case vippsTxCancelled
    case vippsAgreementWasRejected
    case vippsUrlMissingFromBackend
    case vippsFailedToOpen
    case cantOpenEmailApp
    case failedToSendEmail(error: Error?)
    
//    var title: String {
//        let title: String
//        switch self {
//        case .apiRequestFailedWithMessage(let errorMessage):
//            title = ApiRequestAppErrorMessageMap.errorTitleMap[errorMessage] ?? Localized.error
//        default:
//            title = Localized.error
//        }
//        
//        return title
//    }
    
    /*var localizedDescription: String {
        let description: String
        switch self {
        case .unknown:
            description = Localized.unknown
        case .auth_generic_error:
            description = Localized.auth_generic_error
        case .auth_invalidCredential:
            description = Localized.auth_invalidCredential
        case .auth_userDisabled:
            description = Localized.auth_userDisabled
        case .auth_operationNotAllowed:
            description = Localized.auth_operationNotAllowed
        case .auth_emailAlreadyInUse:
            description = Localized.auth_emailAlreadyInUse
        case .auth_invalidEmail:
            description = Localized.auth_invalidEmail
        case .auth_networkError:
            description = "A network error occurred (such as a timeout or interrupted connection). These types of errors are often recoverable with a retry. Please make sure you have internet connection and retry once more "
        case .auth_wrongPassword:
            description = Localized.auth_wrongPassword
        case .auth_codeTooManyRequests:
            description = Localized.auth_codeTooManyRequests
        case .auth_userNotFound:
            description = Localized.auth_userNotFound
        case .auth_accountExistsWithDifferentCredential:
            description = Localized.auth_accountExistsWithDifferentCredential
        case .auth_invalidUserToken:
            description = Localized.auth_invalidUserToken
        case .auth_userTokenExpired:
            description = Localized.auth_userTokenExpired
        case .auth_userMismatch:
            description = Localized.auth_userMismatch
        case .auth_credentialAlreadyInUse:
            description = Localized.auth_credentialAlreadyInUse
        case .auth_missingPhoneNumber:
            description = Localized.auth_missingPhoneNumber
        case .auth_invalidPhoneNumber:
            description = Localized.auth_invalidPhoneNumber
        case .auth_missingVerificationCode:
            description = Localized.auth_missingVerificationCode
        case .auth_invalidVerificationCode:
            description = Localized.auth_invalidVerificationCode
        case .auth_missingAppCredential:
            description = Localized.auth_missingAppCredential
        case .auth_invalidAppCredential:
            description = Localized.auth_invalidAppCredential
        case .auth_sessionExpired:
            description = Localized.auth_sessionExpired
        case .auth_quotaExceeded:
            description = Localized.auth_quotaExceeded
        case .auth_notificationNotForwarded:
            description = Localized.auth_notificationNotForwarded
        case .auth_captchaCheckFailed:
            description = Localized.auth_captchaCheckFailed
        case .auth_signInUserInteractionFailure:
            description = Localized.auth_signInUserInteractionFailure
        case .auth_rejectedCredential:
            description = Localized.auth_rejectedCredential
        case .genericWithMessage(let message):
            description = message
        case .auth_internalError:
            description = Localized.auth_internalError
        case .auth_malformedJWT:
            description = Localized.auth_malformedJWT
        case .failedToOpenDatabaseModel:
            description = Localized.failed_to_open_db_model_error
        case .failedToRetrieveTokenForTheUser:
            description = Localized.no_token_for_the_user_error
        case .apiRequestFailed(let error):
            description = String(format: Localized.api_request_failed_error_format, error.localizedDescription)
        case .apiRequestBadResponseCode(let code):
            description = String(format: Localized.bad_response_error_message_format, String(code))
        case .apiRequestFailedWithMessage(let errorMessage):
            description = ApiRequestAppErrorMessageMap.errorMessageMap[errorMessage] ?? errorMessage
        case .currentAuthUserNotFound:
            description = Localized.auth_user_not_found_error
        case .failedToSaveCurrentUserToDatabase(let underlyingError):
            description = String(format: Localized.failed_to_save_profile_to_db_error_format, underlyingError.localizedDescription)
        case .failedToDecode(let error):
            description = String(format: Localized.failed_to_decode_data_error_format, error.localizedDescription)
        case .failedToOpenPersitentStack(let error):
            description = String(format: Localized.failed_to_open_persistent_stack_error_format, error.localizedDescription)
        case .transactionFailed(let status):
            description = String(format: Localized.tx_failed_with_status_format, status)
        case .vippsTxCancelled:
            description = Localized.vipps_tx_cancelled
        case .vippsAgreementWasRejected:
            description = Localized.vipps_agreement_rejected
        case .vippsUrlMissingFromBackend:
            description = "Missing vipps url from backend"
        case .vippsFailedToOpen:
            description = "Vipps failed to open, please try again later"
        case .cantOpenEmailApp:
            description = "Failed to open Mail app, the device is not set up for sending email"
        case .failedToSendEmail(let error):
            var text = "Failed to send email."
            if let errorReceived = error {
                text.append("Details: \(errorReceived.localizedDescription)")
            }
            description = text
        }
        
        return description
    }*/
}
