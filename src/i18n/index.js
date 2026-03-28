import en from './en.json'
import es from './es.json'

const locales = { en, es }

const storedLang = localStorage.getItem('lang')
const browserLang = navigator.language?.startsWith('es') ? 'es' : 'en'
let current = storedLang || browserLang

export function t(key) {
  return key.split('.').reduce((obj, k) => obj?.[k], locales[current]) ?? key
}

export function getLang() {
  return current
}

export function setLang(lang) {
  current = lang
  localStorage.setItem('lang', lang)
  document.documentElement.lang = lang

  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.dataset.i18n
    const val = t(key)
    if (el.tagName === 'INPUT' || el.tagName === 'TEXTAREA') {
      el.placeholder = val
    } else {
      el.textContent = val
    }
  })

  document.querySelectorAll('[data-i18n-html]').forEach(el => {
    el.innerHTML = t(el.dataset.i18nHtml)
  })

  document.querySelectorAll('[data-lang-btn]').forEach(btn => {
    btn.classList.toggle('lang-active', btn.dataset.langBtn === lang)
  })
}

export function initI18n() {
  setLang(current)
}
