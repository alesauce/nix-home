# Default values
local min_depth=1
local max_depth=999
local start_dir=~/workplace
local ignore_flag=false
local ignore_dirs=()

# Parse command line options
local OPTIND opt
while getopts "m:M:d:i:" opt; do
    case "${opt}" in
      m)
        min_depth=${OPTARG}
        ;;
      M)
        max_depth=${OPTARG}
        ;;
      d)
        start_dir=${OPTARG}
        ;;
      i)
        ignore_flag=true
        ignore_dirs=(${(s: :)OPTARG})
        ;;
      *)
        echo "Usage: fzd [-m min_depth] [-M max_depth] [-d start_dir] [-i ignore_dirs]"
        return 1
        ;;
    esac
done

# First selection: top-level directory with basename only
local top_dir_selection=$(fd . "$start_dir" -L -t d --min-depth 1 --max-depth 1 |
    while read -r top_dir_path; do echo "$(basename "$top_dir_path")|$top_dir_path"; done |
    fzf --prompt="Select top directory: " \
        --with-nth=1 \
        --delimiter="|")

if [ -n "$top_dir_selection" ]; then
    local top_dir=$(echo "$top_dir_selection" | awk -F"|" '{print $2}')

    local fd_args=(. "$top_dir" -L -t d --min-depth "$min_depth" --max-depth "$max_depth")

    if [ "$ignore_flag" = true ]; then
      for dir in "${ignore_dirs[@]}"; do
        fd_args+=(-E "$dir")
      done
    fi

    local sub_dirs=$(fd "${fd_args[@]}")
    if [ -z "$sub_dirs" ]; then
      echo "No subdirectories found in $top_dir with depth min:$min_depth max:$max_depth. Navigating to top directory."
      z "$top_dir"
      return 0
    fi

    echo "Using fd_args: ${fd_args}"
    # Second selection with preview window showing directory contents
    local sub_dir_selection=$(fd "${fd_args[@]}" |
      while read -r top_dir_path; do echo "$(basename "$top_dir_path")|$top_dir_path"; done |
      fzf --prompt="Select subdirectory (min: $min_depth, max: $max_depth): " \
          --with-nth=1 \
          --delimiter="|" \
          --preview="ls {2}" \
          --preview-window=right:50%)

    # Extract the full path from the selection or use top_dir as fallback
    if [ -n "$sub_dir_selection" ]; then
      local final_dir=$(echo "$sub_dir_selection" | awk -F"|" '{print $2}')
      z "$final_dir"
    else
      # Fallback to the top directory if no subdirectory is selected
      echo "No subdirectory selected. Navigating to top directory."
      z "$top_dir"
    fi
fi
