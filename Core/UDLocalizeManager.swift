//
//  UDLocalizeManager.swift
//  UseDesk_SDK_Swift


import Foundation

class UDLocalizeManager {
    var languages: [String : Any] = [:]
    
    private var enLocale: [String:String] = [:]
    private var ruLocale: [String:String] = [:]
    private var ptLocale: [String:String] = [:]
    private var esLocale: [String:String] = [:]
    
    init() {
        enLocale = getEnLocale()
        ruLocale = getRuLocale()
        ptLocale = getPtLocale()
        esLocale = getEsLocale()
        languages = [
            "en" : enLocale,
            "ru" : ruLocale,
            "pt" : ptLocale,
            "es" : esLocale
        ]
    }
    
    func getLocaleFor(localeId: String) -> [String:String]? {
        if let locale = languages[localeId] as? [String:String] {
            return locale
        } else {
            if localeId.count >= 2 {
                let shorhLocaleId: String = String(localeId[localeId.startIndex..<localeId.index(localeId.startIndex, offsetBy: 2)])
                if let locale = languages[shorhLocaleId] as? [String:String] {
                    return locale
                }
            }
            return nil
        }
    }
    
    // MARK: - Russia
    private func getRuLocale() -> [String:String] {
        let ruLocale: [String:String] = [
            "Copy"                     : "Копировать",
            "Yesterday"                : "Вчера",
            "Today"                    : "Сегодня",
            "Close"                    : "Закрыть",
            "GoToSettings"             : "Перейти в настройки",
            "AllowMedia"               : "Разрешите доступ к фото и видео в настройках",
            "AllowCamera"              : "Разрешите доступ к камере в настройках",
            "ToSendMedia"              : "Для отправки фото или видео",
            "Article"                  : "Статья",
            "Category"                 : "Категория",
            "KnowlengeBase"            : "База знаний",
            "Search"                   : "Поиск",
            "Cancel"                   : "Отменить",
            "ArticleReviewForSubject"  : "Отзыв о статье",
            "KnowlengeBaseTag"         : "БЗ",
            "OnlineChat"               : "Онлайн-чат",
            "Chat"                     : "Чат",
            "File"                     : "файл",
            "File2"                    : "файла",
            "File3"                    : "файлов",
            "Attach"                   : "Прикрепить",
            "Write"                    : "Написать",
            "AttachmentLimit"          : "Прикреплено максимальное количество файлов",
            "Ok"                       : "ОК",
            "Gallery"                  : "Галерея",
            "ErrorLoading"             : "Ошибка загрузки",
            "Loading"                  : "Загрузка",
            "DeleteMessage"            : "Удалить сообщение",
            "SendAgain"                : "Отправить повторно",
            "CSIReviewLike"            : "Оценка: отлично",
            "CSIReviewDislike"         : "Оценка: плохо",
            //Статья
            "Send"                     : "Отправить",
            "ArticleReviewSendTitle"   : "Посоветуйте, как нам улучшить статью?",
            "Yes"                      : "ДА",
            "No"                       : "НЕТ",
            "ArticleReviewFirstTitle"  : "Была ли статья полезна?",
            "ArticleReviewSendedTitle" : "Спасибо за отзыв!",
            //ФОС
            "Message"                  : "Сообщение",
            "Email"                    : "Почта",
            "ErrorEmail"               : "Неправильно введена почта",
            "MandatoryField"           : "Обязательное поле",
            "Name"                     : "Имя",
            "TopicTitle"               : "Тема обращения",
            "CustomField"              : "Дополнительное поле",
            "Error"                    : "Ошибка",
            "ServerError"              : "Сервер не отвечает. Проверьте соединение и попробуйте еще раз.",
            "Understand"               : "Понятно",
            "FeedbackSendedMessage"    : "Сообщение отправлено! \n Ответим вам в течение 1 рабочего дня.",
            "FeedbackText"             : "Все операторы заняты. Оставьте сообщение, мы ответим вам на почту в течение 1 рабочего дня."
        ]
        return ruLocale
    }
    
