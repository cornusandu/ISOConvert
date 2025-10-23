import sys
from utils import iso_to_folder

if len(sys.argv) != 2:
    sys.exit(1)

folder_path = sys.argv[1]
output_path = iso_to_folder(folder_path)
print(f"Folder created at {output_path}")
