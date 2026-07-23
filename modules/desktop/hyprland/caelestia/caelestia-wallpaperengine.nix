{ pkgs }:
pkgs.writeShellApplication {
  name = "caelestia-wallpaperengine";
  runtimeInputs = with pkgs; [
    coreutils
    linux-wallpaperengine
    python3
  ];
  text = ''
        set -euo pipefail

        state_home="''${XDG_STATE_HOME:-$HOME/.local/state}"
        state_dir="$state_home/caelestia/wallpaperengine"
        pid_file="$state_dir/pid"
        mappings_file="$state_dir/mappings.json"

        strip_file_url() {
          printf '%s\n' "''${1#file://}"
        }

        monitor_file() {
          printf '%s/%s\n' "$state_dir" "$1"
        }

        managed_pid_is_alive() {
          [ -n "$1" ] && [ -L "/proc/$1/exe" ] && [ "$(basename "$(readlink "/proc/$1/exe")")" = "linux-wallpaperengine" ]
        }

        write_empty_mappings() {
          mkdir -p "$state_dir"
          tmp_file="$(mktemp "$state_dir/mappings.json.XXXXXX")"
          printf '{}\n' > "$tmp_file"
          mv "$tmp_file" "$mappings_file"
        }

        write_mappings() {
          mkdir -p "$state_dir"
          python3 - "$state_dir" "$mappings_file" <<'PY'
    import json
    import os
    import sys

    state_dir, mappings_file = sys.argv[1:3]
    data = {}
    for name in sorted(os.listdir(state_dir)):
        if name in {"pid", "mappings.json"}:
            continue
        path = os.path.join(state_dir, name)
        if not os.path.isfile(path):
            continue
        with open(path, encoding="utf-8") as f:
            project_id = f.read().strip()
        if project_id:
            data[name] = project_id
    tmp = mappings_file + ".tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False)
    os.replace(tmp, mappings_file)
    PY
        }

        stop_managed() {
          if [ -f "$pid_file" ]; then
            pid="$(<"$pid_file")"
            if managed_pid_is_alive "$pid"; then
              kill "$pid"
              for _ in 1 2 3 4 5; do
                kill -0 "$pid" 2>/dev/null || break
                sleep 0.2
              done
              if kill -0 "$pid" 2>/dev/null; then
                kill -KILL "$pid"
                sleep 0.2
              fi
            fi
            rm -f "$pid_file"
          fi
        }

        restart_managed() {
          mkdir -p "$state_dir"
          stop_managed

          shopt -s nullglob
          local files=("$state_dir"/*)
          shopt -u nullglob

          local args=(--silent --fps 60 --disable-mouse --no-fullscreen-pause)
          local file monitor project_id

          for file in "''${files[@]}"; do
            monitor="$(basename "$file")"
            if [ "$monitor" = "pid" ] || [ "$monitor" = "mappings.json" ]; then
              continue
            fi

            project_id="$(<"$file")"
            if [ -n "$project_id" ]; then
              args+=(--screen-root "$monitor" --bg "$project_id")
            fi
          done

          if [ "''${#args[@]}" -eq 5 ]; then
            write_empty_mappings
            return
          fi

          linux-wallpaperengine "''${args[@]}" >/dev/null 2>&1 &
          pid="$!"
          printf '%s\n' "$pid" > "$pid_file"
          sleep 0.2
          if managed_pid_is_alive "$pid"; then
            write_mappings
            return
          fi

          rm -f "$pid_file"
          write_empty_mappings
        }

        resolve_project_id() {
          local preview_path
          preview_path="$(strip_file_url "$1")"
          preview_path="$(realpath "$preview_path")"
          basename "$(dirname "$preview_path")"
        }

        save_scheme() {
          local preview_path scheme_dir tmp_file scheme_file
          preview_path="$(strip_file_url "$1")"
          shift
          scheme_dir="$state_home/caelestia"
          scheme_file="$scheme_dir/scheme.json"
          mkdir -p "$scheme_dir"
          tmp_file="$(mktemp "$scheme_dir/scheme.json.XXXXXX")"
          caelestia wallpaper -p "$preview_path" "$@" > "$tmp_file"
          mv "$tmp_file" "$scheme_file"
        }

        case "''${1:-}" in
          start)
            restart_managed
            ;;
          set)
            mkdir -p "$state_dir"
            printf '%s\n' "$(resolve_project_id "$3")" > "$(monitor_file "$2")"
            restart_managed
            ;;
          clear)
            mkdir -p "$state_dir"
            rm -f "$(monitor_file "$2")"
            restart_managed
            ;;
          scheme)
            shift
            save_scheme "$@"
            ;;
          *)
            exit 1
            ;;
        esac
  '';
}
