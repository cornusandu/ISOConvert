import sys
from utils import folder_to_iso

if len(sys.argv) != 2:
    print("Usage: python foldertoiso.py <folder_path>")
    sys.exit(1)

folder_path = sys.argv[1]
output_path = folder_to_iso(folder_path)
print(f"ISO created at {output_path}")