    // MARK: - English
    private func getEnLocale() -> [String:String] {
        let enLocale: [String:String] = [
            "Copy"                     : "Copy",
            "Yesterday"                : "Yesterday",
            "Today"                    : "Today",
            "Close"                    : "Close",
            "GoToSettings"             : "Go to settings",
            "AllowMedia"               : "Allow access to digital media and files",
            "AllowCamera"              : "Allow access to the camera",
            "ToSendMedia"              : "To send photo/video",
            "Article"                  : "Article",
            "Category"                 : "Category",
            "KnowlengeBase"            : "Knowledge Base",
            "Search"                   : "Search",
            "Cancel"                   : "Cancel",
            "ArticleReviewForSubject"  : "Article review",
            "KnowlengeBaseTag"         : "Knowlenge Base",
            "OnlineChat"               : "Online-chat",
            "Chat"                     : "Chat",
            "File"                     : "File",
            "File2"                    : "File",
            "File3"                    : "File",
            "Attach"                   : "Attach",
            "Write"                    : "Text",
            "AttachmentLimit"          : "Attachment limit reached",
            "Ok"                       : "OK",
            "Gallery"                  : "Gallery",
            "ErrorLoading"             : "Error loading",
            "Loading"                  : "Loading",
            "DeleteMessage"            : "Delete message",
            "SendAgain"                : "Resend",
            "CSIReviewLike"            : "Rating: excellent",
            "CSIReviewDislike"         : "Rating: poor",
            //Статья
            "Send"                     : "Send",
            "ArticleReviewSendTitle"   : "Let us know how we could do better?",
            "Yes"                      : "Yes",
            "No"                       : "No",
            "ArticleReviewFirstTitle"  : "Was this article helpful?",
            "ArticleReviewSendedTitle" : "Thanks for review!",
            //ФОС
            "Message"                  : "Message",
            "Email"                    : "Mail",
            "ErrorEmail"               : "Invalid login",
            "MandatoryField"           : "Mandatory field",
            "Name"                     : "Name",
            "TopicTitle"               : "Subject of appeal",
            "CustomField"              : "Additional field",
            "Error"                    : "Error",
            "ServerError"              : "The server isn't responding. Check your connection and try again.",
            "Understand"               : "OK",
            "FeedbackSendedMessage"    : "Your message has been sent. We will reply to you within one business day.",
            "FeedbackText"             : "All agents are busy at this time. Leave your message and we'll answer withing one working day."
        ]
        return enLocale
    }
    
    // MARK: - Portugal
    private func getPtLocale() -> [String:String] {
        let ptLocale: [String:String] = [
            "Copy"                     : "Copiar",
            "Yesterday"                : "Ontem",
            "Today"                    : "Hoje",
            "Close"                    : "Fechar",
            "GoToSettings"             : "Ir para as configurações",
            "AllowMedia"               : "Permitir o acesso a arquivos e  media digital ",
            "AllowCamera"              : "Permitir acesso à câmera",
            "ToSendMedia"              : "Para enviar foto / vídeo",
            "Article"                  : "Artigo",
            "Category"                 : "Categoria",
            "KnowlengeBase"            : "Base de Conhecimento",
            "Search"                   : "Pesquisar",
            "Cancel"                   : "Cancelar",
            "ArticleReviewForSubject"  : "Avaliação do artigo",
            "KnowlengeBaseTag"         : "Base de Conhecimento",
            "OnlineChat"               : "Chat online",
            "Chat"                     : "Chat",
            "File"                     : "Arquivo",
            "File2"                    : "Arquivo",
            "File3"                    : "Arquivo",
            "Attach"                   : "Anexar",
            "Write"                    : "Escrever",
            "AttachmentLimit"          : "Limite de anexos atingido",
            "Ok"                       : "OK",
            "Gallery"                  : "Galeria",
            "ErrorLoading"             : "Erro ao carregar",
            "Loading"                  : "Carregando",
            "DeleteMessage"            : "Apagar mensagem",
            "SendAgain"                : "Reenviar",
            "CSIReviewLike"            : "Avaliação: Excelente",
            "CSIReviewDislike"         : "Avaliação: Ruim",
            //Статья
            "Send"                     : "Enviar",
            "ArticleReviewSendTitle"   : "Conte para nós o que podemos fazer para melhorar?",
            "Yes"                      : "Sim",
            "No"                       : "Não",
            "ArticleReviewFirstTitle"  : "Esse artigo foi útil?",
            "ArticleReviewSendedTitle" : "Obrigado por nos avaliar!",
            //ФОС
            "Message"                  : "Mensagem",
            "Email"                    : "Enviar",
            "ErrorEmail"               : "Login inválido",
            "MandatoryField"           : "Campo obrigatório",
            "Name"                     : "Nome",
            "TopicTitle"               : "Tema da solicitação ",
            "CustomField"              : "Campo adicional",
            "Error"                    : "Erro",
            "ServerError"              : "O servidor não está respondendo. Verifique sua conexão e tente novamente.",
            "Understand"               : "OK",
            "FeedbackSendedMessage"    : "Sua mensagem foi enviada. Nós responderemos  dentro de um dia útil.",
            "FeedbackText"             : "Todos os atendentes estão ocupados neste momento. Deixe sua mensagem que nós te  responderemos em até um dia útil."
        ]
        return ptLocale
    }
    
