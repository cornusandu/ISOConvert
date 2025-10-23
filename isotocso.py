import sys
from utils import iso_to_cso

if len(sys.argv) != 2:
    sys.exit(1)

folder_path = sys.argv[1]
output_path = iso_to_cso(folder_path)
print(f".cso created at {output_path}")
