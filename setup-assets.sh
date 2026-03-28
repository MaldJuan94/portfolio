#!/usr/bin/env bash
# setup-assets.sh — run once from personalDev/portfolio/
# Requires: ffmpeg  (brew install ffmpeg)
# Usage:    chmod +x setup-assets.sh && ./setup-assets.sh

set -e

SRC="../recursos"
DST="public/assets"

# ─── encode_video SRC DST COMPRESSION AUDIO [START] [END] ───────
# COMPRESSION : normal | high
# AUDIO       : yes | no
# START / END : HH:MM:SS or MM:SS  (optional — omit for full video)
encode_video() {
  local src="$1" dst="$2" compression="$3" audio="$4"
  local start="${5:-}" end="${6:-}"

  local crf preset
  if [[ "$compression" == "high" ]]; then
    crf=28; preset="slow"
  else
    crf=23; preset="medium"
  fi

  local audio_flags
  if [[ "$audio" == "yes" ]]; then
    audio_flags="-acodec aac -b:a 128k"
  else
    audio_flags="-an"
  fi

  local trim_flags=""
  [[ -n "$start" ]] && trim_flags="-ss $start"
  [[ -n "$end"   ]] && trim_flags="$trim_flags -to $end"

  # shellcheck disable=SC2086
  ffmpeg -y $trim_flags -i "$src" \
    -vcodec libx264 -crf "$crf" -preset "$preset" \
    $audio_flags \
    -vf "scale=-2:'min(720,ih)'" \
    "$dst"
}

echo "📁 Creating asset directories..."
mkdir -p \
  "$DST/thread-art-app" "$DST/thread-studio" "$DST/cnc-machine" \
  "$DST/inspection-app" "$DST/open-door-app" "$DST/open-door-pwa" \
  "$DST/stories-app"    "$DST/rescue-game"   "$DST/track-app" \
  "$DST/track-admin"    "$DST/quiz-web"      "$DST/fastory" \
  "$DST/simple-crm"     "$DST/shared/esp32"

# ═══════════════════════════════════════════════════════════════
# 1. THREAD ART APP  (threadart)
# ═══════════════════════════════════════════════════════════════
echo ""
echo "🧵 Thread Art App — encoding videos..."
encode_video "$SRC/threadart/app.mp4"         "$DST/thread-art-app/demo.mp4"       normal no
encode_video "$SRC/threadart/darth_video.mp4" "$DST/thread-art-app/darth-demo.mp4" normal no

echo "🧵 Thread Art App — copying images..."
cp "$SRC/threadart/index.png"         "$DST/thread-art-app/screenshot.png"
cp "$SRC/threadart/cat_final.jpeg"    "$DST/thread-art-app/result-cat.jpeg"
cp "$SRC/threadart/cat_software.jpg"  "$DST/thread-art-app/result-software.jpg"
cp "$SRC/threadart/darth_final.jpg"   "$DST/thread-art-app/result-darth.jpg"
cp "$SRC/threadart/darth_tejiendo.jpg" "$DST/thread-art-app/weaving.jpg"
cp "$SRC/threadart/fallo1.jpg"        "$DST/thread-art-app/failure-1.jpg"
cp "$SRC/threadart/fallo2.jpg"        "$DST/thread-art-app/failure-2.jpg"
cp "$SRC/threadart/proceso_fallo.jpg" "$DST/thread-art-app/failure-process.jpg"

# ═══════════════════════════════════════════════════════════════
# 2. THREAD ART STUDIO  (Thread)
# ═══════════════════════════════════════════════════════════════
echo ""
echo "🖥️  Thread Studio — encoding videos..."
encode_video "$SRC/Thread/desktop.mov" "$DST/thread-studio/demo.mp4" normal no

echo "🖥️  Thread Studio — copying images..."
cp "$SRC/Thread/index.png"          "$DST/thread-studio/screenshot.png"
cp "$SRC/Thread/mariposa_final.jpg" "$DST/thread-studio/result-butterfly.jpg"

# ═══════════════════════════════════════════════════════════════
# 2b. CNC MACHINE  (assets from Thread + threadart)
# ═══════════════════════════════════════════════════════════════
echo ""
echo "🔩 CNC Machine — encoding videos..."
encode_video "$SRC/Thread/drill_cnc.mp4" "$DST/cnc-machine/drill-phase.mp4" normal yes
encode_video "$SRC/Thread/tejer_cnc.mp4" "$DST/cnc-machine/weave-phase.mp4" normal no