    // MARK: - Spanish
    private func getEsLocale() -> [String:String] {
        let esLocale: [String:String] = [
            "Copy"                     : "Copiar",
            "Yesterday"                : "Ayer",
            "Today"                    : "Hoy",
            "Close"                    : "Cerrar",
            "GoToSettings"             : "Ir a la configuración",
            "AllowMedia"               : "Permitir el acceso a medios digitales y archivos",
            "AllowCamera"              : "Permitir el acceso a la cámara",
            "ToSendMedia"              : "Para enviar foto / video",
            "Article"                  : "Artículo",
            "Category"                 : "Categoría",
            "KnowlengeBase"            : "Base de conocimientos",
            "Search"                   : "Buscar",
            "Cancel"                   : "Cancelar",
            "ArticleReviewForSubject"  : "Revisión del artículo",
            "KnowlengeBaseTag"         : "Base de conocimiento",
            "OnlineChat"               : "Chat en línea",
            "Chat"                     : "Charla",
            "File"                     : "Archivo",
            "File2"                    : "Archivo",
            "File3"                    : "Archivo",
            "Attach"                   : "Adjuntar",
            "Write"                    : "Escribir",
            "AttachmentLimit"          : "Se alcanzó el límite de archivos adjuntos",
            "Ok"                       : "OK",
            "Gallery"                  : "Galería",
            "ErrorLoading"             : "Error al cargar",
            "Loading"                  : "Cargando",
            "DeleteMessage"            : "Borrar mensaje",
            "SendAgain"                : "Reenviar",
            "CSIReviewLike"            : "Satisfacción: Excelente",
            "CSIReviewDislike"         : "Satisfacción: Pobre",
            //Статья
            "Send"                     : "Enviar",
            "ArticleReviewSendTitle"   : "¿Háganos saber cómo podríamos hacerlo mejor",
            "Yes"                      : "si",
            "No"                       : "No",
            "ArticleReviewFirstTitle"  : "¿Te resultó útil este artículo",
            "ArticleReviewSendedTitle" : "¡Gracias por revisar!",
            //ФОС
            "Message"                  : "Mensaje",
            "Email"                    : "Correo",
            "ErrorEmail"               : "Ingreso invalido",
            "MandatoryField"           : "Campo obligatorio",
            "Name"                     : "Nombre",
            "TopicTitle"               : "El tema de la solicitud",
            "CustomField"              : "Campo adicional",
            "Error"                    : "Error",
            "ServerError"              : "El servidor no responde. Verifique su conexión y vuelva a intentarlo.",
            "Understand"               : "OK",
            "FeedbackSendedMessage"    : "Tu mensaje ha sido enviado. Le responderemos dentro de un día hábil.",
            "FeedbackText"             : "Todos los agentes están ocupados en este momento. Deje su mensaje que te responderemos en un día hábil. "
        ]
        return esLocale
    }
}
