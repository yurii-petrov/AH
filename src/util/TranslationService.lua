local TranslationService = {}

TranslationService.supportedLanguages = {"eng", "ukr"}
TranslationService.currentLanguage = "ukr"

TranslationService.translations = {
  -- Дослідники
  ["agnes baker"] = {
    ["eng"] = "Agnes Baker",
    ["ukr"] = "Агнес Бейкер"
  },
  ["calvin wright"] = {
    ["eng"] = "Calvin Wright",
    ["ukr"] = "Келвін Райт"
  },
  ["daniela reyes"] = {
    ["eng"] = "Daniela Reyes",
    ["ukr"] = "Даніела Реєс"
  },
  ["dexter drake"] = {
    ["eng"] = "Dexter Drake",
    ["ukr"] = "Декстер Дрейк"
  },
  ["jenny barnes"] = {
    ["eng"] = "Jenny Barnes",
    ["ukr"] = "Дженні Барнс"
  },
  ["marie lambeau"] = {
    ["eng"] = "Marie Lambeau",
    ["ukr"] = "Марі Ламбо"
  },
  ["michael mcglen"] = {
    ["eng"] = "Michael McGlen",
    ["ukr"] = "Майкл МакГлен"
  },
  ["minh thi phan"] = {
    ["eng"] = "Minh Thi Phan",
    ["ukr"] = "Мін Тхі Фан"
  },
  ["norman withers"] = {
    ["eng"] = "Norman Withers",
    ["ukr"] = "Норман Візерс"
  },
  ["rex murphy"] = {
    ["eng"] = "Rex Murphy",
    ["ukr"] = "Рекс Мерфі"
  },
  ["tommy muldoon"] = {
    ["eng"] = "Tommy Muldoon",
    ["ukr"] = "Томмі Малдун"
  },
  ["wendy adams"] = {
    ["eng"] = "Wendy Adams",
    ["ukr"] = "Венді Адамс"
  },
  -- райони
  ["downtown"] = {
    ["eng"] = "Downtown",
    ["ukr"] = "Центр"
  },
    ["easttown"] = {
    ["eng"] = "Easttown",
    ["ukr"] = "Східний Квартал"
  },
    ["merchant district"] = {
    ["eng"] = "Merchant District",
    ["ukr"] = "Базар"
  },
    ["miskatonic university"] = {
    ["eng"] = "Miskatonic University",
    ["ukr"] = "Міскатонікський університет"
  },
    ["northside"] = {
    ["eng"] = "Northside",
    ["ukr"] = "Північний Квартал"
  },
    ["rivertown"] = {
    ["eng"] = "Rivertown",
    ["ukr"] = "Набережна"
  },
    ["southside"] = {
    ["eng"] = "Southside",
    ["ukr"] = "Південний Квартал"
  },
    ["uptown"] = {
    ["eng"] = "Uptown",
    ["ukr"] = "Передмістя"
  },
    ["the street"] = {
    ["eng"] = "the street",
    ["ukr"] = "Вулиці"
  },
  -- міфи
  ["doom added"] = {
    ["ukr"] = "приреченість додано"
  }
}

function TranslationService.getCurrentLanguage()
    return TranslationService.currentLanguage
end

function TranslationService.setCurrentLanguage(value)
    TranslationService.currentLanguage = value
end

function TranslationService.getText(originalText)
  if not originalText then return "" end
  local originalText = string.lower(originalText)
  if not TranslationService.translations[originalText] then return originalText end

  return TranslationService.translations[originalText][TranslationService.currentLanguage] or TranslationService.translations[originalText]["eng"] or originalText
end

function TranslationService.getDoomAddText(neighborhoodName)
  return TranslationService.getText(neighborhoodName) .. " - " .. TranslationService.getText("doom added")
end

return TranslationService
