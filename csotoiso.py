import sys
from utils import cso_to_iso

if len(sys.argv) != 2:
    sys.exit(1)

folder_path = sys.argv[1]
output_path = cso_to_iso(folder_path)
print(f".iso created at {output_path}")