echo "🔩 CNC Machine — copying images..."
cp "$SRC/threadart/darth_tejiendo.jpg" "$DST/cnc-machine/machine-weaving.jpg"
cp "$SRC/threadart/darth_final.jpg"    "$DST/cnc-machine/result-darth.jpg"
cp "$SRC/threadart/cat_final.jpeg"     "$DST/cnc-machine/result-cat.jpg"
cp "$SRC/Thread/mariposa_final.jpg"    "$DST/cnc-machine/result-butterfly.jpg"
cp "$SRC/threadart/fallo1.jpg"         "$DST/cnc-machine/failure-1.jpg"
cp "$SRC/threadart/fallo2.jpg"         "$DST/cnc-machine/failure-2.jpg"
cp "$SRC/threadart/proceso_fallo.jpg"  "$DST/cnc-machine/failure-process.jpg"

# ═══════════════════════════════════════════════════════════════
# 3. INSPECTION PROPERTIES APP  (inspection_checklist)
# ═══════════════════════════════════════════════════════════════
echo ""
echo "📋 Inspection App — encoding videos..."
encode_video "$SRC/inspection_checklist/index.mp4" "$DST/inspection-app/demo.mp4" normal no

echo "📋 Inspection App — copying images..."
cp "$SRC/inspection_checklist/index_app.jpg"      "$DST/inspection-app/screenshot.jpg"
cp "$SRC/inspection_checklist/compartir.jpg"      "$DST/inspection-app/share-export.jpg"
cp "$SRC/inspection_checklist/evaluar_item.jpg"   "$DST/inspection-app/item-evaluation.jpg"
cp "$SRC/inspection_checklist/Floor plan.jpg"     "$DST/inspection-app/floor-plan-sheet.jpg"
cp "$SRC/inspection_checklist/Foor_plant_map.jpg" "$DST/inspection-app/floor-plan-map.jpg"
cp "$SRC/inspection_checklist/help_menu.jpg"      "$DST/inspection-app/help-menu.jpg"
cp "$SRC/inspection_checklist/lista_chequeo.jpg"  "$DST/inspection-app/checklist.jpg"
cp "$SRC/inspection_checklist/nueo_proyecto.jpg"  "$DST/inspection-app/new-project.jpg"

# ═══════════════════════════════════════════════════════════════
# 4. OPEN DOOR APP  (OpenDoorApp)
# ═══════════════════════════════════════════════════════════════
echo ""
echo "🚪 Open Door App — encoding videos..."
encode_video "$SRC/OpenDoorApp/open_door_app.mp4"    "$DST/open-door-app/demo-app.mp4"    normal no
encode_video "$SRC/OpenDoorApp/open_door_widget.mp4" "$DST/open-door-app/demo-widget.mp4" normal no

echo "🚪 Open Door App — copying images..."
cp "$SRC/OpenDoorApp/index_dark.png" "$DST/open-door-app/screenshot-dark.png"
cp "$SRC/OpenDoorApp/index.png"      "$DST/open-door-app/screenshot-light.png"

# ═══════════════════════════════════════════════════════════════
# 5. OPEN DOOR PWA  (AutomaticDoor)
# ═══════════════════════════════════════════════════════════════
echo ""
echo "🌐 Open Door PWA — encoding videos..."
encode_video "$SRC/AutomaticDoor/app.mp4"       "$DST/open-door-pwa/demo.mp4"           normal no
encode_video "$SRC/AutomaticDoor/esp_relay.mp4" "$DST/shared/esp32/relay-activated.mp4" normal yes
encode_video "$SRC/AutomaticDoor/esp.mp4"       "$DST/shared/esp32/esp32-boot.mp4"      normal yes

echo "🌐 Open Door PWA — copying images..."
cp "$SRC/AutomaticDoor/index.png" "$DST/open-door-pwa/screenshot.png"

# ═══════════════════════════════════════════════════════════════
# 6. STORIES APP  (stories_app)
# ═══════════════════════════════════════════════════════════════
echo ""
echo "📚 Stories App — encoding videos..."
encode_video "$SRC/stories_app/app.mp4" "$DST/stories-app/demo.mp4" normal yes

