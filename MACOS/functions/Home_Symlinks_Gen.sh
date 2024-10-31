#!/bin/bash

# ======================================================================== CONFIGURATION

# Destination directory
DESTINATION="$HOME/syncthing/MacBook14ProM3/akunito"

# Array of directories and files to exclude
EXCLUDE=(
    "$HOME/.cache" 
    "$HOME/.DS_Store" 
    "$HOME/Applications" 
    "$HOME/Documents" 
    "$HOME/Downloads" 
    "$HOME/Library" 
    "$HOME/pCloud Drive" 
    "$HOME/Pictures" 
    "$HOME/Public" 
    "$HOME/syncthing" 
    "$HOME/Volumes" 
    "$HOME/.Trash"
    "$HOME/.tmux"
    "$HOME/.tmux.conf"
)

# Files that were Excluded and need to be backed up to $DESTINATION
files_to_backup=(
    "$HOME/Library" 
    "$HOME/.tmux"
    "$HOME/.tmux.conf"
)

# Array of elements to ignore when creating symlinks
EXCLUDE_SYMLINKS=( 
    # "$HOME/.zshrc" 
)

# ======================================================================== FUNCTIONS

# Gather all non-symlink, first-level files and directories from $HOME, excluding items in $EXCLUDE
gather_items() {
    ITEMS=()
    while IFS= read -r -d '' item; do
        # Skip if item is the main directory ($HOME) or a symlink
        [[ "$item" == "$HOME" ]] && continue
        [[ -L "$item" ]] && continue

        # Skip if item is in EXCLUDE array
        skip=false
        for excluded in "${EXCLUDE[@]}"; do
            if [[ "$item" == "$excluded" ]]; then
                skip=true
                break
            fi
        done
        [[ "$skip" == true ]] && continue # Skip if item is in EXCLUDE

        # Add item to ITEMS array
        ITEMS+=("$item")
    done < <(find "$HOME" -maxdepth 1 -print0)
}


# Move items from $HOME to $DESTINATION, removing only those that are successfully copied
move_items_to_destination() {
    echo -e "\nPreviewing items to be moved to $DESTINATION:"
    
    # Preview the operations first
    for item in "${ITEMS[@]}"; do
        base_name=$(basename "$item")
        dest_path="$DESTINATION/$base_name"
        echo "Will move: $item -> $dest_path"
    done

    echo -e "\nPress any key to continue or Ctrl+C to abort..."
    read -n 1 -s
    
    echo -e "\nMoving items to $DESTINATION"
    
    # Create an array to keep track of successfully copied items
    copied_items=()

    # Loop through each item and copy it individually
    for item in "${ITEMS[@]}"; do
        base_name=$(basename "$item")
        dest_path="$DESTINATION/$base_name"
        
        # Remove existing destination if it exists
        if [ -e "$dest_path" ]; then
            rm -rf "$dest_path"
        fi
        
        if cp -r "$item" "$dest_path"; then
            copied_items+=("$item") # Add item to copied_items if cp is successful
        else
            echo "Failed to copy: $item"
        fi
    done

    # Remove only the items that were successfully copied
    for item in "${copied_items[@]}"; do
        rm -rf "$item"
        echo "Removed: $item"
    done
}

# Gather all non-symlink, first-level files and directories in $DESTINATION
gather_symlinks() {
    SYMLINKS=()
    while IFS= read -r entry; do
        # Skip the main directory ($DESTINATION)
        [[ "$entry" == "$DESTINATION" ]] && continue

        SYMLINKS+=("$entry")
    done < <(find "$DESTINATION" -maxdepth 1 -type f -o -type d ! -type l)

    # Filter out items listed in EXCLUDE_SYMLINKS
    for exclude in "${EXCLUDE_SYMLINKS[@]}"; do
        SYMLINKS=("${SYMLINKS[@]/$exclude}")
    done
}

# Create symlinks in $HOME for each entry in $SYMLINKS
create_symlinks() {
    echo -e "\nPreviewing symlinks to be created:"
    for entry in "${SYMLINKS[@]}"; do
        base_name=$(basename "$entry")
        target="$HOME"
        echo "Will create: ln -sf \"$entry\" \"$target\""
    done

    echo -e "\nPress any key to continue or Ctrl+C to abort..."
    read -n 1 -s

    echo -e "\nCreating symlinks..."
    for entry in "${SYMLINKS[@]}"; do
        base_name=$(basename "$entry")
        target="$HOME"
        ln -sf "$entry" "$target"
        echo "Created symlink: $target -> $entry"
    done
}

# Clean up broken symlinks in $HOME directory
cleanup_broken_symlinks() {
    echo -e "\nSearching for broken symlinks in $HOME..."
    
    # Find all broken symlinks in HOME directory
    broken_links=()
    while IFS= read -r -d '' link; do
        broken_links+=("$link")
    done < <(find "$HOME" -maxdepth 1 -type l ! -exec test -e {} \; -print0)

    if [ ${#broken_links[@]} -eq 0 ]; then
        echo "No broken symlinks found."
        return
    fi

    echo -e "\nPreviewing broken symlinks to be removed:"
    for link in "${broken_links[@]}"; do
        echo "Will remove: $link -> $(readlink "$link")"
    done

    echo -e "\nPress any key to continue or Ctrl+C to abort..."
    read -n 1 -s

    echo -e "\nRemoving broken symlinks..."
    for link in "${broken_links[@]}"; do
        rm "$link"
        echo "Removed: $link"
    done
}

# Function to backup specified files
backup_files() {
    echo -e "\nBacking up specified files..."
    for file in "${files_to_backup[@]}"; do
        cp -r "$file" "$DESTINATION"
        echo "Backed up: $file"
    done
    echo -e "\nBackup complete."
}

# ======================================================================== MAIN EXECUTION FLOW

echo -e "\nStarting synchronization script..."

# Gather items in $HOME that are not symlinks and not in $EXCLUDE
gather_items
echo -e "\nExclude list:"
printf '%s\n' "${EXCLUDE[@]}"
echo -e "\nItems to move:"
printf '%s\n' "${ITEMS[@]}"

# Move items to $DESTINATION
move_items_to_destination

# Gather non-symlink items in $DESTINATION and filter out items in $EXCLUDE_SYMLINKS
gather_symlinks
echo -e "\nNon-symlink files and directories in $DESTINATION:"
printf '%s\n' "${SYMLINKS[@]}"

# Create symlinks in $HOME for each entry in $SYMLINKS
create_symlinks

# Remove broken symlinks in $HOME
cleanup_broken_symlinks

# backup given files in $files_to_backup to $DESTINATION
backup_files
