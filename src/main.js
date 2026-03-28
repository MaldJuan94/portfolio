import './style.css'
import { initI18n, setLang, t, getLang } from './i18n/index.js'

// ─── Expose to HTML onclick handlers ────────────────────────
window.handleSetLang = (lang) => { setLang(lang); renderDynamic() }
window.openModal    = openVideoModal
window.openImgModal = openImgModal
window.closeMobileMenu = closeMobileMenu
window.toggleMobileMenu = toggleMobileMenu

// ─── Init ────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', () => {
  initI18n()
  renderDynamic()
  setupNav()
  setupScrollReveal()
  setupCounters()
  buildMarquee()
  setupModal()
  setupResponsive()
})

// ─── Dynamic content (re-runs on lang change) ────────────────
function renderDynamic() {
  renderBullets('ml-bullets',     t('experience.mercadolibre.bullets'))
  renderBullets('pragma-bullets', t('experience.pragma.bullets'))
  renderBio()
  renderSkills()
  renderCerts()
}

function renderBullets(id, bullets) {
  const el = document.getElementById(id)
  if (!el || !Array.isArray(bullets)) return
  el.innerHTML = bullets.map(b =>
    `<li style="display:flex;gap:8px;font-size:0.85rem;color:var(--muted);">
       <span style="color:var(--accent);flex-shrink:0;margin-top:2px;">▸</span>
       <span>${b}</span>
     </li>`
  ).join('')
}

function renderBio() {
  const el = document.getElementById('bio-text')
  if (el) el.textContent = t('about.bio')
}

function renderSkills() {
  const el = document.getElementById('skills-grid')
  if (!el) return
  const groups = [
    { key: 'Core Android', pills: ['Kotlin','Java','Jetpack Compose','MVVM','Clean Architecture','Dagger Hilt','Room','Retrofit','Coroutines/Flow','Navigation'] },
    { key: 'Testing',      pills: ['JUnit','Mockito','Appium','Cucumber','E2E'] },
    { key: 'Security',     pills: ['OWASP Mobile Top 10','Secure Coding','Auth/Authz'] },
    { key: 'CI/CD',        pills: ['GitHub Actions','Azure DevOps','Jenkins','GitFlow'] },
    { key: 'Observability',pills: ['DataDog','Kibana','NewRelic'] },
    { key: 'Mobile',       pills: ['Flutter/Dart','PWA'] },
    { key: 'Backend',      pills: ['Django','Spring Boot','Python','PHP'] },
    { key: 'Hardware',     pills: ['ESP32','Arduino','CNC / G-Code','Firebase IoT'] },
  ]
  el.innerHTML = groups.map(g => `
    <div style="margin-bottom:16px;">
      <div class="skill-group-title">${g.key}</div>
      <div>${g.pills.map(p => `<span class="skill-pill">${p}</span>`).join('')}</div>
    </div>
  `).join('')
}

function renderCerts() {
  const el = document.getElementById('certs-list')
  if (!el) return
  const certs = t('about.cert_items')
  if (!Array.isArray(certs)) return
  el.innerHTML = certs.map(c => `
    <div style="display:flex;gap:10px;align-items:flex-start;padding:10px 14px;background:var(--surface);border:1px solid var(--border);border-radius:8px;">
      <span style="color:var(--accent);flex-shrink:0;margin-top:2px;">✓</span>
      <span style="font-size:0.85rem;color:var(--muted);">${c}</span>
    </div>
  `).join('')
}

// ─── NAV scroll effect ────────────────────────────────────────
function setupNav() {
  const nav = document.getElementById('navbar')
  window.addEventListener('scroll', () => {
    nav.classList.toggle('scrolled', window.scrollY > 40)
  }, { passive: true })
}

// ─── Mobile menu ─────────────────────────────────────────────
function toggleMobileMenu() {
  document.getElementById('mobile-menu').classList.toggle('open')
}
function closeMobileMenu() {
  document.getElementById('mobile-menu').classList.remove('open')
}