echo "📚 Stories App — copying images..."
cp "$SRC/stories_app/index.png" "$DST/stories-app/screenshot.png"

# ═══════════════════════════════════════════════════════════════
# 7. RESCUE GAME  (rescue)  — high compression
# ═══════════════════════════════════════════════════════════════
echo ""
echo "🎮 Rescue Game — encoding video (high compression)..."
encode_video "$SRC/rescue/vide.mp4" "$DST/rescue-game/gameplay.mp4" high no

echo "🎮 Rescue Game — copying images..."
cp "$SRC/rescue/index.png" "$DST/rescue-game/screenshot.png"

# ═══════════════════════════════════════════════════════════════
# 8. TRACK APP  (imachine)
# ═══════════════════════════════════════════════════════════════
echo ""
echo "📡 Track App — encoding videos..."
encode_video "$SRC/imachine/funcion_offline_sync.mp4" "$DST/track-app/demo-offline-sync.mp4" normal no
encode_video "$SRC/imachine/funcion_online.mp4"       "$DST/track-app/demo-online.mp4"       normal no

echo "📡 Track App — copying images..."
cp "$SRC/imachine/permisos.png" "$DST/track-app/permissions.png"
cp "$SRC/imachine/index.png"    "$DST/track-app/screenshot.png"

# ═══════════════════════════════════════════════════════════════
# 9. TRACK ADMIN  (TrackAdmin)  — trim 0:57 → 2:00
# ═══════════════════════════════════════════════════════════════
echo ""
echo "🗺️  Track Admin — encoding video (trim 0:57–2:00)..."
encode_video "$SRC/TrackAdmin/admin.mov" "$DST/track-admin/demo.mp4" normal no "00:00:57" "00:02:00"

echo "🗺️  Track Admin — copying images..."
cp "$SRC/TrackAdmin/index.png" "$DST/track-admin/screenshot.png"

# ═══════════════════════════════════════════════════════════════
# 10. QUIZ PLATFORM WEB  (QuizWeb)  — trim 0:08 → 1:37
# ═══════════════════════════════════════════════════════════════
echo ""
echo "❓ QuizWeb — encoding videos..."
encode_video "$SRC/QuizWeb/web_desktop.mov" "$DST/quiz-web/demo-desktop.mp4" normal no "00:00:08" "00:01:37"
encode_video "$SRC/QuizWeb/web_mobile.mp4"  "$DST/quiz-web/demo-mobile.mp4"  normal no

echo "❓ QuizWeb — copying images..."
cp "$SRC/QuizWeb/index.png" "$DST/quiz-web/screenshot.png"

# ═══════════════════════════════════════════════════════════════
# 11. FASTORY  (Quicktory)  — trim 0:26 → 3:00
# ═══════════════════════════════════════════════════════════════
echo ""
echo "🍕 Fastory — encoding video (trim 0:26–3:00)..."
encode_video "$SRC/Quicktory/fastory_web.mov" "$DST/fastory/demo.mp4" normal no "00:00:26" "00:03:00"

echo "🍕 Fastory — copying images..."
cp "$SRC/Quicktory/index.png" "$DST/fastory/screenshot.png"

# ═══════════════════════════════════════════════════════════════
# 12. SIMPLE CRM  (SimpleCRM)  — trim end at 4:45
# ═══════════════════════════════════════════════════════════════
echo ""
echo "🏦 SimpleCRM — encoding video (trim → 4:45)..."
encode_video "$SRC/SimpleCRM/web_desktop.mov" "$DST/simple-crm/demo.mp4" normal no "" "00:04:45"

echo "🏦 SimpleCRM — copying images..."
cp "$SRC/SimpleCRM/home.png"           "$DST/simple-crm/home.png"
cp "$SRC/SimpleCRM/reports.png"        "$DST/simple-crm/reports.png"
cp "$SRC/SimpleCRM/transfer_black.png" "$DST/simple-crm/transfer-dark.png"
cp "$SRC/SimpleCRM/transfer_white.png" "$DST/simple-crm/transfer-light.png"

echo ""
echo "✅ Done! Assets ready in $DST"
echo "   Run: npm run dev"
