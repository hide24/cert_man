import I18n from '../packs/locales/i18n.js'
import '../packs/locales/ja.js'
import '../packs/locales/en.js'

export default {
  methods: {
    t: (...args) => I18n.t(...args),
    currentLocale: () => I18n.currentLocale(),
    tm(modelName) {
      return I18n.t(`activerecord.models.${modelName}`)
    },
    ta(modelName, attributeName) {
      return I18n.t(`activerecord.attributes.${modelName}.${attributeName}`)
    },
  },
}