// ─── Responsive: show/hide hamburger ─────────────────────────
function setupResponsive() {
  const hamburger = document.getElementById('hamburger')
  const desktopNav = document.querySelector('.desktop-nav')
  const mq = window.matchMedia('(max-width: 768px)')
  const handle = (e) => {
    hamburger.style.display = e.matches ? 'flex' : 'none'
    if (desktopNav) desktopNav.style.display = e.matches ? 'none' : 'flex'
  }
  handle(mq)
  mq.addEventListener('change', handle)
}

// ─── Scroll reveal ────────────────────────────────────────────
function setupScrollReveal() {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(e => {
      if (e.isIntersecting) {
        e.target.classList.add('visible')
        observer.unobserve(e.target)
      }
    })
  }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' })

  document.querySelectorAll('.reveal').forEach(el => observer.observe(el))
}

// ─── Stat counters ────────────────────────────────────────────
function setupCounters() {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(e => {
      if (!e.isIntersecting) return
      const el = e.target
      const target = parseInt(el.dataset.counter)
      const suffix = el.dataset.suffix ?? ''
      animateCounter(el, target, suffix)
      observer.unobserve(el)
    })
  }, { threshold: 0.5 })

  document.querySelectorAll('[data-counter]').forEach(el => observer.observe(el))
}

function animateCounter(el, target, suffix) {
  const duration = 1500
  const start = performance.now()
  const frame = (now) => {
    const elapsed = now - start
    const progress = Math.min(elapsed / duration, 1)
    const eased = 1 - Math.pow(1 - progress, 3) // ease-out-cubic
    el.textContent = Math.floor(eased * target) + suffix
    if (progress < 1) requestAnimationFrame(frame)
  }
  requestAnimationFrame(frame)
}

// ─── Marquee ─────────────────────────────────────────────────
function buildMarquee() {
  const row1 = ['Kotlin','Android','Jetpack Compose','MVVM','Clean Architecture','Dagger Hilt','Room','Retrofit','Coroutines','Flow','Navigation Component']
  const row2 = ['Appium','OWASP Mobile','CI/CD','DataDog','Kibana','Firebase','Django','Flutter','Spring Boot','GitHub Actions','Fintech']

  const buildItems = (items) =>
    items.map(i => `<span class="marquee-item"><span class="marquee-dot"></span>${i}</span>`).join('')

  const fill = (id, items) => {
    const el = document.getElementById(id)
    if (!el) return
    const html = buildItems(items)
    el.innerHTML = html + html // duplicate for seamless loop
  }

  fill('marquee-1', row1)
  fill('marquee-2', row2)
}

// ─── Video Modal ──────────────────────────────────────────────
function setupModal() {
  const modal   = document.getElementById('video-modal')
  const video   = document.getElementById('modal-video')
  const closeBtn = document.getElementById('modal-close')

  closeBtn.addEventListener('click', closeModal)
  modal.addEventListener('click', (e) => { if (e.target === modal) closeModal() })
  document.addEventListener('keydown', (e) => { if (e.key === 'Escape') closeModal() })

  function closeModal() {
    modal.classList.remove('open')
    video.pause()
    video.src = ''
  }
}

function openVideoModal(src) {
  const modal = document.getElementById('video-modal')
  const video = document.getElementById('modal-video')
  // Replace img modal content if open
  modal.innerHTML = `
    <button id="modal-close" aria-label="Close">✕</button>
    <video id="modal-video" controls playsinline autoplay></video>
  `
  modal.querySelector('#modal-close').addEventListener('click', () => {
    modal.classList.remove('open')
    modal.querySelector('video')?.pause()
  })
  modal.querySelector('video').src = src
  modal.classList.add('open')
}

function openImgModal(src) {
  const modal = document.getElementById('video-modal')
  modal.innerHTML = `
    <button id="modal-close" style="position:absolute;top:20px;right:24px;background:rgba(255,255,255,0.1);border:none;color:#fff;font-size:1.5rem;width:40px;height:40px;border-radius:50%;cursor:pointer;display:flex;align-items:center;justify-content:center;">✕</button>
    <img src="${src}" style="max-width:min(90vw,1100px);max-height:85vh;border-radius:12px;object-fit:contain;" alt="Gallery image" />
  `
  modal.querySelector('#modal-close').addEventListener('click', () => modal.classList.remove('open'))
  modal.classList.add('open')
}
