import yaml
import os
import json
import sys


def create_folders(base_path, folders):
    """
    Recursively create folders and subfolders under base_path.
    'folders' can be a list of strings or dicts with subfolders.
    """
    for folder in folders:
        if isinstance(folder, str):
            path = os.path.join(base_path, folder)
            os.makedirs(path, exist_ok=True)
        elif isinstance(folder, dict):
            for key, value in folder.items():
                path = os.path.join(base_path, key)
                os.makedirs(path, exist_ok=True)
                create_folders(path, value)
        try:
            os.makedirs(path, exist_ok=True)
        except PermissionError:
            print(f"Permission denied while creating folder: {path}")
        except Exception as e:
            print(f"Error creating folder {path}: {e}")


def parse_and_create(config_path, base_root):
    with open(config_path, 'r') as f:
        config = yaml.safe_load(f)

    partitions = config.get('filesystem', {}).get('partitions', [])
    partition_info = []

    for part in partitions:
        name = part.get('name')
        mount_point = part.get('mount_point')
        size = part.get('size')
        folders = part.get('folders', [])

        # Calculate absolute path based on base_root and mount_point
        abs_mount_point = mount_point
        if not os.path.isabs(mount_point):
            abs_mount_point = os.path.join(base_root, mount_point)

        # For system partitions (fixed), skip creation to avoid changes
        if size != "fixed":
            print(f"Creating soft partition folders for '{name}' at: {abs_mount_point}")
            os.makedirs(abs_mount_point, exist_ok=True)
            create_folders(abs_mount_point, folders)
        else:
            print(f"Skipping system partition '{name}' folder creation (locked)")

        partition_info.append({
            "name": name,
            "mount_point": abs_mount_point,
            "size": size,
            "folders": folders
        })

    # Return the partition info dict (could be saved or sent to UI)
    return partition_info


def main():
    if len(sys.argv) != 3:
        print("Usage: python partition_parser.py <config_file.yaml> <base_root_path>")
        sys.exit(1)

    config_file = sys.argv[1]
    base_root = sys.argv[2]

    info = parse_and_create(config_file, base_root)
    print("\nPartition structure info (JSON):")
    print(json.dumps(info, indent=2))


if __name__ == "__main__":
    main()
